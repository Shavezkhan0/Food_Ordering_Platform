"use client";
import { useRouter } from "next/navigation";
import { useState } from "react";
import { useForm } from "react-hook-form";
import LoadingBar from "react-top-loading-bar";

const ForgotPassword = () => {
  const router = useRouter();

  // const RandomOTP = Math.floor(Math.random() * 1000000)
  const [sendOTP, setSendOTP] = useState(false)
  const [reciveOTP, setreciveOTP] = useState(null)
  const [userEmail, setuserEmail] = useState(null)
  const [progress, setProgress] = useState(0);


  const {
    register,
    handleSubmit,
    watch,
    formState: { errors },
  } = useForm();

  const onSubmit = async (data) => {
    setProgress(20)

    const user = await fetch("/api/forgotpassword", {
      method: "POST",
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(data),
    });
    const userExist = await user.json();
    setuserEmail(data.email)
    setProgress(80)

    if (userExist.success === true) {

      const r = await fetch("/api/emailotp", {
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });
      const res = await r.json();
      if (res.success === true) {
        setSendOTP(true)
        setreciveOTP(res.otp)
      }
    }

    setProgress(100)

  };

  const onSubmitOTP = async (data) => {
    setProgress(50)
    if (parseInt(data.otp) === reciveOTP) {
      setProgress(100)
      router.push(`/changepassword?email=${userEmail}`);
    } else {
      console.error("OTP does not match");
    }
  };

  return (

    <div className='mx-auto mt-8'>
      <LoadingBar
        color="#f11946"
        progress={progress}
        waitingTime={3000}
        onLoaderFinished={() => {
          console.log("Loader finished"); // Debugging statement
          setProgress(0);
        }}
      />
      <div className='flex flex-col gap-3 justify-center items-center w-[90vw] md:w-[30vw] mx-auto border-2 shadow-md py-5 px-2'>
        <h1 className='text-2xl font-bold text-[#c037ea]'>Forgot Password</h1>

        <div>
          <form onSubmit={handleSubmit(onSubmit)} className='flex flex-col gap-2'>
            <div className='flex flex-col justify-center items-center py-2'>
              <div className='flex flex-col justify-center items-center gap-2'>
                <div className='w-full flex gap-5 items-center justify-between'>
                  <label className=''>Email</label>
                  <input
                    type="email"
                    className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1'
                    placeholder='Enter your email'
                    {...register("email")}
                    autoComplete="email"
                  />
                </div>
              </div>
            </div>
            <div className="flex justify-center items-center">
              {
                !sendOTP ? (
                  <button type='submit' className="w-fit text-center mt-2 gap-2 font-semibold text-black bg-[#d17ceb] border-0 py-2 px-5 md:px-6 focus:outline-none hover:bg-[#9f35c0] rounded text-sm md:text-base">Continue</button>
                ) : (<></>)
              }
            </div>
          </form>

          {
            sendOTP ? (<form onSubmit={handleSubmit(onSubmitOTP)} className='flex flex-col gap-2'>
              <div className='flex flex-col justify-center items-center py-2'>
                <div className='flex flex-col justify-center items-center gap-2'>
                  <div className='w-full flex gap-5 items-center justify-between'>
                    <label className=''>OTP</label>
                    <input
                      type="text"
                      className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1'
                      placeholder='Enter otp'
                      {...register("otp")}
                      autoComplete="otp"
                    />
                  </div>
                </div>
              </div>
              <div className="flex justify-center items-center">
                <button type='submit' className="w-fit text-center mt-2 gap-2 font-semibold text-black bg-[#cc77e6] border-0 py-2 px-5 md:px-6 focus:outline-none hover:bg-[#b63fdb] rounded text-sm md:text-base">Veryfy OTP</button>
              </div>
            </form>) : (<>
              <div className="flex justify-center items-center py-3" >
                <p>OTP Not send yet</p>
              </div>
            </>)

          }
        </div>
      </div>
    </div>
  );
};

export default ForgotPassword;
