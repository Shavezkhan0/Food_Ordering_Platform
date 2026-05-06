"use client"
import { useSession } from 'next-auth/react'
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import React, { useEffect, useState } from 'react'
import Toastify from 'toastify-js';
import "toastify-js/src/toastify.css";
import { GoDotFill } from "react-icons/go";

const Orders = () => {
    const [orders, setOrders] = useState([]); // Initialize as an empty array
    const [loading, setLoading] = useState(true); // Add a loading state
    const [error, setError] = useState(null); // Add an error state
    const { data: session, status: sessionStatus } = useSession();
    const router = useRouter()


    const email = session?.user?.email;


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
            router.push("/login")
        }

        const getOrders = async () => {
            try {
                const response = await fetch("/api/getOrders", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({ email })
                });

                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }

                const data = await response.json();
                setOrders(data);
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        getOrders();
    }, [sessionStatus, router, email]);





    if (loading) return <div>

        <div role="status" class="w-full  p-4 space-y-4 border border-gray-200 divide-y divide-gray-200 rounded shadow animate-pulse dark:divide-gray-700 md:p-6 dark:border-gray-700">
            <div class="flex items-center justify-between">
                <div className='w-full'>
                    <div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5"></div>
                    <div class="w-32 h-2 bg-gray-200 rounded-full dark:bg-gray-700"></div>
                </div>
                <div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-700 w-12"></div>
            </div>
            <div class="flex items-center justify-between pt-4">
                <div>
                    <div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5"></div>
                    <div class="w-32 h-2 bg-gray-200 rounded-full dark:bg-gray-700"></div>
                </div>
                <div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-700 w-12"></div>
            </div>
            <div class="flex items-center justify-between pt-4">
                <div>
                    <div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5"></div>
                    <div class="w-32 h-2 bg-gray-200 rounded-full dark:bg-gray-700"></div>
                </div>
                <div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-700 w-12"></div>
            </div>
            <div class="flex items-center justify-between pt-4">
                <div>
                    <div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5"></div>
                    <div class="w-32 h-2 bg-gray-200 rounded-full dark:bg-gray-700"></div>
                </div>
                <div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-700 w-12"></div>
            </div>
            <div class="flex items-center justify-between pt-4">
                <div>
                    <div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5"></div>
                    <div class="w-32 h-2 bg-gray-200 rounded-full dark:bg-gray-700"></div>
                </div>
                <div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-700 w-12"></div>
            </div>
            <span class="sr-only">Loading...</span>
        </div>

    </div>;
    if (error) return <div>Error: {error}</div>;

    return (
        <div>
            <div className='container w-[80vw] mx-auto '>
                <h1 className='text-2xl font-semibold mx-auto text-center pt-6'>My Orders </h1>
                <div className="flex flex-col">
                    <div className="overflow-x-auto sm:-mx-6 lg:-mx-8">
                        <div className="inline-block min-w-full py-2 sm:px-6 lg:px-8">
                            <div className="overflow-hidden">
                                <table
                                    className="min-w-full text-left text-sm font-light text-surface dark:text-white">
                                    <thead
                                        className="border-b border-neutral-200 font-medium dark:border-white/10">
                                        <tr>
                                            <th scope="col" className="px-6 py-4">#OrderId</th>
                                            <th scope="col" className="px-6 py-4">Name</th>
                                            <th scope="col" className="px-6 py-4">Quantity</th>
                                            <th scope="col" className="px-6 py-4">Price</th>
                                            <th scope="col" className="px-6 py-4">Total</th>
                                            <th scope="col" className="px-6 py-4">Status</th>
                                            <th scope="col" className="px-6 py-4">Details</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        {
                                            orders?.Orders?.slice().reverse().map((item) => {


                                                const updatedAt = new Date(item.updatedAt);
                                                const formattedDate = updatedAt.toLocaleDateString('en-IN', {
                                                    day: 'numeric',
                                                    month: 'short',
                                                    year: 'numeric'
                                                });
                                                const formattedTime = updatedAt.toLocaleTimeString('en-IN', {
                                                    hour: '2-digit',
                                                    minute: '2-digit'
                                                });

                                                return (

                                                    <tr key={item.orderId} onClick={() => {
                                                        router.push(`/order/${item._id}`)
                                                    }} className="border-b border-neutral-200  dark:border-white/10 cursor-pointer hover:bg-[#e3b2f4] hover:text-base">
                                                        <td className="whitespace-nowrap px-6 py-4 font-medium">
                                                            <h4>{item.orderId}</h4>
                                                            <span>Date: {formattedDate}</span><br />
                                                            <span>Time: {formattedTime}</span>
                                                        </td>
                                                        <td className="whitespace-nowrap px-6 py-4 font-medium">
                                                            <div className='flex flex-col'>
                                                                {
                                                                    item.products.map((product) => {
                                                                        return (
                                                                            <span key={product._id} className='flex items-center'><GoDotFill /> {product.name}</span>
                                                                        )
                                                                    })
                                                                }
                                                                <span></span>
                                                            </div>
                                                        </td>
                                                        <td className="whitespace-nowrap px-6 py-4 font-medium">
                                                            <div className='flex flex-col'>
                                                                {
                                                                    item.products.map((product) => {
                                                                        return (
                                                                            <span key={product._id} className='flex items-center'>{product.quantity}</span>
                                                                        )
                                                                    })
                                                                }
                                                                <span></span>
                                                            </div>
                                                        </td>
                                                        <td className="whitespace-nowrap px-6 py-4 font-medium">
                                                            <div className='flex flex-col'>
                                                                {
                                                                    item.products.map((product) => {
                                                                        return (
                                                                            <span key={product._id} className='flex items-center'>{product.price * product.quantity}</span>
                                                                        )
                                                                    })
                                                                }
                                                                <span></span>
                                                            </div>
                                                        </td>
                                                        <td className="whitespace-nowrap px-6 py-4 font-semibold">₹ {item.amount}</td>
                                                        {
                                                            item?.deliverystatus?.deliver === "success" ? (
                                                                <td className="whitespace-nowrap px-6 py-4  font-semibold text-green-600">{item?.deliverystatus?.deliver}</td>
                                                            ) : item?.deliverystatus?.deliver === "cancelled" ? (

                                                                <td className="whitespace-nowrap px-6 py-4  font-semibold text-red-600">{item?.deliverystatus?.deliver}</td>
                                                            ) : (

                                                                <td className="whitespace-nowrap px-6 py-4  font-semibold text-[#bd36e7]">{item?.deliverystatus?.deliver}</td>
                                                            )
                                                        }
                                                        <td className="whitespace-nowrap px-6 py-4 font-semibold  hover:underline hover:text-base">More Details</td>

                                                    </tr>
                                                )
                                            })
                                        }
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    {
                        !orders && <div>
                            Orders not available
                        </div>
                    }
                </div>
            </div>
        </div>
    );
}

export default Orders;
