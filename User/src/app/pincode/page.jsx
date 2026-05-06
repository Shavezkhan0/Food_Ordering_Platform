'use client'
import React, { useEffect, useState } from 'react'

const Pincode = () => {
    const [data, setdata] = useState(null)

    useEffect(() => {

        const data = async () => {
            const r = await fetch("/api/pincode", {
                method: "GET",
                headers: {
                    "Content-type": "application/json; charset=UTF-8"
                },
                body: JSON.stringify(data)
            })

            const res = await r.json()
            setdata(res)
        }

        data()

    }, [])


    return (
        <>
            <div>Pincode</div>
            {data &&
                (
                    <div>
                        {
                            data.map((pin, index) => {
                                return (
                                    <h1 key={index}>{pin}</h1>
                                )
                            })
                        }
                    </div>
                )
            }
        </>
    )
}

export default Pincode