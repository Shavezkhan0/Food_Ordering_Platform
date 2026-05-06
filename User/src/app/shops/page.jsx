"use client"
import Image from 'next/image'
import { useRouter } from 'next/navigation'
import React, { useEffect, useState } from 'react'
import LoadingBar from "react-top-loading-bar";
import { NextSeo } from 'next-seo';

const Shops = () => {
    const [Shops, setShops] = useState(null);
    const router = useRouter()
    const [progress, setProgress] = useState(0);

    useEffect(() => {
        const fetchShops = async () => {
            try {
                const r = await fetch('/api/shops/getshops');
                const data = await r.json();
                setShops(data.shops);
            } catch (error) {
                console.error('Failed to fetch Shops:', error);
            }
        };

        fetchShops();
    }, []);





    return (
        <>
            <NextSeo
                title="All Restaurants - Okhla Dastarkhan"
                description="All Restaurants , Order delicious food  from top-rated restaurants in Okhla with Okhla Dastarkhan. Enjoy fast delivery and convenient online ordering."
                keywords="okhla dastarkhan  ,Okhla Dastarkhan  ,okhla dastarkhwan ,Okhla Dastarkhwan ,Okhla food delivery, Okhla restaurants, food delivery app, online food ordering, Okhla Dastarkhan"
            />

            <div>
                <LoadingBar
                    color="#f11946"
                    progress={progress}
                    waitingTime={3000}
                    onLoaderFinished={() => {
                        console.log("Loader finished");
                        setProgress(0);
                    }}
                />
                <section className="text-gray-600 body-font items-start">
                    <div className="container pl-2 pr-0  mx-auto ">
                        <div className="flex flex-wrap items-center justify-center gap-x-5 gap-y-2 ">


                            {
                                Shops ? (<>
                                    {
                                        Shops.map((Shops) => {
                                            return (
                                                <div key={Shops._id} onClick={() => {
                                                    setProgress(100)
                                                    router.push(`/shop/${Shops.email}`)
                                                }}
                                                    className="cursor-pointer flex flex-col  justify-center  w-[80vw]  lg:w-1/6 md:w-1/3 shadow-md shadow-gray-500 p-2 mx-2 my-3">
                                                    <div className='flex  justify-between py-1 items-center'>
                                                        <div>
                                                            <span className='font-semibold'>Shop : </span>
                                                            <span> {Shops.username}</span>
                                                        </div>
                                                        <div>
                                                            {
                                                                Shops.shop === "on" ? (
                                                                    <span className='border-2 border-gray-400 p-[2px] bg-green-500 text-white'>On</span>
                                                                ) : (
                                                                    <span className='border-2 border-gray-400 p-[2px] bg-red-500 text-white'>Off</span>

                                                                )
                                                            }
                                                        </div>

                                                    </div>
                                                    <div className="block relative items-center justify-center mx-auto rounded overflow-hidden">
                                                        <Image alt="ecommerce" src={Shops.image[0]?.secure_url}
                                                            className="cursor-pointer object-cover md:w-48 w-[70vw] h-[20vh] md:h-36"
                                                            width={200}
                                                            height={200} />
                                                    </div>

                                                    <div className='flex  justify-start py-1 items-center'>
                                                        <div className='flex flex-col   py-1 items-start'>
                                                            <h1 className='font-semibold'>Shop Address :</h1>
                                                            <div>
                                                                <span className='font-medium'>Address : </span>
                                                                <span className='font-light text-sm'> {Shops.address}</span>
                                                            </div>
                                                            <div>
                                                                <span className='font-medium'>Landmark : </span>
                                                                <span className='font-light text-sm'> {Shops.landmark}</span>
                                                            </div>
                                                            <div>
                                                                <span className='font-medium'>City : </span>
                                                                <span className='font-light text-sm'> {Shops.city}</span>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>

                                            )
                                        })
                                    }
                                </>) : (<>
                                    <div>
                                        <p>Shops is not available</p>
                                    </div>
                                </>)
                            }



                        </div>
                    </div>
                </section>
            </div>
        </>
    )
}



export default Shops