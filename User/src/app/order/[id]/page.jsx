"use client"
import { useSession } from 'next-auth/react';
import Image from 'next/image'
import { useRouter } from 'next/navigation';
import { useEffect, useState } from 'react'
import Toastify from 'toastify-js';
import "toastify-js/src/toastify.css";
import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import LoadingBar from "react-top-loading-bar";

const MYOrder = ({ params }) => {

  const { id } = params;
  const route = useRouter()
  const [order, setOrder] = useState(null);
  const { data: session, status: sessionStatus } = useSession();
  const [activeIndex, setActiveIndex] = useState(0);
  const [imageUrl, setimageUrl] = useState(null)
  const [progress, setProgress] = useState(0);

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

    const getOrder = async () => {
      try {
        const r = await fetch("/api/getOrder", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ id }), // Pass id in an object
        });
        const res = await r.json();
        setOrder(res.order);
        setimageUrl(res.imageUrl);


      } catch (error) {
        console.error("Error fetching order:", error);
      }
    };


    if (id) {
      getOrder();
    }


  }, [id, sessionStatus, route]); // Include id in dependency array






  const handleNext = () => {
    setActiveIndex((prevIndex) => (prevIndex + 1) % imageUrl.length);
  };

  const handlePrev = () => {
    setActiveIndex((prevIndex) => (prevIndex - 1 + imageUrl.length) % imageUrl.length);
  };


  const handleCancellOrder = async (_id) => {

    setProgress(30)
    const res = await fetch("/api/getCancellOrder", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ _id: _id }), // Pass id in an object
    });
    setProgress(70)
    const response = await res.json();

    if (response.success === true) {
      toast.success(`${response.message}`, {
        position: "top-right",
        autoClose: 3000,
        hideProgressBar: false,
        closeOnClick: true,
        pauseOnHover: true,
        draggable: true,
        progress: undefined,
        theme: "light",
      });
      setProgress(100)


      if (response.success === false) {
        toast.error(`${response.message}`, {
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

    }

  }



  if (!order) {
    return <div className='m-5 flex flex-wrap gap-2 md:mx-15 mx-auto justify-center'>

      <div role="status" class="max-w-sm p-4 border border-gray-200 rounded shadow animate-pulse md:p-6 dark:border-gray-700">
        <div class="flex items-center justify-center h-48 mb-4 bg-gray-300 rounded dark:bg-gray-700">
          <svg class="w-10 h-10 text-gray-200 dark:text-gray-600" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 20">
            <path d="M14.066 0H7v5a2 2 0 0 1-2 2H0v11a1.97 1.97 0 0 0 1.934 2h12.132A1.97 1.97 0 0 0 16 18V2a1.97 1.97 0 0 0-1.934-2ZM10.5 6a1.5 1.5 0 1 1 0 2.999A1.5 1.5 0 0 1 10.5 6Zm2.221 10.515a1 1 0 0 1-.858.485h-8a1 1 0 0 1-.9-1.43L5.6 10.039a.978.978 0 0 1 .936-.57 1 1 0 0 1 .9.632l1.181 2.981.541-1a.945.945 0 0 1 .883-.522 1 1 0 0 1 .879.529l1.832 3.438a1 1 0 0 1-.031.988Z" />
            <path d="M5 5V.13a2.96 2.96 0 0 0-1.293.749L.879 3.707A2.98 2.98 0 0 0 .13 5H5Z" />
          </svg>
        </div>
        <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-48 mb-4"></div>
        <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
        <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>

      </div>

      <div role="status" class="max-w-sm p-4 border border-gray-200 rounded shadow animate-pulse md:p-6 dark:border-gray-700">
        <div class="flex items-center justify-center h-48 mb-4 bg-gray-300 rounded dark:bg-gray-700">
          <svg class="w-10 h-10 text-gray-200 dark:text-gray-600" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 20">
            <path d="M14.066 0H7v5a2 2 0 0 1-2 2H0v11a1.97 1.97 0 0 0 1.934 2h12.132A1.97 1.97 0 0 0 16 18V2a1.97 1.97 0 0 0-1.934-2ZM10.5 6a1.5 1.5 0 1 1 0 2.999A1.5 1.5 0 0 1 10.5 6Zm2.221 10.515a1 1 0 0 1-.858.485h-8a1 1 0 0 1-.9-1.43L5.6 10.039a.978.978 0 0 1 .936-.57 1 1 0 0 1 .9.632l1.181 2.981.541-1a.945.945 0 0 1 .883-.522 1 1 0 0 1 .879.529l1.832 3.438a1 1 0 0 1-.031.988Z" />
            <path d="M5 5V.13a2.96 2.96 0 0 0-1.293.749L.879 3.707A2.98 2.98 0 0 0 .13 5H5Z" />
          </svg>
        </div>
        <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-48 mb-4"></div>
        <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
        <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>

      </div>


      <div role="status" class="max-w-sm p-4 border border-gray-200 rounded shadow animate-pulse md:p-6 dark:border-gray-700">
        <div class="flex items-center justify-center h-48 mb-4 bg-gray-300 rounded dark:bg-gray-700">
          <svg class="w-10 h-10 text-gray-200 dark:text-gray-600" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 20">
            <path d="M14.066 0H7v5a2 2 0 0 1-2 2H0v11a1.97 1.97 0 0 0 1.934 2h12.132A1.97 1.97 0 0 0 16 18V2a1.97 1.97 0 0 0-1.934-2ZM10.5 6a1.5 1.5 0 1 1 0 2.999A1.5 1.5 0 0 1 10.5 6Zm2.221 10.515a1 1 0 0 1-.858.485h-8a1 1 0 0 1-.9-1.43L5.6 10.039a.978.978 0 0 1 .936-.57 1 1 0 0 1 .9.632l1.181 2.981.541-1a.945.945 0 0 1 .883-.522 1 1 0 0 1 .879.529l1.832 3.438a1 1 0 0 1-.031.988Z" />
            <path d="M5 5V.13a2.96 2.96 0 0 0-1.293.749L.879 3.707A2.98 2.98 0 0 0 .13 5H5Z" />
          </svg>
        </div>
        <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-48 mb-4"></div>
        <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
        <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>

      </div>


      <div role="status" class="max-w-sm p-4 border border-gray-200 rounded shadow animate-pulse md:p-6 dark:border-gray-700">
        <div class="flex items-center justify-center h-48 mb-4 bg-gray-300 rounded dark:bg-gray-700">
          <svg class="w-10 h-10 text-gray-200 dark:text-gray-600" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 20">
            <path d="M14.066 0H7v5a2 2 0 0 1-2 2H0v11a1.97 1.97 0 0 0 1.934 2h12.132A1.97 1.97 0 0 0 16 18V2a1.97 1.97 0 0 0-1.934-2ZM10.5 6a1.5 1.5 0 1 1 0 2.999A1.5 1.5 0 0 1 10.5 6Zm2.221 10.515a1 1 0 0 1-.858.485h-8a1 1 0 0 1-.9-1.43L5.6 10.039a.978.978 0 0 1 .936-.57 1 1 0 0 1 .9.632l1.181 2.981.541-1a.945.945 0 0 1 .883-.522 1 1 0 0 1 .879.529l1.832 3.438a1 1 0 0 1-.031.988Z" />
            <path d="M5 5V.13a2.96 2.96 0 0 0-1.293.749L.879 3.707A2.98 2.98 0 0 0 .13 5H5Z" />
          </svg>
        </div>
        <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-48 mb-4"></div>
        <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
        <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>

      </div>


      <div role="status" class="max-w-sm p-4 border border-gray-200 rounded shadow animate-pulse md:p-6 dark:border-gray-700">
        <div class="flex items-center justify-center h-48 mb-4 bg-gray-300 rounded dark:bg-gray-700">
          <svg class="w-10 h-10 text-gray-200 dark:text-gray-600" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 20">
            <path d="M14.066 0H7v5a2 2 0 0 1-2 2H0v11a1.97 1.97 0 0 0 1.934 2h12.132A1.97 1.97 0 0 0 16 18V2a1.97 1.97 0 0 0-1.934-2ZM10.5 6a1.5 1.5 0 1 1 0 2.999A1.5 1.5 0 0 1 10.5 6Zm2.221 10.515a1 1 0 0 1-.858.485h-8a1 1 0 0 1-.9-1.43L5.6 10.039a.978.978 0 0 1 .936-.57 1 1 0 0 1 .9.632l1.181 2.981.541-1a.945.945 0 0 1 .883-.522 1 1 0 0 1 .879.529l1.832 3.438a1 1 0 0 1-.031.988Z" />
            <path d="M5 5V.13a2.96 2.96 0 0 0-1.293.749L.879 3.707A2.98 2.98 0 0 0 .13 5H5Z" />
          </svg>
        </div>
        <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-48 mb-4"></div>
        <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
        <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>

      </div>


     

    </div>;
  
     
  }


  const updatedAt = new Date(order.updatedAt);
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
    <div>
      <LoadingBar
        color="#f11946"
        progress={progress}
        waitingTime={3000}
        onLoaderFinished={() => {
          console.log("Loader finished"); // Debugging statement
          setProgress(0);
        }}
      />
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
      <section className="text-gray-600 body-font overflow-hidden">
        <div className="container px-5  mx-auto">
          <div className="lg:w-4/5 mx-auto flex flex-wrap">
            <div className="lg:w-1/2 w-full lg:pr-10 lg:py-6 mb-6 lg:mb-0">
              <h1 className="text-gray-900 text-2xl title-font font-medium mb-1">OrderId {order.orderId}</h1>
              <div>
                <span>Date: {formattedDate}</span><br />
                <span>Time: {formattedTime}</span>
              </div>
              <div>
                {order?.deliverystatus?.deliver === "cancelled" || order?.deliverystatus?.pack === "cancelled" || order?.deliverystatus?.shipped === "cancelled" ? (<div>
                  <h5 className='text-red-600'>Your Order Cancelled</h5>
                </div>) : order?.deliverystatus?.deliver === "pending" ? (<div>
                  <h5>Your order will be Deliver with in 30 min</h5>
                </div>) : (<div>
                  <h5 className='text-green-600'>Your order has been Delivered successfully</h5>

                </div>)
                }
              </div>
              <div className="flex mt-4 mb-4">
                <a className="flex-grow text-center text-[#cb37f8] border-b-2 border-[#b536db] py-2 text-lg px-1">Name</a>
                <a className="flex-grow text-center border-b-2 border-gray-300 py-2 text-lg px-1">Quantity</a>
                <a className="flex-grow text-center border-b-2 border-gray-300 py-2 text-lg px-1">Total</a>
              </div>

              {
                order?.products.map((item) => {


                  return <>
                    <div key={order.orderId} className="flex border-t border-gray-200 py-2 justify-between items-center">
                      <span className="text-gray-500 w-1/3 items-start">{item.name}</span>
                      <span className="ml-auto text-gray-900  w-1/3   text-center">{item.quantity}</span>
                      <span className="ml-auto text-gray-900  w-1/3 text-center ">{item.price * item.quantity}</span>
                    </div>
                  </>
                })
              }
              <div className='flex border-t border-gray-200 py-2 justify-between items-center'>
                <span className="text-gray-500 w-1/3 items-start">Delivery Charge</span>
                <span className="text-gray-500 w-1/3 items-start"></span>
                <span className="ml-auto text-gray-900  w-1/3 text-center ">{order?.deliveryamount}</span>
              </div>


              <section className="text-gray-600 body-font">
                <div className="items-start justify-start flex flex-col">


                  <div className="flex relative  pt-5 pb-5  md:w-2/3">

                    <div className="h-full w-6 absolute inset-0 flex items-center justify-center">
                      <div className={`h-full w-1 ${order?.deliverystatus?.deliver === "cancelled" ? "bg-red-500" : "bg-green-500"}  pointer-events-none`}></div>
                    </div>

                    <div className="flex-shrink-0 w-6 h-6 rounded-full  inline-flex items-center justify-center bg-indigo-500 text-white relative z-10 title-font font-medium text-sm">1</div>


                    <div className="flex-grow md:pl-8 pl-6 flex  items-center flex-row gap-3">
                      <div className="flex-shrink-0 w-10 h-10 bg-indigo-100 text-indigo-500 rounded-full inline-flex items-center justify-center">
                        <svg fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" className="w-4 h-4" viewBox="0 0 24 24">
                          <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        </svg>
                      </div>

                      <div className="flex-grow sm:pl-6 ">
                        <h2 className="font-medium title-font text-gray-900 mb-1 text-xl">Order Placed</h2>
                      </div>
                    </div>
                  </div>



                  <div className="flex relative pb-5 sm:items-center md:w-2/3 ">
                    <div className="h-full w-6 absolute inset-0 flex items-center justify-center">
                      <div className={`h-full w-1 ${order?.deliverystatus?.pack === "cancelled" ? "bg-red-500" : order?.deliverystatus?.pack === "success" ? "bg-green-500" : "bg-gray-200"} bg-gray-200 pointer-events-none`}></div>
                    </div>
                    <div className="flex-shrink-0 w-6 h-6 rounded-full   inline-flex items-center justify-center bg-indigo-500 text-white relative z-10 title-font font-medium text-sm">2</div>
                    <div className="flex-grow md:pl-8 pl-6 flex  items-center flex-row gap-3">
                      <div className="flex-shrink-0 w-10 h-10 bg-indigo-100 text-indigo-500 rounded-full inline-flex items-center justify-center">
                        <svg fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" className="w-6 h-6" viewBox="0 0 24 24">
                          <path d="M22 12h-4l-3 9L9 3l-3 9H2"></path>
                        </svg>
                      </div>

                      <div className="flex-grow sm:pl-6 ">
                        <h2 className="font-medium title-font text-gray-900 mb-1 text-xl">Packed</h2>

                      </div>
                    </div>
                  </div>


                  <div className="flex relative pb-5 sm:items-center md:w-2/3 ">
                    <div className="h-full w-6 absolute inset-0 flex items-center justify-center">
                      <div className={`h-full w-1 ${order?.deliverystatus?.shipped === "cancelled" ? "bg-red-500" : order?.deliverystatus?.shipped === "success" ? "bg-green-500" : "bg-gray-200"} bg-gray-200 pointer-events-none`}></div>
                    </div>
                    <div className="flex-shrink-0 w-6 h-6 rounded-full   inline-flex items-center justify-center bg-indigo-500 text-white relative z-10 title-font font-medium text-sm">3</div>
                    <div className="flex-grow md:pl-8 pl-6 flex  items-center flex-row gap-3">
                      <div className="flex-shrink-0 w-10 h-10 bg-indigo-100 text-indigo-500 rounded-full inline-flex items-center justify-center">
                        <svg fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" className="w-6 h-6" viewBox="0 0 24 24">
                          <circle cx="12" cy="5" r="3"></circle>
                          <path d="M12 22V8M5 12H2a10 10 0 0020 0h-3"></path>
                        </svg>
                      </div>

                      <div className="flex-grow sm:pl-6 ">
                        <h2 className="font-medium title-font text-gray-900 mb-1 text-xl">Shipped</h2>

                      </div>
                    </div>
                  </div>


                  <div className="flex relative pb-5 sm:items-center md:w-2/3 ">
                    <div className="h-full w-6 absolute inset-0 flex items-center justify-center">
                      <div className={`h-full w-1 ${order?.deliverystatus?.deliver === "cancelled" ? "bg-red-500" : order?.deliverystatus?.deliver === "success" ? "bg-green-500" : "bg-gray-200"} bg-gray-200 pointer-events-none`}></div>
                    </div>
                    <div className="flex-shrink-0 w-6 h-6 rounded-full   inline-flex items-center justify-center bg-indigo-500 text-white relative z-10 title-font font-medium text-sm">4</div>
                    <div className="flex-grow md:pl-8 pl-6 flex  items-center flex-row gap-3">
                      <div className="flex-shrink-0 w-10 h-10 bg-indigo-100 text-indigo-500 rounded-full inline-flex items-center justify-center">
                        <svg fill="none" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" className="w-6 h-6" viewBox="0 0 24 24">
                          <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"></path>
                          <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                      </div>

                      <div className="flex-grow sm:pl-6 ">
                        <h2 className="font-medium title-font text-gray-900 mb-1 text-xl">Delevered</h2>

                      </div>
                    </div>
                  </div>
                </div>
              </section>




              <div className="flex flex-col py-2">

                <span className="title-font font-medium text-2xl text-gray-900">Total Amount: <span>&#8377;</span>{order.amount}</span>
                <div className='flex w-fit'>


                  {
                    order?.deliverystatus?.deliver === "cancelled" || order?.deliverystatus?.pack === "cancelled" || order?.deliverystatus?.shipped === "cancelled" ? (<div>
                      <button className="flex px-5 mt-2 w-48 justify-center items-center text-white bg-[#f52c2c] border-0 py-2 focus:outline-none  rounded">Order Cancelled</button>
                    </div>) : order?.deliverystatus?.deliver === "success" ? (<div>
                      <button className="flex px-5 mt-2 w-48 justify-center items-center text-white bg-[#d464f7] border-0 py-2 focus:outline-none hover:bg-green-600 rounded">Order Completed</button>
                    </div>) : order?.deliverystatus?.pack === "pending" ? (
                      <div>
                        <button onClick={() => handleCancellOrder(order._id)} className="flex px-5 mt-2 w-40 text-white bg-[#cc4df3] border-0 py-2 focus:outline-none hover:bg-red-600 rounded">Cancel Order</button>
                      </div>
                    ) : (

                      <div>
                        <button className="flex px-5 mt-2 w-40 text-white bg-[#cc4df3] border-0 py-2 focus:outline-none hover:bg-blue-600 rounded">Order Will deliver Soon</button>
                      </div>
                    )


                  }





                </div>
              </div>
            </div>


            <div id="gallery" className="relative w-full  md:w-[30vw]" data-carousel="slide">
              <div className="relative h-56 overflow-hidden md:top-48 rounded-lg shadow-md shadow-[#d36df1] md:h-96">


                {imageUrl?.map((image, index) => (
                  <div
                    key={index}
                    className={`absolute inset-0 transition-opacity duration-700 ease-in-out ${index === activeIndex ? 'opacity-100' : 'opacity-0'
                      }`}
                    data-carousel-item
                  >
                    <Image
                      alt="ecommerce"
                      className="shadow-lg shadow-[#d172ee] p-2"
                      src={image}
                      layout="fill"
                      objectFit="cover"
                    />
                  </div>
                ))}
              </div>

              <button
                type="button"
                className="md:top-36 absolute top-0 left-0 z-10 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none"
                data-carousel-prev
                onClick={handlePrev}
              >
                <span className="inline-flex items-center justify-center w-10 h-10 rounded-full bg-black/70 dark:bg-black/70 group-hover:bg-black/90 dark:group-hover:bg-black/90 group-focus:ring-4 group-focus:ring-black dark:group-focus:ring-black/90 group-focus:outline-none">
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
                className="md:top-36 absolute top-0 right-0 z-10 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none"
                data-carousel-next
                onClick={handleNext}
              >
                <span className="inline-flex items-center justify-center w-10 h-10 rounded-full bg-black/70 dark:bg-black/70 group-hover:bg-black/90 dark:group-hover:bg-black/90 group-focus:ring-4 group-focus:ring-black dark:group-focus:ring-black/90 group-focus:outline-none">
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


          </div>
        </div>
      </section>
    </div>
  )
}


export default MYOrder