"use client"
import Link from 'next/link'
import React, { useRef, useState } from 'react'
import { IoMdClose } from "react-icons/io";
import { usePathname } from 'next/navigation';
import Image from 'next/image';

const NavbarBottom = () => {

  const ref = useRef()
  const [all, setAll] = useState(false)
  const pathname = usePathname();

  const toggleAllCategory = async () => {
    if (ref.current.classList.contains('overflow-x-auto')) {
      ref.current.classList.remove('overflow-x-auto');
      ref.current.classList.add('flex-wrap');
      setAll(true)
    } else {
      ref.current.classList.add('overflow-x-auto');
      ref.current.classList.remove('flex-wrap');
      setAll(false)
    }
  }

  return (
    <div className='pl-3 py-1 bg-[#FFFFFF] shadow-sm shadow-[#B338D9] z-10 relative top-0'>
      <div ref={ref} className='flex flex-row w-full gap-3 sm:hide-scrollbar md:show-scrollbar overflow-x-auto  pt-[1px] pb-[2px]'>
        {
          !all ? (
            <button onClick={() => toggleAllCategory()} >

              <div className='w-14 h-14  bg-gray-300 flex justify-center items-center rounded-full'>
                <p>All</p>
              </div>



            </button>
          ) : (
            <button onClick={() => toggleAllCategory()} >
              <div className='w-14 h-14 bg-gray-700 text-[#d47df6] flex justify-center items-center rounded-full'>
                <p><IoMdClose size={23} /></p>
              </div>

            </button>
          )
        }


        <Link href={"/momo"}><button >
          <div className="flex flex-col items-center space-y-0">
            <div className={`w-14 h-14 bg-gray-200 flex justify-center items-center rounded-full overflow-hidden ${pathname === '/momo' ? 'border-2 border-[#742095] ' : ''}`}>
              <Image src="/foodimg/momo.avif" alt="Roll Image" width={100} height={100} className="object-contain" />
            </div>
            <p className={`text-sm font-medium  ${pathname === '/momo' ? 'text-[#742095] font-semibold' : ''}`}>Momo</p>
          </div>
        </button>
        </Link>

        <Link href={"/chowmein"}><button >
          <div className="flex flex-col items-center space-y-0">
            <div className={`w-14 h-14 bg-gray-200 flex justify-center items-center rounded-full overflow-hidden ${pathname === '/chowmein' ? 'border-2 border-[#742095] ' : ''}`}>
              <Image src="/foodimg/chowmein.jpg" alt="Roll Image" width={100} height={100} className="object-contain" />
            </div>
            <p className={`text-sm font-medium  ${pathname === '/chowmein' ? 'text-[#742095] font-semibold' : ''}`}>Chowmein</p>
          </div>
        </button>
        </Link>


        <Link href={"/noodles"}><button >
          <div className="flex flex-col items-center space-y-0">
            <div className={`w-14 h-14 bg-gray-200 flex justify-center items-center rounded-full overflow-hidden ${pathname === '/noodles' ? 'border-2 border-[#742095] ' : ''}`}>
              <Image src="/foodimg/noodles.jpg" alt="Roll Image" width={100} height={100} className="object-contain" />
            </div>
            <p className={`text-sm font-medium  ${pathname === '/noodles' ? 'text-[#742095] font-semibold' : ''}`}>Noodles</p>
          </div>
        </button>
        </Link>


        <Link href={"/fries"}><button >
          <div className="flex flex-col items-center space-y-0">
            <div className={`w-14 h-14 bg-gray-200 flex justify-center items-center rounded-full overflow-hidden ${pathname === '/fries' ? 'border-2 border-[#742095] ' : ''}`}>
              <Image src="/foodimg/friedChicken.jpg" alt="Roll Image" width={100} height={100} className="object-contain" />
            </div>
            <p className={`text-sm font-medium  ${pathname === '/fries' ? 'text-[#742095] font-semibold' : ''}`}>Fries</p>
          </div>
        </button>
        </Link>


        <Link href={"/pizza"}><button >
          <div className="flex flex-col items-center space-y-0">
            <div className={`w-14 h-14 bg-gray-200 flex justify-center items-center rounded-full overflow-hidden ${pathname === '/pizza' ? 'border-2 border-[#742095] ' : ''}`}>
              <Image src="/foodimg/pizza.jpeg" alt="Roll Image" width={100} height={100} className="object-contain" />
            </div>
            <p className={`text-sm font-medium  ${pathname === '/pizza' ? 'text-[#742095] font-semibold' : ''}`}>Pizza</p>
          </div>
        </button>
        </Link>

        <Link href={"/burger"}><button >
          <div className="flex flex-col items-center space-y-0">
            <div className={`w-14 h-14 bg-gray-200 flex justify-center items-center rounded-full overflow-hidden ${pathname === '/burger' ? 'border-2 border-[#742095] ' : ''}`}>
              <Image src="/foodimg/burger.jpeg" alt="Roll Image" width={100} height={100} className="object-contain" />
            </div>
            <p className={`text-sm font-medium  ${pathname === '/burger' ? 'text-[#742095] font-semibold' : ''}`}>Burger</p>
          </div>
        </button>
        </Link>

        <Link href={"/shawarma"}><button >
          <div className="flex flex-col items-center space-y-0">
            <div className={`w-14 h-14 bg-gray-200 flex justify-center items-center rounded-full overflow-hidden ${pathname === '/shawarma' ? 'border-2 border-[#742095] ' : ''}`}>
              <Image src="/foodimg/shawarmaRoll.jpg" alt="Roll Image" width={100} height={100} className="object-contain" />
            </div>
            <p className={`text-sm font-medium  ${pathname === '/shawarma' ? 'text-[#742095] font-semibold' : ''}`}>Shawarma</p>
          </div>
        </button>
        </Link>

        <Link href={"/roll"}><button>
          <div className="flex flex-col items-center space-y-0">
            <div className={`w-14 h-14 bg-gray-200 flex justify-center items-center rounded-full overflow-hidden ${pathname === '/roll' ? 'border-2 border-[#742095] ' : ''}`}>
              <Image src="/foodimg/roll.jpg" alt="Roll Image" width={100} height={100} className="object-contain" />
            </div>
            <p className={`text-sm font-medium  ${pathname === '/roll' ? 'text-[#742095] font-semibold' : ''}`}>Roll</p>
          </div>
        </button></Link>


        <Link href={"/nihari"}><button>
          <div className="flex flex-col items-center space-y-0">
            <div className={`w-14 h-14 bg-gray-200 flex justify-center items-center rounded-full overflow-hidden ${pathname === '/nihari' ? 'border-2 border-[#742095] ' : ''}`}>
              <Image src="/foodimg/nihari.avif" alt="Roll Image" width={100} height={100} className="object-contain" />
            </div>
            <p className={`text-sm font-medium  ${pathname === '/nihari' ? 'text-[#742095] font-semibold' : ''}`}>Nihari</p>
          </div>
        </button></Link>

        <Link href={"/biryani"}><button>
          <div className="flex flex-col items-center space-y-0">
            <div className={`w-14 h-14 bg-gray-200 flex justify-center items-center rounded-full overflow-hidden ${pathname === '/biryani' ? 'border-2 border-[#742095] ' : ''}`}>
              <Image src="/foodimg/biryani.avif" alt="Roll Image" width={100} height={100} className="object-contain" />
            </div>
            <p className={`text-sm font-medium  ${pathname === '/biryani' ? 'text-[#742095] font-semibold' : ''}`}>Biryani</p>
          </div>
        </button></Link>







        



        <Link href={"/korma"}><button >
          <div className="flex flex-col items-center space-y-0">
            <div className={`w-14 h-14 bg-gray-200 flex justify-center items-center rounded-full overflow-hidden ${pathname === '/korma' ? 'border-2 border-[#742095] ' : ''}`}>
              <Image src="/foodimg/korma.jpeg" alt="Roll Image" width={100} height={100} className="object-contain" />
            </div>
            <p className={`text-sm font-medium  ${pathname === '/korma' ? 'text-[#742095] font-semibold' : ''}`}>Korma</p>
          </div>
        </button>
        </Link>



        <Link href={"/tikka"}><button >
          <div className="flex flex-col items-center space-y-0">
            <div className={`w-14 h-14 bg-gray-200 flex justify-center items-center rounded-full overflow-hidden ${pathname === '/tikka' ? 'border-2 border-[#742095] ' : ''}`}>
              <Image src="/foodimg/tikka.avif" alt="Roll Image" width={100} height={100} className="object-contain" />
            </div>
            <p className={`text-sm font-medium  ${pathname === '/tikka' ? 'text-[#742095] font-semibold' : ''}`}>Tikka</p>
          </div>
        </button>
        </Link>





        <Link href={"/fry"}><button >
          <div className="flex flex-col items-center space-y-0">
            <div className={`w-14 h-14 bg-gray-200 flex justify-center items-center rounded-full overflow-hidden ${pathname === '/fry' ? 'border-2 border-[#742095] ' : ''}`}>
              <Image src="/foodimg/frenchFry.webp" alt="Roll Image" width={100} height={100} className="object-contain" />
            </div>
            <p className={`text-sm font-medium  ${pathname === '/fry' ? 'text-[#742095] font-semibold' : ''}`}>Fry</p>
          </div>
        </button>
        </Link>




        <Link href={"/roti"}><button >
          <div className="flex flex-col items-center space-y-0">
            <div className={`w-14 h-14 bg-gray-200 flex justify-center items-center rounded-full overflow-hidden ${pathname === '/roti' ? 'border-2 border-[#742095] ' : ''}`}>
              <Image src="/foodimg/roti.avif" alt="Roll Image" width={100} height={100} className="object-contain" />
            </div>
            <p className={`text-sm font-medium  ${pathname === '/roti' ? 'text-[#742095] font-semibold' : ''}`}>Roti</p>
          </div>
        </button>
        </Link>




      </div>
    </div>
  )
}

export default NavbarBottom
