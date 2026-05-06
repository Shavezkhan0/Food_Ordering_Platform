"use client"
import Image from 'next/image'
import { useRouter } from 'next/navigation'
import React, { useEffect, useState } from 'react'
import LoadingBar from "react-top-loading-bar";

const Shop = ({ params }) => {

  const { email } = params;
  const decodedEmail = decodeURIComponent(email);


  const [products, setProducts] = useState([]);
  const [shopUser, setshopUser] = useState(null)
  const router = useRouter()
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const response = await fetch("/api/getShopProducts", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ email: decodedEmail }),
        });
        const result = await response.json();
        setProducts(result.products);

      } catch (error) {
        console.error("Error fetching product:", error);
      }
    };

    fetchProducts();


    const getShopUser = async () => {
      try {
        const res = await fetch("/api/getShopUser", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ email: decodedEmail }),
        });
        const response = await res.json();
        setshopUser(response.shopUser.shopUser);


      } catch (error) {
        console.error("Error fetching product:", error);
      }

    }
    getShopUser()
  }, [decodedEmail]);





  return (
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
      <section className="text-gray-600 body-font items-center">



        <div className="flex  items-center md:flex-row flex-col gap-5 justify-between  m-2 shadow-gray-300 shadow-md  p-2 rounded-sm  ">

          <div className="flex flex-wrap md:w-52 items-start justify-start gap-x-2 gap-y-1 shadow-gray-300 shadow-md  p-2 rounded-sm">
            <div className=' w-full  text-end'>
              {
                shopUser?.shop === "on" ? (
                  <span className='border-2 border-gray-400 p-[2px] bg-green-500 text-white'>On</span>
                ) : (
                  <span className='border-2 border-gray-400 p-[2px] bg-red-500 text-white'>Off</span>

                )
              }
            </div>
            <div className="block  w-full relative items-center justify-center  rounded overflow-hidden">
              <Image alt="ecommerce" src={shopUser?.image[0]?.secure_url} className="cursor-pointer object-cover md:w-48 w-[90vw] h-[30vh] md:h-36"
                width={150}
                height={150} />
            </div>
            <div className='items-start w-full '>
              <div ><span className="text-gray-500 font-semibold text-start text-base tracking-widest title-font ">Name: </span>{shopUser?.username}</div>
            </div>
          </div >

          <div className="flex md:w-1/2 w-full flex-col items-start justify-start text-start md:text-end  shadow-gray-300 shadow-md md:py-2 md:px-3 px-1 py-1 rounded-sm">
            <h3 className="text-gray-500 font-semibold text-start text-lg tracking-widest title-font mb-1">Shop Address :</h3>
            <div ><span className="text-gray-500 font-semibold text-start text-base tracking-widest title-font mb-1">Address: </span>{shopUser?.address}</div>
            <div ><span className="text-gray-500 font-semibold text-start text-base tracking-widest title-font mb-1">Landmark: </span>{shopUser?.landmark}</div>
            <div ><span className="text-gray-500 font-semibold text-start text-base tracking-widest title-font mb-1">City: </span>{shopUser?.city}</div>
            <div ><span className="text-gray-500 font-semibold text-start text-base tracking-widest title-font mb-1">Pincode: </span>{shopUser?.pincode}</div>
            <div ><span className="text-gray-500 font-semibold text-start text-base tracking-widest title-font mb-1">State: </span>{shopUser?.state}</div>
          </div>
        </div>


        <div className="container pl-2 pr-0 py-5 mx-auto ">

          <div className="flex flex-wrap items-center justify-center gap-x-5 gap-y-2 ">


            {
              products?.length > 0 ? (<>
                {
                  products?.map((product) => {
                    return (
                      <div key={product?._id} onClick={() => {
                        setProgress(100)
                        router.push(`/product/${product._id}`)
                      }}
                        className="cursor-pointer flex flex-col  justify-center  w-[80vw]  lg:w-1/6 md:w-1/3 shadow-md shadow-gray-500 p-2 mx-2 my-3">
                        <div className='flex justify-between py-1 items-center'>
                          <div>
                            {/* <span className='font-semibold'>Shop : </span>
                            <span> {product.shopname}</span> */}
                          </div>
                          <div>
                            {
                              product.shop === "on" ? (
                                <span className='border-2 border-gray-400 p-[2px] bg-green-500 text-white'>On</span>
                              ) : (
                                <span className='border-2 border-gray-400 p-[2px] bg-red-500 text-white'>Off</span>

                              )
                            }
                          </div>
                        </div>
                        <div className="block relative items-center justify-center mx-auto rounded overflow-hidden">
                          <Image alt="ecommerce" src={product?.image[0]?.secure_url} className="cursor-pointer object-cover md:w-48 w-[70vw] h-[20vh] md:h-36"
                            width={200}
                            height={200} />
                        </div>
                        <div className="mt-2 flex flex-start flex-col">
                          <h3 className="text-gray-500 font-semibold text-start text-lg tracking-widest title-font mb-1">{product?.title}</h3>
                          <h3 className="text-gray-500 font-normal text-start text-base tracking-widest title-font">{product?.foodCategory}</h3>


                          <p className="mt-1 text-green-400">₹{product?.price}</p>
                        </div>
                      </div>

                    )
                  })
                }
              </>) : (<>
                <div>
                  <p>Product is not available</p>
                </div>
              </>)
            }



          </div>
        </div>
      </section>
    </div>
  )
}



export default Shop