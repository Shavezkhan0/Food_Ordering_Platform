"use client";
import Head from "next/head";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useState, useCallback } from "react";
import LoadingBar from "react-top-loading-bar";
import { NextSeo } from "next-seo";

export default function Home() {
  const [Shops, setShops] = useState(null);
  const [Products, setProducts] = useState([]);
  const [progress, setProgress] = useState(0);
  const [loading, setLoading] = useState(true);
  const [isLoading, setisLoading] = useState(false);
  const [hasMore, setHasMore] = useState(true); // To check if more products are available
  const router = useRouter();
  const [isPopupVisible, setIsPopupVisible] = useState(true);

  useEffect(() => {
    const fetchShops = async () => {
      try {
        const r = await fetch("/api/shops/getshops");
        const data = await r.json();
        setShops(data.shops);
        setLoading(false);
      } catch (error) {
        console.error("Failed to fetch Shops:", error);
      }
    };

    fetchShops();
    fetchProducts(20); // Initial fetch with a limit of 2 products
  }, []);

  const fetchProducts = useCallback(
    async (limit = 20, skip = Products.length) => {
      if (isLoading || !hasMore) return; // Prevent duplicate fetches
      setisLoading(true);

      try {
        const r = await fetch(`/api/getonproducts?limit=${limit}&skip=${skip}`);
        const data = await r.json();

        if (data.products.length === 0) {
          setHasMore(false); // No more products to load
        } else {
          setProducts((prevProducts) => [...prevProducts, ...data.products]); // Append new products
        }

        setisLoading(false);
      } catch (error) {
        console.error("Failed to fetch products:", error);
        setisLoading(false);
      }
    },
    [isLoading, hasMore, Products.length]
  );

  const handleInfiniteScroll = useCallback(() => {
    if (
      window.innerHeight + document.documentElement.scrollTop + 450 >=
      document.documentElement.scrollHeight
    ) {
      fetchProducts(20, Products.length);
    }
  }, [fetchProducts, Products.length]);

  useEffect(() => {
    window.addEventListener("scroll", handleInfiniteScroll);
    return () => window.removeEventListener("scroll", handleInfiniteScroll);
  }, [handleInfiniteScroll]);

  const handleClose = () => {
    setIsPopupVisible(false);
  };

  if (loading) {
    return (
      <div className="m-5 flex flex-wrap gap-2 md:mx-15 mx-auto justify-center">
        <div
          role="status"
          class="max-w-sm p-4 border border-gray-200 rounded shadow animate-pulse md:p-6 dark:border-gray-700"
        >
          <div class="flex items-center justify-center h-48 mb-4 bg-gray-300 rounded dark:bg-gray-700">
            <svg
              class="w-10 h-10 text-gray-200 dark:text-gray-600"
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              fill="currentColor"
              viewBox="0 0 16 20"
            >
              <path d="M14.066 0H7v5a2 2 0 0 1-2 2H0v11a1.97 1.97 0 0 0 1.934 2h12.132A1.97 1.97 0 0 0 16 18V2a1.97 1.97 0 0 0-1.934-2ZM10.5 6a1.5 1.5 0 1 1 0 2.999A1.5 1.5 0 0 1 10.5 6Zm2.221 10.515a1 1 0 0 1-.858.485h-8a1 1 0 0 1-.9-1.43L5.6 10.039a.978.978 0 0 1 .936-.57 1 1 0 0 1 .9.632l1.181 2.981.541-1a.945.945 0 0 1 .883-.522 1 1 0 0 1 .879.529l1.832 3.438a1 1 0 0 1-.031.988Z" />
              <path d="M5 5V.13a2.96 2.96 0 0 0-1.293.749L.879 3.707A2.98 2.98 0 0 0 .13 5H5Z" />
            </svg>
          </div>
          <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-48 mb-4"></div>
          <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
          <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
        </div>

        <div
          role="status"
          class="max-w-sm p-4 border border-gray-200 rounded shadow animate-pulse md:p-6 dark:border-gray-700"
        >
          <div class="flex items-center justify-center h-48 mb-4 bg-gray-300 rounded dark:bg-gray-700">
            <svg
              class="w-10 h-10 text-gray-200 dark:text-gray-600"
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              fill="currentColor"
              viewBox="0 0 16 20"
            >
              <path d="M14.066 0H7v5a2 2 0 0 1-2 2H0v11a1.97 1.97 0 0 0 1.934 2h12.132A1.97 1.97 0 0 0 16 18V2a1.97 1.97 0 0 0-1.934-2ZM10.5 6a1.5 1.5 0 1 1 0 2.999A1.5 1.5 0 0 1 10.5 6Zm2.221 10.515a1 1 0 0 1-.858.485h-8a1 1 0 0 1-.9-1.43L5.6 10.039a.978.978 0 0 1 .936-.57 1 1 0 0 1 .9.632l1.181 2.981.541-1a.945.945 0 0 1 .883-.522 1 1 0 0 1 .879.529l1.832 3.438a1 1 0 0 1-.031.988Z" />
              <path d="M5 5V.13a2.96 2.96 0 0 0-1.293.749L.879 3.707A2.98 2.98 0 0 0 .13 5H5Z" />
            </svg>
          </div>
          <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-48 mb-4"></div>
          <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
          <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
        </div>

        <div
          role="status"
          class="max-w-sm p-4 border border-gray-200 rounded shadow animate-pulse md:p-6 dark:border-gray-700"
        >
          <div class="flex items-center justify-center h-48 mb-4 bg-gray-300 rounded dark:bg-gray-700">
            <svg
              class="w-10 h-10 text-gray-200 dark:text-gray-600"
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              fill="currentColor"
              viewBox="0 0 16 20"
            >
              <path d="M14.066 0H7v5a2 2 0 0 1-2 2H0v11a1.97 1.97 0 0 0 1.934 2h12.132A1.97 1.97 0 0 0 16 18V2a1.97 1.97 0 0 0-1.934-2ZM10.5 6a1.5 1.5 0 1 1 0 2.999A1.5 1.5 0 0 1 10.5 6Zm2.221 10.515a1 1 0 0 1-.858.485h-8a1 1 0 0 1-.9-1.43L5.6 10.039a.978.978 0 0 1 .936-.57 1 1 0 0 1 .9.632l1.181 2.981.541-1a.945.945 0 0 1 .883-.522 1 1 0 0 1 .879.529l1.832 3.438a1 1 0 0 1-.031.988Z" />
              <path d="M5 5V.13a2.96 2.96 0 0 0-1.293.749L.879 3.707A2.98 2.98 0 0 0 .13 5H5Z" />
            </svg>
          </div>
          <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-48 mb-4"></div>
          <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
          <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
        </div>

        <div
          role="status"
          class="max-w-sm p-4 border border-gray-200 rounded shadow animate-pulse md:p-6 dark:border-gray-700"
        >
          <div class="flex items-center justify-center h-48 mb-4 bg-gray-300 rounded dark:bg-gray-700">
            <svg
              class="w-10 h-10 text-gray-200 dark:text-gray-600"
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              fill="currentColor"
              viewBox="0 0 16 20"
            >
              <path d="M14.066 0H7v5a2 2 0 0 1-2 2H0v11a1.97 1.97 0 0 0 1.934 2h12.132A1.97 1.97 0 0 0 16 18V2a1.97 1.97 0 0 0-1.934-2ZM10.5 6a1.5 1.5 0 1 1 0 2.999A1.5 1.5 0 0 1 10.5 6Zm2.221 10.515a1 1 0 0 1-.858.485h-8a1 1 0 0 1-.9-1.43L5.6 10.039a.978.978 0 0 1 .936-.57 1 1 0 0 1 .9.632l1.181 2.981.541-1a.945.945 0 0 1 .883-.522 1 1 0 0 1 .879.529l1.832 3.438a1 1 0 0 1-.031.988Z" />
              <path d="M5 5V.13a2.96 2.96 0 0 0-1.293.749L.879 3.707A2.98 2.98 0 0 0 .13 5H5Z" />
            </svg>
          </div>
          <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-48 mb-4"></div>
          <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
          <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
        </div>

        <div
          role="status"
          class="max-w-sm p-4 border border-gray-200 rounded shadow animate-pulse md:p-6 dark:border-gray-700"
        >
          <div class="flex items-center justify-center h-48 mb-4 bg-gray-300 rounded dark:bg-gray-700">
            <svg
              class="w-10 h-10 text-gray-200 dark:text-gray-600"
              aria-hidden="true"
              xmlns="http://www.w3.org/2000/svg"
              fill="currentColor"
              viewBox="0 0 16 20"
            >
              <path d="M14.066 0H7v5a2 2 0 0 1-2 2H0v11a1.97 1.97 0 0 0 1.934 2h12.132A1.97 1.97 0 0 0 16 18V2a1.97 1.97 0 0 0-1.934-2ZM10.5 6a1.5 1.5 0 1 1 0 2.999A1.5 1.5 0 0 1 10.5 6Zm2.221 10.515a1 1 0 0 1-.858.485h-8a1 1 0 0 1-.9-1.43L5.6 10.039a.978.978 0 0 1 .936-.57 1 1 0 0 1 .9.632l1.181 2.981.541-1a.945.945 0 0 1 .883-.522 1 1 0 0 1 .879.529l1.832 3.438a1 1 0 0 1-.031.988Z" />
              <path d="M5 5V.13a2.96 2.96 0 0 0-1.293.749L.879 3.707A2.98 2.98 0 0 0 .13 5H5Z" />
            </svg>
          </div>
          <div class="h-2.5 bg-gray-200 rounded-full dark:bg-gray-700 w-48 mb-4"></div>
          <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
          <div class="h-2 bg-gray-200 rounded-full dark:bg-gray-700 mb-2.5"></div>
        </div>
      </div>
    );
  }

  return (
    <>
      <LoadingBar
        color="#f11946"
        progress={progress}
        waitingTime={3000}
        onLoaderFinished={() => setProgress(0)}
      />
      <NextSeo
        title="Okhla Dastarkhan - Order Food from Your Favorite Restaurants"
        description="Order delicious food from top-rated restaurants in Okhla with Okhla Dastarkhan. Enjoy fast delivery and convenient online ordering."
        keywords="okhla dastarkhan  ,Okhla Dastarkhan  ,okhla dastarkhwan ,Okhla Dastarkhwan ,Okhla food delivery, Okhla restaurants, food delivery app, online food ordering, Okhla Dastarkhan"
      />
      <div className="fixed z-20 top-40 flex justify-center items-center w-[100vw]">
        {isPopupVisible && (
          <div className="py-2 px-4 shadow-md shadow-[#C57BDC] w-[80vw] md:w-[30vw] bg-[#C57BDC] text-white">
            <div className="flex justify-between items-center">
              <h3 className="text-xl font-bold">Exclusive Offer!</h3>
              <button
                className="text-white hover:text-gray-300 "
                onClick={handleClose}
              >
                &times;
              </button>
            </div>
            <p className="text-base">
              <p>
                Enjoy Free delivery on order above
                <span className="text-[#56fc44]">
                  {" "}
                  <span>&#8377;</span>499
                </span>{" "}
              </p>
              <p className="text-sm">
                <p>Your Order Will deliver With in 30 min. </p>
                <p>Your satisfaction is our priority.</p>
                <p>We are here to serve you. </p>
                <p>Contact Us Without Hesitation</p>
                <p>
                  <a
                    href="tel:9311148483"
                    className="text-gray-600 hover:text-gray-800"
                  >
                    9311148483
                  </a>
                  {" , "}
                  <a
                    href="tel:8447184092"
                    className="text-gray-600 hover:text-gray-800"
                  >
                    8447184092
                  </a>
                </p>
              </p>
            </p>
            <button
              onClick={handleClose}
              className="bg-white text-[#C57BDC] hover:bg-[#a23fc1] hover:text-white px-4 py-2 rounded-md mt-2"
            >
              Try Now
            </button>
          </div>
        )}
      </div>

      <main>
        <Head>
          <title>Home page</title>
          <link rel="icon" href="/favicon.ico" />
        </Head>
        <div className="border-t-2 mb-1 pb-2 border-b-2 border-gray-300">
          <Link href={"/shops"} className="flex justify-end">
            <button className="cursor-pointer font-medium px-3 py-1 hover:underline-offset-2 text-black">
              All shops
            </button>
          </Link>
          <div className="flex flex-row overflow-x-auto py-2">
            {Shops ? (
              Shops.slice()
                .reverse()
                .map((shop) => (
                  <div
                    key={shop._id}
                    onClick={() => {
                      setProgress(100);
                      router.push(`/shop/${shop.email}`);
                    }}
                    className="cursor-pointer flex flex-col justify-center lg:w-1/6 md:w-1/3 shadow-md shadow-gray-500 p-1 mx-2"
                  >
                    <div className="flex text-sm justify-between md:py-1 items-center">
                      <div className="min-w-36 md:py-0 py-1">
                        <span className="font-semibold">Shop :</span>
                        <span className="md:text-base text-sm">
                          {shop.username}
                        </span>
                      </div>
                      <div>
                        {shop.shop === "on" ? (
                          <span className="border-2 border-gray-400 p-[2px] bg-green-500 text-white">
                            On
                          </span>
                        ) : (
                          <span className="border-2 border-gray-400 p-[2px] bg-red-500 text-white">
                            Off
                          </span>
                        )}
                      </div>
                    </div>
                    <div className="block relative items-center object-contain justify-center mx-auto rounded overflow-hidden">
                      <Image
                        alt="ecommerce"
                        src={shop.image[0]?.secure_url}
                        className="cursor-pointer object-cover w-44 h-32"
                        width={200}
                        height={200}
                      />
                    </div>
                    <div className="flex text-sm justify-start items-center">
                      <div className="flex flex-col items-start">
                        <div>
                          <span className="font-medium">Landmark :</span>
                          <span className="font-light text-sm">
                            {" "}
                            {shop.landmark}
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>
                ))
            ) : (
              <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded-md shadow-md max-w-xl mx-auto my-4 md:my-16">
                <p class="text-lg md:text-xl font-semibold text-center">
                  Shop are not Open
                </p>
              </div>
            )}
          </div>
        </div>
        <section className="text-gray-600 body-font items-center">
          <div className="container pl-2 pr-0 py-5 mx-auto">
            <div className="flex justify-center items-center">
              <h1 className="font-medium text-2xl">All Foods</h1>
            </div>
            <div className="flex flex-wrap items-center justify-center gap-x-5 gap-y-2">
              {Products.length > 0 ? (
                Products.map((product) => (
                  <div
                    key={product._id}
                    onClick={() => router.push(`/product/${product._id}`)}
                    className="cursor-pointer flex flex-col justify-center w-[80vw] lg:w-1/6 md:w-1/3 shadow-md shadow-gray-500 p-2 mx-2 my-3"
                  >
                    <div className="flex justify-between py-1 items-center">
                      <div>
                        <span className="font-semibold">Shop :</span>
                        <span> {product.shopname}</span>
                      </div>
                      <div>
                        {product.shop === "on" ? (
                          <span className="border-2 border-gray-400 p-[2px] bg-green-500 text-white">
                            On
                          </span>
                        ) : (
                          <span className="border-2 border-gray-400 p-[2px] bg-red-500 text-white">
                            Off
                          </span>
                        )}
                      </div>
                    </div>
                    <div className="block relative items-center justify-center mx-auto rounded overflow-hidden">
                      <Image
                        alt="ecommerce"
                        src={product.image[0]?.secure_url}
                        className="cursor-pointer object-cover md:w-48 w-[70vw] h-[20vh] md:h-36"
                        width={200}
                        height={200}
                      />
                    </div>
                    <div className="mt-2 flex flex-start flex-col">
                      <h3 className="text-gray-500 font-semibold text-start text-lg tracking-widest title-font mb-1">
                        {product.title}
                      </h3>
                      <p className="mt-1 text-green-400">
                        <span>&#8377;</span>
                        {product.price}
                      </p>
                    </div>
                  </div>
                ))
              ) : (
                <div className="flex justify-center items-center">
                  <p>Loading more products...</p>
                </div>
              )}
              {isLoading && (
                <div className="flex justify-center items-center">
                  <p>Loading more products...</p>
                </div>
              )}
            </div>
          </div>
        </section>
      </main>
    </>
  );
}
