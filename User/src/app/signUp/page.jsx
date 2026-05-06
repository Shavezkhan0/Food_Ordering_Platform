"use client"
import { signIn, useSession } from "next-auth/react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect } from "react";
import { useForm } from "react-hook-form";
import Toastify from 'toastify-js';
import "toastify-js/src/toastify.css";
import { FcGoogle } from "react-icons/fc";
import { GrGithub } from "react-icons/gr";
import { NextSeo } from 'next-seo';


const SignUp = () => {

    const { data: session, status: sessionStatus } = useSession()
    const route = useRouter()

    useEffect(() => {
        if (sessionStatus === "authenticated") {
            route.push("/")
        }

    }, [sessionStatus, route])

    const {
        register,
        handleSubmit,
        watch,
        formState: { errors },
    } = useForm()

    const onSubmit = async (data) => {

        try {
            const response = await fetch("/api/user/signup", {
                method: "POST",
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data),
            })

            const res = await response.json()
            if (response.ok) {
                Toastify({
                    text: `${res.message}`,
                    duration: 3000,
                    close: true,
                    gravity: "top", // `top` or `bottom`
                    position: "right", // `left`, `center` or `right`
                    style: { background: "linear-gradient(to right, #00b09b, #96c93d)" },
                }).showToast();
                setTimeout(() => {
                    route.push('/login')
                }, 500);
            }
            else {
                console.error('Error signing up user:', res);
                Toastify({
                    text: `${res.message}`,
                    duration: 3000,
                    close: true,
                    gravity: "top", // `top` or `bottom`
                    position: "right", // `left`, `center` or `right`
                    style: { background: "linear-gradient(to right, #ff5f6d, #ffc371)" },
                }).showToast();
            }
        } catch (error) {
            console.error('Error submitting form:', error)
        }

    }
    return (
        <>

            <NextSeo
                title="SignUp - Okhla Dastarkhan"
                description="SignUp Now and Order delicious food  from top-rated restaurants in Okhla with Okhla Dastarkhan. Enjoy fast delivery and convenient online ordering."
                keywords="okhla dastarkhan  ,Okhla Dastarkhan  ,okhla dastarkhwan ,Okhla Dastarkhwan ,Okhla food delivery, Okhla restaurants, food delivery app, online food ordering, Okhla Dastarkhan"
            />

            <div className='mx-auto mt-4' >
                <div className='flex flex-col justify-center items-center w-[96vw] md:w-[45vw] mx-auto border-2 shadow-md py-5 px-5'>
                    <h1 className='text-2xl font-bold text-[#bb47de] pb-3'>SignUp</h1>
                    <div>
                        <div className="flex flex-col items-center gap-2">

                            <button onClick={() => signIn("google")} className="w-fit shadow flex items-center gap-2 shadow-blue-500 pt-2 pb-2 mb-2 pl-5 pr-5">Login <FcGoogle size={20} /></button>
                            <button onClick={() => signIn("github")} className="w-fit shadow flex items-center gap-2  shadow-blue-500 pt-2 pb-2 mb-2 pl-5 pr-5">Login <GrGithub /></button>
                            <h1 className="text-lg text-center">-OR-</h1>
                        </div>
                        <form onSubmit={handleSubmit(onSubmit)} className='flex flex-col gap-2  '>

                            <div className='flex flex-col  justify-center items-center py-2'>


                                <div className='flex flex-col  justify-center items-center  gap-2  '>

                                    <div className='w-full flex  gap-2 items-center justify-between'>
                                        <label className=''>Username</label>
                                        <input type="text" className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1' placeholder='Enter Username' {...register("username")} autoComplete="username" />
                                    </div>



                                    <div className='w-full flex gap-2  items-center justify-between'>
                                        <label className=''>Email</label>
                                        <input type="email" className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1' placeholder='Enter your email' {...register("email")} autoComplete="email" />
                                    </div>

                                    <div className='w-full flex  gap-2 items-center justify-between'>
                                        <label className=''>Phone Number</label>
                                        <input type="text" className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1' placeholder='Enter your phone number' {...register("phoneNumber")} autoComplete="phoneNumber" />
                                    </div>

                                    <div className='w-full flex  gap-2 items-center justify-between'>
                                        <label className=''>Password</label>
                                        <input type="password" className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1' placeholder='Enter password' {...register("password")} autoComplete="password" />
                                    </div>

                                </div>




                            </div>
                            <div className="flex justify-center items-center">
                                <button type='submit' className="w-fit text-center mt-2 gap-2 font-semibold text-black bg-[#cc73e8] border-0 py-2 px-5 md:px-6 focus:outline-none hover:bg-[#9933b8] rounded text-sm md:text-base">SignUp</button>
                            </div>

                            <div className="flex flex-col  text-end gap-2 ">
                                <div >
                                    <Link href={'/login'}>
                                        <h1 className='text-xl font-semibold text-[#bb3ee1] cursor-pointer'>Login</h1>
                                    </Link>
                                </div>
                            </div>

                        </form>

                    </div>
                </div>
            </div>
        </>
    )
}

export default SignUp
