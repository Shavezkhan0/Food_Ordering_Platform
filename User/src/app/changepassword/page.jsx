"use client";
import { useRouter, useSearchParams } from "next/navigation";
import { useForm } from "react-hook-form";
import Toastify from 'toastify-js';
import "toastify-js/src/toastify.css";
import LoadingBar from "react-top-loading-bar";
import { useState } from "react";

const ChangePassword = () => {
  const searchParams = useSearchParams();
  const router = useRouter()
  const email = searchParams.get('email');
  const [progress, setProgress] = useState(0);

  const {
    register,
    handleSubmit,
    watch,
    formState: { errors },
  } = useForm();

  const onSubmit = async (data) => {
    setProgress(20)
    if (data.password === data.repassword) {
      setProgress(40)
      data = { ...data, email: email };
      const r = await fetch("/api/changepassword", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(data),
      });
      const res = await r.json();
      setProgress(80)
      if (res.success = true) {
        Toastify({
          text: `Password Changed successfully`,
          duration: 3000,
          close: true,
          gravity: "top", // `top` or `bottom`
          position: "right", // `left`, `center` or `right`
          style: { background: "linear-gradient(to right, #00b09b, #96c93d)" },
        }).showToast();

        setProgress(100)
        setTimeout(() => {
          router.push("/login")
        }, 400);
      }
    } else {
      Toastify({
        text: `Password not same`,
        duration: 3000,
        close: true,
        gravity: "top", // `top` or `bottom`
        position: "right", // `left`, `center` or `right`
        style: { background: "linear-gradient(to right, #ff5f6d, #ffc371)" },
      }).showToast();
    }
  };
  return (
    <div className="mx-auto mt-8">
      <LoadingBar
        color="#f11946"
        progress={progress}
        waitingTime={3000}
        onLoaderFinished={() => {
          console.log("Loader finished"); // Debugging statement
          setProgress(0);
        }}
      />
      <div className="flex flex-col gap-3 justify-center items-center w-[90vw] md:w-[30vw] mx-auto border-2 shadow-md py-5 px-2">
        <h1 className="text-2xl font-bold text-[#9d2ac0]">Forgot Password</h1>

        <div>
          <form
            onSubmit={handleSubmit(onSubmit)}
            className="flex flex-col gap-2 "
          >
            <div className="flex flex-col  justify-center items-center py-2">
              <div className="flex flex-col  justify-center items-center  gap-2  ">
                <div className="w-full flex gap-5  items-center justify-between">
                  <label className="">New Password</label>
                  <input
                    type="password"
                    className="bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1"
                    placeholder="Enter New Password"
                    {...register("password")}
                    autoComplete="password"
                  />
                </div>

                <div className="w-full flex gap-5  items-center justify-between">
                  <label className="">Re Enter Password</label>
                  <input
                    type="password"
                    className="bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1"
                    placeholder="Re Enter Password"
                    {...register("repassword")}
                    autoComplete="repassword"
                  />
                </div>
              </div>
            </div>
            <div className="flex justify-center items-center">
              <button
                type="submit"
                className="w-fit text-center mt-2 gap-2 font-semibold text-black bg-[#cc79e6] border-0 py-2 px-5 md:px-6 focus:outline-none hover:bg-[#c442eb] rounded text-sm md:text-base"
              >
                Save Password
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default ChangePassword;
