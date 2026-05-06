
'use client'
import { clearCart, decrementQuantity, incrementQuantity } from '@/redux/features/cartSlice';
import { signOut, useSession } from 'next-auth/react';
import Image from 'next/image';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useRef, useState } from 'react';
import { BsCurrencyRupee } from "react-icons/bs";
import { FaUser } from "react-icons/fa6";
import { IoIosAdd } from "react-icons/io";
import { IoBagCheckOutline } from "react-icons/io5";
import { MdClose, MdLogout, MdShoppingCart } from "react-icons/md";
import { PiBroomDuotone } from "react-icons/pi";
import { RiSubtractLine } from "react-icons/ri";
import { useDispatch, useSelector } from 'react-redux';
import LoadingBar from "react-top-loading-bar";
import Toastify from 'toastify-js';
import "toastify-js/src/toastify.css";
import NavbarBottom from './NavbarBottom';
import { usePathname } from 'next/navigation';



const Navbar = () => {
  const cart = useSelector((state) => state.cart.cart);
  const { data: session, status: sessionStatus } = useSession();
  const dispatch = useDispatch();
  const ref = useRef();
  const router = useRouter()
  const pathname = usePathname();
  

  const email = session?.user?.email || "shavez.khanccc@gmail.com";

  const [accont, setaccont] = useState(false)

  const [progress, setProgress] = useState(0);




  const handleSignOut = async () => {
    await signOut();
    router.push('/login')
  }



  let totalPrice = 0;
  cart.forEach((item) => {
    totalPrice += item.price * item.quantity;
  })

  const toggle = () => {
    const body = document.body;
    if (ref.current.classList.contains('translate-x-full')) {
      ref.current.classList.remove('translate-x-full');
      ref.current.classList.remove('hidden');
      ref.current.classList.add('translate-x-0');
      body.classList.add('overflow-hidden');
    } else {
      ref.current.classList.remove('translate-x-0');
      ref.current.classList.add('translate-x-full');
      ref.current.classList.add('hidden');
      body.classList.remove('overflow-hidden');
    }
  };

  const forceCloseCart = () => {
    if (ref.current) {
      ref.current.style.transform = 'translateX(100%)';
      document.body.classList.remove('overflow-hidden');
    }
  };

  const handlerCheckout = () => {

    const body = document.body;
    if (ref.current.classList.contains('translate-x-full')) {
      ref.current.classList.remove('translate-x-full');
      ref.current.classList.add('translate-x-0');
      // ref.current.classList.remove('hidden');
      body.classList.add('overflow-hidden');
    } else {
      ref.current.classList.remove('translate-x-0');
      ref.current.classList.add('translate-x-full');
      // ref.current.classList.add('hidden');
      body.classList.remove('overflow-hidden');
    }

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

    router.push("/checkout")
  }

  return (
    <>
      <LoadingBar
        color="#f11946"
        progress={progress}
        waitingTime={2000}
        onLoaderFinished={() => {
          console.log("Loader finished"); // Debugging statement
          setProgress(0);
        }}
      />
      <div className='flex flex-col bg-white  shadow-sm  sticky top-0 z-20'>
        <div className='flex flex-row  px-2 w-full border border-b-gray-400  md:py-2 justify-between   '>
          <div className='flex flex-col md:flex-row items-start justify-start md:gap-10 '>
            <div >
              <Link href={"/"}>
                <Image
                  className="cursor-pointer w-12 sm:w-16 md:w-20 lg:w-24 xl:w-28"
                  src="/logo.png"
                  height={40}
                  width={120}
                  alt="logo"
                  style={{ height: 'auto', width: 'auto' }}
                />
              </Link>
            </div>
            <div className='md:mt-2'>
              <ul className='flex gap-5 font-bold md:text-base items-center'>
                <Link onClick={() => setProgress(100)} href="/home">
                  <h1>
                    <li className={`cursor-pointer hover:text-xl hover:text-[#d157f6] ${pathname === '/home' ? 'text-[#c036ea] underline underline-offset-4 decoration-2' : ''}`}>Home</li>
                  </h1>
                </Link>
                <Link onClick={() => setProgress(100)} href="/biryani">
                  <h1>
                    <li className={`cursor-pointer hover:text-xl hover:text-[#d157f6] ${pathname === '/biryani' ? 'text-[#c036ea] underline underline-offset-4 decoration-2' : ''}`}>Biryani</li>
                  </h1>
                </Link>
                <Link onClick={() => setProgress(100)} href="/pizza">
                  <h1>
                    <li className={`cursor-pointer hover:text-xl hover:text-[#d157f6] ${pathname === '/pizza' ? 'text-[#c036ea] underline underline-offset-4 decoration-2' : ''}`}>Pizza</li>
                  </h1>
                </Link>

              </ul>
            </div>
          </div>
          <div className='overflow-x-hidden flex  items-center'>
            <div className='flex items-center gap-4' >
              {
                session && session.user ? (
                  <>
                    <div onMouseEnter={() => setaccont(!accont)} onMouseLeave={() => setaccont(!accont)}>

                      <div className='flex items-center justify-center  cursor-pointer'>
                        <h1 className='font-bold text-xl hidden md:block'>{session.user.username || session.user.name}</h1>
                        <FaUser size={22} className=' text-[#b338d9]' />
                      </div>

                      {
                        accont && <div className='absolute top-12 md:top-10 right-12 md:right-16 bg-[#da9ced] py-2 px-3 rounded-md border-[2px] w-40 mr-3 border-[#9a2cbc]'>
                          <div className='flex flex-col gap-2'>
                            <Link href={"/profile"}> <h1 className='cursor-pointer hover:underline ring-offset-4  font-semibold outline-fuchsia-300'>My Account</h1></Link>
                            <Link href={"/orders"}> <h1 className='cursor-pointer hover:underline ring-offset-4 font-semibold outline-fuchsia-300'>My Orders</h1></Link>
                            <button
                              onClick={handleSignOut}
                              className="w-fit text-center mt-2 gap-2 flex justify-center items-center font-semibold text-black bg-[#a15fb6] border-0 py-2 px-5 md:px-6 focus:outline-none hover:bg-[#b13cd4] rounded text-sm md:text-base"
                            >
                              Logout <MdLogout />
                            </button>
                          </div>
                        </div>
                      }</div>
                  </>
                ) : (
                  <>
                    <Link href={'/login'}><button className='cursor-pointer flex items-center  gap-2 text-white bg-[#c57bdc] border-0 py-1 px-3 focus:outline-none hover:bg-[#cb52f0] rounded text-base '>Login</button>
                    </Link>
                  </>
                )
              }
              <MdShoppingCart onClick={toggle} className='cursor-pointer text-[#b146d2]' size={25} />
            </div>
            <div ref={ref} className='absolute top-0 w-70 right-0 bg-[#f8d9def6] min-h-[200vh] py-4 px-3 overflow-x-hidden transform hidden transition-all translate-x-full z-20'>
              <div>
                <MdClose className='absolute top-4 right-2 cursor-pointer text-[#9126b1]' onClick={() => toggle()} size={30} />
                <div>
                  <h2 className='text-center font-semibold text-xl'>Shopping cart</h2>
                  <div className='flex flex-col justify-between items-start py-2 gap-2 max-h-[80vh] overflow-y-auto'>
                    {cart && cart.length > 0 ? (
                      cart.map((item) => (
                        <div key={item.id} className='flex justify-between items-center gap-8 w-full px-3 py-2 border-2 border-[#060f05]'>
                          <div>{item.name}</div>
                          <div>₹{item.price}</div>
                          <div className='flex gap-2 items-center bg-gray-200 py-1 px-2 rounded-sm'>
                            <span
                              className='cursor-pointer text-[#bd3ae5]'
                              onClick={() => dispatch(decrementQuantity({ id: item.id }))}
                            >
                              <RiSubtractLine />
                            </span>
                            <span>{item.quantity}</span>
                            <span
                              className='cursor-pointer text-[#ce42f8]'
                              onClick={() => dispatch(incrementQuantity({ id: item.id }))}
                            >
                              <IoIosAdd />
                            </span>
                          </div>
                        </div>

                      ))
                    ) : (
                      <div>Your cart is empty</div>
                    )}
                  </div>
                  <div className='flex flex-col'>
                    {
                      totalPrice !== 0 && <div className='flex justify-end items-center  flex-row text-base font-semibold'>
                        <div className='mx-2'>Total Price :-</div>
                        <div className='mx-1'><BsCurrencyRupee /></div>
                        <div >{totalPrice}</div>
                      </div>
                    }
                    <div className='flex justify-between gap-10 font-medium'>
                      <button onClick={handlerCheckout} className="flex items-center mt-2 gap-2 text-black bg-[#c67bdc] border-0 py-2 px-6 focus:outline-none hover:bg-[#c74fec] rounded text-base"><IoBagCheckOutline /> Checkout</button>
                      <button className="flex items-center mt-2 gap-2 text-black bg-[#c471de] border-0 py-2 px-6 focus:outline-none hover:bg-[#a738c9] rounded text-base" onClick={() => dispatch(clearCart())}><PiBroomDuotone /> Clear Cart</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        {/* <div className='pt-0 mt-0'>
          <NavbarBottom />
        </div> */}
      </div>
    </>
  )
}

export default Navbar;
