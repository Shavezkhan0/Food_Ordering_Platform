"use client"
import { clearCart, decrementQuantity, incrementQuantity } from '@/redux/features/cartSlice';
import { useSession } from 'next-auth/react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useEffect, useState } from 'react';
import { useForm } from "react-hook-form";
import { BsCurrencyRupee } from "react-icons/bs";
import { CgUnavailable } from "react-icons/cg";
import { IoIosAdd } from "react-icons/io";
import { IoHammer } from "react-icons/io5";
import { RiSubtractLine } from "react-icons/ri";
import { useDispatch, useSelector } from 'react-redux';
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import LoadingBar from "react-top-loading-bar";
import Toastify from 'toastify-js';
import "toastify-js/src/toastify.css";
import { MdLocationSearching, MdMyLocation } from "react-icons/md";


const Checkout = () => {
  const cart = useSelector((state) => state.cart.cart);
  const dispatch = useDispatch();

  const { data: session, status: sessionStatus } = useSession()
  const email = session?.user?.email;

  const [allPin, setallPin] = useState(null)
  const [location, setlocation] = useState(null)
  const [progress, setProgress] = useState(0);
  const [isServiceable, setisServiceable] = useState(null)
  const route = useRouter()


  const {
    register,
    handleSubmit,
    watch,
    setError,
    setValue,
    formState: { errors, isValid, isSubmitting },
  } = useForm({
    mode: 'onChange',
    reValidateMode: 'onBlur',
    defaultValues: {
      paymentMethod: "CashOnDelivery", // Default selected payment method
    },
  })

  useEffect(() => {
    const data = async () => {
      const r = await fetch("/api/pincode")
      const res = await r.json()
      setallPin(res)
    }
    data()

    const getUser = async () => {
      const res = await fetch("/api/user/getUser", {
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email }),
      })
      const response = await res.json()
      setValue("username", response?.user?.user[0]?.username);
      setValue("phoneNumber", response?.user?.user[0]?.phoneNumber);
      setValue("email", response?.user?.user[0]?.email);
      setValue("landmark", response?.user?.user[0]?.landmark);
      setValue("address", response?.user?.user[0]?.address);
      // setValue("pincode", response?.user?.user[0]?.pincode);
      // setValue("state", response?.user?.user[0]?.state);
      // setValue("city", response?.user?.user[0]?.city);
      // setValue("country", response?.user?.user[0]?.country);
    }
    getUser()

    getLocationOrigin()

  }, [email])





  useEffect(() => {
    if (sessionStatus !== "authenticated") {
      Toastify({
        text: `Login first`,
        duration: 3000,
        close: true,
        gravity: "top", // `top` or `bottom`
        position: "right", // `left`, `center` or `right`
        style: { background: "linear-gradient(to right, #00b09b, #96c93d)" },
      }).showToast();
      route.push("/login")
    }
  }, [sessionStatus, route])


  let totalPrice = 0;
  cart.forEach((item) => {
    totalPrice += item.price * item.quantity;
  })

  const calculateDeliveryAmount = (totalPrice) => {
    if (totalPrice === 0) return 0;
    if (totalPrice <= 101) return 10;
    if (totalPrice <= 201) return 20;
    if (totalPrice < 500) return 30;
    return 0;
  };

  let deliveryamount = calculateDeliveryAmount(totalPrice);
  totalPrice += deliveryamount;




  const onSubmit = async (data) => {

    let oid = Math.floor(Math.random() * Date.now());

    const geolocationData = ({
      latitude: location?.coords?.latitude || "0",
      longitude: location?.coords?.longitude || "0",
      accuracy: location?.coords?.accuracy || "0",
    });

    

    data = { ...data, totalPrice, oid, cart, deliveryamount, email: email, geolocation: geolocationData }

    if (!isServiceable) {
      toast.error(`This pincode code is not serviceable`, {
        position: "top-right",
        autoClose: 3000,
        hideProgressBar: false,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
        progress: undefined,
        theme: "light",
      });
      return;
    }

    if (cart.length === 0) {
      toast.error(`No Food item in the cart`, {
        position: "top-right",
        autoClose: 3000,
        hideProgressBar: false,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
        progress: undefined,
        theme: "light",
      });
      return;
    }

    setProgress(50)
    if (isServiceable) {
      const response = await fetch("/api/preTransection", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify(data)
      });

      const result = await response.json();


      if (result.success === true) {
        toast.success(`${result.message}`, {
          position: "top-right",
          autoClose: 3000,
          hideProgressBar: false,
          closeOnClick: true,
          pauseOnHover: true,
          draggable: true,
          progress: undefined,
          theme: "light",
        });
        setTimeout(() => {
          setProgress(100)
        }, 50);
        setTimeout(() => {
          dispatch(clearCart())
          route.push(`/order/${result.orderId}`)
        }, 100);
      }

      if (result.success === false) {
        toast.error(`${result.message}`, {
          position: "top-right",
          autoClose: 3000,
          hideProgressBar: false,
          closeOnClick: true,
          pauseOnHover: true,
          draggable: true,
          progress: undefined,
          theme: "light",
        });
        setTimeout(() => {
          setProgress(100)
        }, 50);
        // setTimeout(() => {
        //   dispatch(clearCart())
        //   route.push(`/home`)
        // }, 100);
      }

    }
  }


  const handleChangePincode = (e) => {
    const pincode = e.target.value;
    if (pincode.length === 6) {
      if (pincode.length === 6 && allPin[pincode]) {
        setValue("city", allPin[pincode].city);
        setValue("state", allPin[pincode].state);
        setValue("country", allPin[pincode].country);
        setisServiceable(true)
      } else {
        setisServiceable(false)
        setError("pincode", {
          type: "manual",
          message: "This pincode code is not serviceable"
        });
        Toastify({
          text: `This pincode code is not serviceable`,
          duration: 3000,
          close: true,
          gravity: "top", // `top` or `bottom`
          position: "right", // `left`, `center` or `right`
          style: { background: "linear-gradient(to right,#ff0000, #ff6666)" },
        }).showToast();
        return ("This Pincode is not servicable");

      }
    }

  }


  const gotLocation = async (position) => {
    if (!position) {
      toast.error("Unable to get your location", {
        position: "top-right",
        autoClose: 3000,
        hideProgressBar: false,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
        progress: undefined,
        theme: "light",
      });
    }

    setlocation(position);

    toast.success(`Location get successfully`, {
      position: "top-right",
      autoClose: 3000,
      hideProgressBar: false,
      closeOnClick: true,
      pauseOnHover: true,
      draggable: true,
      progress: undefined,
      theme: "light",
    });
  }

  const failedgotLocation = async (error) => {
    toast.error("Unable to get your location", {
      position: "top-right",
      autoClose: 3000,
      hideProgressBar: false,
      closeOnClick: true,
      pauseOnHover: true,
      draggable: true,
      progress: undefined,
      theme: "light",
    });
  }

  const getLocationOrigin = async () => {
    if ("geolocation" in navigator) {
      navigator.geolocation.getCurrentPosition(gotLocation, failedgotLocation);
    } else {
      toast.error("Geolocation is not supported by your browser", {
        position: "top-right",
        autoClose: 3000,
        hideProgressBar: false,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
        progress: undefined,
        theme: "light",
      });
    }
  };



  return (
    <div className='container mx-auto '>
      <ToastContainer
        position="top-right"
        autoClose={3000}
        hideProgressBar={false}
        newestOnTop={false}
        closeOnClick
        rtl={false}
        pauseOnFocusLoss
        draggable
        pauseOnHover
        theme="light"
      />
      <LoadingBar
        color="#f11946"
        progress={progress}
        waitingTime={3000}
        onLoaderFinished={() => {
          console.log("Loader finished"); // Debugging statement
          setProgress(0);
        }}
      />



      <h1 className='font-bold text-2xl my-6 text-center'>Checkout</h1>
      <form onSubmit={handleSubmit(onSubmit)} className='flex flex-col gap-2 px-4'>
        <div className='w-[90vw] mx-auto'>
          <h2 className='font-semibold'>1. Delivery Details</h2>
          <div className='py-2'>

            <div className='flex flex-col gap-2 px-4'>
              <div className='flex flex-col md:flex-row  items-center md:gap-10 gap-2  '>
                <div className='w-full flex  items-center justify-between'>
                  <label className=''>Name</label>
                  <div className='flex flex-col'>
                    <input type="text" className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1' placeholder='Enter your  name' {...register("username", { required: true })} />
                    {errors.username && <div className='text-xs text-red-500'>This field is required</div>}
                  </div>
                </div>

                <div className='w-full flex  items-center justify-between'>
                  <label className=''>Phone Number</label>
                  <div className='flex flex-col'>
                    <input type="text" className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1' placeholder='Enter your phone number' {...register("phoneNumber", {
                      required: "This field is required", minLength: { value: 10, message: 'Minimum length is 10 ' },
                      maxLength: { value: 10, message: 'Maximum length is 10' },
                    })} />
                    {errors.phoneNumber && <div className='text-xs text-red-500'>{errors.phoneNumber.message}</div>}
                  </div>
                </div>



              </div>

              <div className='flex gap-2 '>
                <label className=''>Address</label>
                <div className='flex flex-col w-[90vw]'>
                  <textarea type="text" rows={2} className='bg-gray-200   bottom-2 w-full border-black rounded-sm px-2 py-1' placeholder='Enter your Address' {...register("address", { required: true })} />
                  {errors.address && <div className='text-xs text-red-500'>This field is required</div>}
                </div>
              </div>

              <div className='flex flex-col md:flex-row  items-center md:gap-10 gap-2  '>
                <div className='w-full  flex  items-center justify-between'>
                  <label className=''>Landmark</label>
                  <div className='flex flex-col'>
                    <input type="text" className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1' placeholder='Enter Landmark' {...register("landmark", { required: true })} />
                    {errors.landmark && <div className='text-xs text-red-500'>This field is required</div>}
                  </div>
                </div>

                <div className='w-full flex  items-center justify-between'>
                </div>

              </div>



              <div className='flex flex-col md:flex-row  items-center md:gap-10 gap-2  '>
                <div className='w-full flex  items-center justify-between'>
                  <label className=''>Pincode</label>
                  <div className='flex flex-col'>
                    <input type="text" className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1' placeholder='Enter your pincode' {...register("pincode", {
                      required: "This field is required", onChange: handleChangePincode, minLength: { value: 6, message: 'Minimum length is 6 characters' },
                      maxLength: { value: 6, message: 'Maximum length is 6 characters' },
                    })} />
                    {errors.pincode && <div className='text-xs text-red-500'>{errors.pincode.message}</div>}
                  </div>
                </div>

                <div className='w-full flex  items-center justify-between'>
                  <label className=''>State</label>
                  <div className='flex flex-col'>
                    <input type="text" className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1' placeholder='Enter your state' {...register("state", { required: true })} />
                    {errors.state && <div className='text-xs text-red-500'>This field is required</div>}
                  </div>
                </div>
              </div>

              <div className='flex flex-col md:flex-row  items-center md:gap-10 gap-2  '>


                <div className='w-full flex  items-center justify-between'>
                  <label className=''>City</label>
                  <div className='flex flex-col'>
                    <input type="text" className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1' placeholder='Enter your city' {...register("city", { required: true })} />
                    {errors.city && <div className='text-xs text-red-500'>This field is required</div>}
                  </div>
                </div>
                <div className='w-full flex  items-center justify-between'>
                  <label className=''>Country</label>
                  <div className='flex flex-col'>
                    <input type="text" className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1' placeholder='Enter your country' {...register("country", { required: true })} />
                    {errors.country && <div className='text-xs text-red-500'>This field is required</div>}
                  </div>
                </div>
              </div>

              <div className='flex flex-col md:flex-row  items-center md:gap-10 gap-2  '>

                <div className='w-full flex  items-center justify-between'>
                  <label className=''>Use Current Location</label>
                  {
                    location ? (
                      <button onClick={(e) => { e.preventDefault(); getLocationOrigin(); }} className='flex flex-col text-[#a52cc9]'>
                        <MdMyLocation size={30} />
                      </button>
                    ) : (
                      <button onClick={(e) => { e.preventDefault(); getLocationOrigin(); }} className='flex flex-col text-[#a52cc9]'>
                        <MdLocationSearching size={30} />
                      </button>
                    )
                  }


                </div>

                <div className='w-full  flex  items-center justify-between'>
                </div>
              </div>


            </div>


          </div>
        </div>

        <div className='w-[90vw] mx-auto'>
          <h2 className='font-semibold py-2'>2. Order Details</h2>
          <div className='bg-[#dfacee] px-2 py-4 w-full rounded-sm'>
            <div className='flex flex-col gap-3 px-2'>
              {
                cart && cart.length > 0 ? (
                  cart.map((item) => (
                    <>
                      <div key={item.id} className=' md:px-3  border-2 border-[#060f05]'>

                        <div className='flex md:flex-row p-2 justify-between     '>
                          <div className=' flex flex-col md:flex-row md:items-center'>
                            <div className='md:font-medium text-sm font-semibold md:text-2xl gap-3 flex items-center justify-center  text-start '><span>Name : </span> {item.name}</div>
                            <div className='md:text-sm text-xs md:mx-3 text-start overflow-hidden'><span className='font-semibold'>FoodCategory</span> : {item.foodCategory}</div>
                            <div className='md:text-sm text-xs md:mx-3  text-start overflow-hidden'><span className='font-semibold'>Shop Name</span> : {item.shopname}</div>
                          </div>

                          <div className=' flex flex-col md:flex-row   md:items-end gap-1'>
                            <div className='flex gap-2 items-center bg-gray-100 py-1 px-2 rounded-sm '>
                              <span
                                className='cursor-pointer text-[#a52cc9] hover:bg-[#a437c6] hover:text-white  hover:text-xl'
                                onClick={() => {
                                  dispatch(decrementQuantity({ id: item.id }))

                                }}
                              >
                                <RiSubtractLine />
                              </span>
                              <span className='font-semibold'>{item.quantity}</span>
                              <span
                                className='cursor-pointer text-[#a52cc9] hover:bg-[#a437c6] hover:text-white  hover:text-xl'
                                onClick={() => {
                                  dispatch(incrementQuantity({ id: item.id }))
                                }}
                              >
                                <IoIosAdd />
                              </span>
                            </div>
                            <div className='font-medium text-2xl flex items-center'><BsCurrencyRupee /> {item.price * item.quantity}</div>
                          </div>


                        </div>




                      </div>
                    </>
                  ))
                ) : (
                  <div className='py-2'>Your cart is empty</div>
                )
              }

              <div className=' md:px-3  border-2 border-[#060f05]'>
                <div className='flex md:flex-row p-2 justify-between     '>
                  <div className=' flex flex-col md:flex-row md:items-center'>
                    <div className='md:text-sm text-xs md:mx-3 text-start overflow-hidden'><span className='font-semibold'>Delivery Charge</span></div>
                  </div>
                  <div className=' flex flex-col md:flex-row   md:items-end gap-1'>
                    <div className='font-medium text-2xl flex items-center'><BsCurrencyRupee /> {deliveryamount}</div>
                  </div>
                </div>
              </div>

            </div>

            <div className='flex items-end justify-end'>

              {
                totalPrice !== 0 && <div className='flex justify-end items-center  flex-row text-base font-semibold pt-2 pr-4'>
                  <div className='mx-2'>Total Price :-</div>
                  <div className='mx-1'><BsCurrencyRupee /></div>
                  <div >{totalPrice}</div>
                </div>
              }

            </div>

          </div>
        </div>
        <div className='w-[90vw] mx-auto'>
          <h2 className='font-semibold text-sm md:text-2xl py-2'>Select Payment Method</h2>
          <div className='font-semibold text-lg w-fit border-[2px] flex flex-col md:flex-row gap-3 border-gray-400  py-4 px-3'>
            <div className=' flex gap-3 border-[1px]  border-gray-400 w-fit py-1 px-2 '>
              <input
                type="radio"
                value="CashOnDelivery"
                {...register('paymentMethod', {
                  required: 'You must select a payment method',
                })}
              />
              <label className='flex  items-center gap-2'>
                Pay on Delivery <span className='text-sm'>[Cash , UPI , Paytm ,Phonepe Or Googlepay]</span>
              </label>
            </div>
            <div className=' flex gap-3 border-[1px]  border-gray-400  py-1 px-2 '>
              <input className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1'
                type="radio"
                value="onlinePayment"
                {...register('paymentMethod')}
                disabled={true}
              />
              <label className='text-red-600 flex justify-center items-center gap-2' >
                Online Payment Currently Unavailable <CgUnavailable size={30} />
              </label>
            </div>

            {errors.paymentMethod && <p>{errors.paymentMethod.message}</p>}
          </div>
        </div>
        <div className='flex flex-row justify-end items-center mx-8'>
          {
            totalPrice !== 0 ? (

              <button type='submit' disabled={isSubmitting} className="disabled:bg-[#e6c7ef]  w-42 text-center mt-2 flex justify-center items-center gap-1 font-semibold text-black bg-[#c459e4] border-0 py-2 px-3 md:px-6 focus:outline-none hover:bg-[#a437c6] rounded text-sm md:text-base cursor-pointer"><IoHammer />Place Your Order</button>

            ) : (
              <Link href={'/'}>
                <button className="w-42 text-center mt-2 gap-2 font-semibold text-black bg-[#c459e4] border-0 py-2 px-3 md:px-6 focus:outline-none hover:bg-[#a437c6] rounded text-sm md:text-base">Add Item & Go to Home Page</button>
              </Link>
            )
          }
        </div>
      </form>
    </div>

  )
}
export default Checkout

