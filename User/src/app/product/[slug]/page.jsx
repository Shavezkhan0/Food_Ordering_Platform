"use client";

import { addToCart, clearCart } from '@/redux/features/cartSlice';
import { useSession } from 'next-auth/react';
import Image from 'next/image';
import { useRouter } from 'next/navigation';
import React, { useEffect, useRef, useState } from 'react';
import { useDispatch } from 'react-redux';
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import Toastify from 'toastify-js';
import "toastify-js/src/toastify.css";
import LoadingBar from "react-top-loading-bar";

const ProductPage = ({ params }) => {
    const { slug } = params;
    const [pin, setPin] = useState(null);
    const [product, setProduct] = useState(null);
    const [progress, setProgress] = useState(0);
    const [serviceable, setServiceable] = useState(null);
    const { data: session, status: sessionStatus } = useSession()
    const [shopUser, setshopUser] = useState(null)
    const [activeIndex, setActiveIndex] = useState(0);
    // const shopUserEmail = useRef()
    let shopUserEmail;


    const router = useRouter()

    useEffect(() => {

        const data = async () => {

            const getProduct = async () => {
                try {
                    const response = await fetch("/api/getproduct", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: JSON.stringify({ slug }),
                    });
                    const result = await response.json();
                    setProduct(result);
                    shopUserEmail = result.email
                    // shopUserEmail.current = result.email


                } catch (error) {
                    console.error("Error fetching product:", error);
                }
            };

            await getProduct();


            const getShop = async () => {
                try {
                    const response = await fetch("/api/getShopUser", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: JSON.stringify({ email: shopUserEmail }),
                    });
                    const result = await response.json();
                    setshopUser(result.shopUser.shopUser)
                } catch (error) {
                    console.error("Error fetching product:", error);
                }
            };

            await getShop();


        }

        data();

    }, [slug, shopUserEmail]);






    const dispatch = useDispatch();

    const handlePincodeChange = (event) => {
        setPin(event.target.value);
    };

    const checkServiceAbility = async () => {
        try {
            const response = await fetch('/api/pincode');
            const pinJson = await response.json();
            const isServiceable = Object.keys(pinJson).includes(pin);

            if (isServiceable) {
                setServiceable(true);
                toast.success('You are Servicable', {
                    position: "top-right",
                    autoClose: 2000,
                    hideProgressBar: false,
                    closeOnClick: true,
                    pauseOnHover: true,
                    draggable: true,
                    progress: undefined,
                    theme: "light",
                });

            } else {
                setServiceable(false);
                toast.error('You are not Servicable', {
                    position: "top-right",
                    autoClose: 2000,
                    hideProgressBar: false,
                    closeOnClick: true,
                    pauseOnHover: true,
                    draggable: true,
                    progress: undefined,
                    theme: "light",
                });
            }
        } catch (error) {
            console.error('Error fetching pincodes:', error);
        }
    };

    const handlerAddToCart = () => {
        dispatch(addToCart({
            _id: product._id,
            price: product.price,
            name: product.title,
            shopname: product.shopname,
            description: product.description,
            shopemail: product.email,
            foodCategory: product.foodCategory,
        }))
        toast.success('Product is add to cart', {
            position: "top-right",
            autoClose: 2000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            theme: "light",
        });
    };



    const handlerBuyNow = () => {
        if (sessionStatus === "authenticated") {
            dispatch(clearCart())
            dispatch(addToCart({
                _id: product._id,
                price: product.price,
                name: product.title,
                shopname: product.shopname,
                description: product.description,
                shopemail: product.email,
                foodCategory: product.foodCategory,
            }))
            setProgress(100)
            router.push("/checkout")
        } else {
            Toastify({
                text: `Login first`,
                duration: 3000,
                close: true,
                gravity: "top", // `top` or `bottom`
                position: "right", // `left`, `center` or `right`
                style: { background: "linear-gradient(to right, #00b09b, #96c93d)" },
            }).showToast();
        }
    }


    const handleNext = () => {
        setActiveIndex((prevIndex) => (prevIndex + 1) % product.image.length);
    };

    const handlePrev = () => {
        setActiveIndex((prevIndex) => (prevIndex - 1 + product.image.length) % product.image.length);
    };


    return (
        <>
            <section className="text-gray-600 body-font overflow-hidden">
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
                <div className="container px-5 py-24 mx-auto">
                    <div className="lg:w-4/5 mx-auto flex flex-wrap">



                        <div id="gallery" className="relative w-full md:w-[30vw]" data-carousel="slide">
                            <div className="relative h-56 overflow-hidden rounded-lg shadow-md shadow-[#c888db] md:h-96">



                                {product?.image?.map((image, index) => (
                                    <div
                                        key={index}
                                        className={`absolute inset-0 transition-opacity duration-700 ease-in-out ${index === activeIndex ? 'opacity-100' : 'opacity-0'
                                            }`}
                                        data-carousel-item
                                    >
                                        <Image
                                            alt="product Image"
                                            className="shadow-lg shadow-[#b466cc] p-2"
                                            src={image?.secure_url}
                                            layout="fill"
                                            style={{ objectFit: 'cover' }} // Adjust according to your needs
                                            sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw" // Adjust according to your design
                                        />
                                    </div>
                                ))}
                            </div>

                            <button
                                type="button"
                                className="absolute top-0 left-0 z-5 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none"
                                data-carousel-prev
                                onClick={handlePrev}
                            >
                                <span className="inline-flex items-center justify-center w-10 h-10 rounded-full bg-white/30 dark:bg-gray-800/30 group-hover:bg-white/50 dark:group-hover:bg-gray-800/60 group-focus:ring-4 group-focus:ring-white dark:group-focus:ring-gray-800/70 group-focus:outline-none">
                                    <svg
                                        className="w-4 h-4 text-white dark:text-gray-800 rtl:rotate-180"
                                        aria-hidden="true"
                                        xmlns="http://www.w3.org/2000/svg"
                                        fill="none"
                                        viewBox="0 0 6 10"
                                    >
                                        <path
                                            stroke="currentColor"
                                            strokeLinecap="round"
                                            strokeLinejoin="round"
                                            strokeWidth="2"
                                            d="M5 1 1 5l4 4"
                                        />
                                    </svg>
                                    <span className="sr-only">Previous</span>
                                </span>
                            </button>
                            <button
                                type="button"
                                className="absolute top-0 right-0 z-5 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none"
                                data-carousel-next
                                onClick={handleNext}
                            >
                                <span className="inline-flex items-center justify-center w-10 h-10 rounded-full bg-white/30 dark:bg-gray-800/30 group-hover:bg-white/50 dark:group-hover:bg-gray-800/60 group-focus:ring-4 group-focus:ring-white dark:group-focus:ring-gray-800/70 group-focus:outline-none">
                                    <svg
                                        className="w-4 h-4 text-white dark:text-gray-800 rtl:rotate-180"
                                        aria-hidden="true"
                                        xmlns="http://www.w3.org/2000/svg"
                                        fill="none"
                                        viewBox="0 0 6 10"
                                    >
                                        <path
                                            stroke="currentColor"
                                            strokeLinecap="round"
                                            strokeLinejoin="round"
                                            strokeWidth="2"
                                            d="m1 9 4-4-4-4"
                                        />
                                    </svg>
                                    <span className="sr-only">Next</span>
                                </span>
                            </button>
                        </div>





                        <div className="lg:w-1/2 w-full lg:pl-10 lg:py-6 mt-6 lg:mt-0">
                            <h1 className="text-gray-900 text-3xl title-font font-medium mb-1">{product?.title}</h1>
                            <div className="flex mb-4">
                                <span className="flex items-center">
                                    <svg fill="currentColor" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" className="w-4 h-4 text-[#d157f6]" viewBox="0 0 24 24">
                                        <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                                    </svg>
                                    <svg fill="currentColor" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" className="w-4 h-4 text-[#d157f6]" viewBox="0 0 24 24">
                                        <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                                    </svg>
                                    <svg fill="currentColor" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" className="w-4 h-4 text-[#d157f6]" viewBox="0 0 24 24">
                                        <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                                    </svg>
                                    <svg fill="currentColor" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" className="w-4 h-4 text-[#d157f6]" viewBox="0 0 24 24">
                                        <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                                    </svg>
                                    <svg fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" className="w-4 h-4 text-[#d157f6]" viewBox="0 0 24 24">
                                        <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path>
                                    </svg>
                                    <span className="text-gray-600 ml-3">4 Reviews</span>
                                </span>
                                <span className="flex ml-3 pl-3 py-2 border-l-2 border-gray-200 space-x-2s">
                                    <a className="text-gray-500">
                                        <svg fill="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" className="w-5 h-5" viewBox="0 0 24 24">
                                            <path d="M18 2h-3a5 5 0 00-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 011-1h3z"></path>
                                        </svg>
                                    </a>
                                    <a className="text-gray-500">
                                        <svg fill="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" className="w-5 h-5" viewBox="0 0 24 24">
                                            <path d="M23 3a10.9 10.9 0 01-3.14 1.53 4.48 4.48 0 00-7.86 3v1A10.66 10.66 0 013 4s-4 9 5 13a11.64 11.64 0 01-7 2c9 5 20 0 20-11.5a4.5 4.5 0 00-.08-.83A7.72 7.72 0 0023 3z"></path>
                                        </svg>
                                    </a>
                                    <a className="text-gray-500">
                                        <svg fill="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" className="w-5 h-5" viewBox="0 0 24 24">
                                            <path d="M21 11.5a8.38 8.38 0 01-.67 3.25 5.78 5.78 0 00-1.96-.37c-2.71 0-4.97 2.12-4.97 4.73s2.26 4.73 4.97 4.73c1.8 0 3.4-.91 4.34-2.31A8.5 8.5 0 0121 11.5z"></path>
                                        </svg>
                                    </a>
                                    <a className="text-gray-500">
                                        <svg fill="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" className="w-5 h-5" viewBox="0 0 24 24">
                                            <path d="M20.74 3.26a5.22 5.22 0 00-7.39-.22l-.1.1-.11-.11a5.22 5.22 0 00-7.39.22A5.3 5.3 0 002 8.1l-.03.27c-.11.71.01 1.42.31 2.03.38.77.95 1.48 1.64 2.09.89.82 1.85 1.46 2.85 1.92l.56.26c.12.06.25.09.37.09.04 0 .09-.01.13-.02l2.08-1.43a2.65 2.65 0 01.23-.16l.43-.3.08-.04a3.35 3.35 0 01.37-.18l.5-.23a5.5 5.5 0 00.82-.48c.14-.1.28-.22.42-.33l.45-.32c.43-.3.84-.61 1.26-.95l.09-.07a5.3 5.3 0 002.28-4.4l.01-.19a5.3 5.3 0 00-3.25-4.7z"></path>
                                        </svg>
                                    </a>
                                </span>
                            </div>


                            <div className="flex flex-col items-start pb-5 py-2   border-t-2  border-b-2 border-gray-200 ">
                                <h1 className='font-semibold text-lg'>Food Details :</h1>

                                <div>
                                    <span className='font-medium text-base pr-2'>Description :</span>
                                    <span>{product?.description}</span>

                                </div>

                                <div>
                                    <span className='font-medium text-base pr-2'>FoodCategory :</span>
                                    <span>{product?.foodCategory}</span>

                                </div>



                            </div>



                            <div className="flex flex-col items-start pb-5 py-2border-b-2 border-gray-200 ">
                                <h1 className='font-semibold text-lg'>Shop Details :</h1>

                                <div>
                                    <span className='font-medium text-base pr-2'>Name : </span>
                                    <span>{shopUser?.username}</span>
                                </div>
                                <div>
                                    <span className='font-medium text-base pr-2'>Address : </span>
                                    <span>{shopUser?.address}</span>

                                </div>
                                <div>
                                    <span className='font-medium text-base pr-2'>Landmark : </span>
                                    <span>{shopUser?.landmark}</span>

                                </div>
                                <div>
                                    <span className='font-medium text-base pr-2'>City : </span>
                                    <span>{shopUser?.city}</span>

                                </div>
                                <div>
                                    <span className='font-medium text-base pr-2'>State : </span>
                                    <span>{shopUser?.state}</span>

                                </div>


                            </div>

                            <div className="flex items-center justify-between space-x-3">
                                <div>
                                    <span className="title-font font-medium text-2xl text-gray-900">₹ {product?.price}</span>
                                    <div className="title-font font-medium text-sm text-green-700">
                                        Deliver in 30 min
                                    </div>
                                </div>
                                
                                <div className='flex gap-2 '>
                                    <button onClick={handlerBuyNow} className="flex items-center mt-2 font-semibold text-black bg-[#da98ee] border-0 py-2 px-3 md:px-6 focus:outline-none hover:bg-[#882ea3] rounded text-sm md:text-base">Buy Now</button>
                                    <button onClick={handlerAddToCart} className="flex items-center mt-2 font-semibold text-black bg-[#cf91e2] border-0 py-2 px-3 md:px-6 focus:outline-none hover:bg-[#9031ad] rounded text-sm md:text-base"> Add to Cart</button>
                                </div>
                            </div>
                            <div className='flex space-x-2 mt-3'>
                                <input onChange={handlePincodeChange} className='px-2 py-0 rounded-sm bottom-2 bg-gray-200 border-[#782392]' placeholder='Enter your pincode' type='text' name='pincode' />
                                <button onClick={checkServiceAbility} className="flex items-center mt-2 gap-2 font-semibold text-black bg-[#cd8ce0] border-0 py-2 px-3 md:px-6 focus:outline-none hover:bg-[#9f36be] rounded text-sm md:text-base"> Check</button>
                            </div>
                            {
                                serviceable && <div>
                                    {
                                        serviceable ? (
                                            <h1 className='text-green-600 mt-1 font-medium text-sm'>This Pincode is serviceable</h1>
                                        ) : (
                                            <h1 className='text-red-600 mt-1 font-medium text-sm'>Sorry we can&#39;t deliver to this pincode</h1>
                                        )
                                    }
                                </div>
                            }
                        </div>
                    </div>
                </div>
            </section>
        </>
    );
}

export default ProductPage;
