"use client"
import { signIn, useSession } from "next-auth/react";
import Link from 'next/link';
import { useRouter } from "next/navigation";
import { useEffect } from "react";
import { useForm } from "react-hook-form";
import Toastify from 'toastify-js';
import "toastify-js/src/toastify.css";
import { FcGoogle } from "react-icons/fc";
import { GrGithub } from "react-icons/gr";
import { NextSeo } from 'next-seo';

const Login = () => {

    const { data: session, status: sessionStatus } = useSession()
    const router = useRouter()

    useEffect(() => {
        if (sessionStatus === "authenticated") {
            router.push("/")
        }
    }, [sessionStatus, router])



    const {
        register,
        handleSubmit,
        watch,
        formState: { errors },
    } = useForm()

    const onSubmit = async (data) => {
        const { email, password } = data

        try {
            const res = await signIn("credentials", {
                redirect: false,
                email,
                password,
            });

            if (res.ok) {
                Toastify({
                    text: `Login successfully`,
                    duration: 3000,
                    close: true,
                    gravity: "top",
                    position: "right",
                    style: { background: "linear-gradient(to right, #00b09b, #96c93d)" },
                }).showToast();

                setTimeout(() => {
                    router.push('/')
                }, 400);
            } else {
                throw new Error(res.error);
            }

        } catch (error) {
            console.error('Error in login:', error);
            Toastify({
                text: `Details do not match`,
                duration: 3000,
                close: true,
                gravity: "top",
                position: "right",
                style: { background: "linear-gradient(to right, #ff5f6d, #ffc371)" },
            }).showToast();
        }
    }
    return (
        <>

            <NextSeo
                title="Login - Okhla Dastarkhan"
                description="Login and Order delicious Momo from top-rated restaurants in Okhla with Okhla Dastarkhan. Enjoy fast delivery and convenient online ordering."
                keywords="okhla dastarkhan  ,Okhla Dastarkhan  ,okhla dastarkhwan ,Okhla Dastarkhwan ,Okhla food delivery, Okhla restaurants, food delivery app, online food ordering, Okhla Dastarkhan"
            />

            <div className='mx-auto mt-8' >
                <div className='flex flex-col gap-3 justify-center items-center w-[96vw] md:w-[45vw] mx-auto border-2 shadow-md py-5 px-2'>
                    <h1 className='text-2xl font-bold text-[#b734de]'>Login</h1>

                    <div>
                        <div className="flex flex-col items-center gap-2">

                            <button onClick={() => signIn("google")} className="w-fit shadow flex items-center gap-2 shadow-blue-500 pt-2 pb-2 mb-2 pl-5 pr-5">Login <FcGoogle size={20} /></button>
                            <button onClick={() => signIn("github")} className="w-fit shadow flex items-center gap-2  shadow-blue-500 pt-2 pb-2 mb-2 pl-5 pr-5">Login <GrGithub /></button>
                            <h1 className="text-lg text-center">-OR-</h1>
                        </div>
                        <form onSubmit={handleSubmit(onSubmit)} className='flex flex-col gap-2 '>

                            <div className='flex flex-col  justify-center items-center py-2'>


                                <div className='flex flex-col  justify-center items-center  gap-2  '>





                                    <div className='w-full flex gap-2  items-center justify-between'>
                                        <label className=''>Email</label>
                                        <input type="email" className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1' placeholder='Enter your email' {...register("email")} autoComplete="email" />
                                    </div>


                                    <div className='w-full flex  gap-2 items-center justify-between'>
                                        <label className=''>Password</label>
                                        <input type="password" className='bg-gray-200 bottom-2 border-black rounded-sm px-2 py-1' placeholder='Enter password' {...register("password")} autoComplete="password" />
                                    </div>

                                </div>




                            </div>
                            <div className="flex justify-center items-center">
                                <button type='submit' className="w-fit text-center mt-2 gap-2 font-semibold text-black bg-[#bb68d4] border-0 py-2 px-5 md:px-6 focus:outline-none hover:bg-[#9130ae] rounded text-sm md:text-base">Login</button>
                            </div>
                            <div >


                                <div className="flex justify-between items-center">
                                    <Link href={'/forgotpassword'} className="cursor-pointer underline" ><h4>Forgot Password</h4></Link>
                                    <Link href={'/signUp'}>
                                        <h1 className='text-lg font-semibold text-[#b634dd] cursor-pointer'>SignUp</h1>
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

export default Login
