import conn_to_mon from "@/features/mongoose";
import Order from "@/models/Order";
import Products from "@/models/Products";
import User from "@/models/User";
import axios from "axios";
import { useSession } from "next-auth/react";

export default async function payment(req, res) {
  if (req.method === "POST") {
    await conn_to_mon();

    

    //check cart tempered-pending
    const items = req.body.cart;
    let TotalPriceItem = 0;
    let shopeDetails = [];

    for (let i = 0; i < items.length; i++) {
      let product = await Products.findById(items[i].id);
      if (product.shop === "off") {
        res.status(400).json({
          success: false,
          message: `Product is not available now`,
        });
        return;
      }
      const existingShop = shopeDetails.find(
        (shop) => shop.shopemail === product.email
      );
      if (existingShop) {
        existingShop.products.push(product._id);
      } else {
        shopeDetails.push({
          shopemail: product.email,
          products: [product._id],
        });
      }
      TotalPriceItem += product.price * req.body.cart[i].quantity;
    }

    if (TotalPriceItem !== req.body.totalPrice - req.body.deliveryamount) {
      res.status(400).json({ error: "Cart is Tempered" });
    }

    // check cart item is out of stock or not --pending

    const order = new Order({
      username: req.body.username,
      email: req.body.email,
      phoneNumber: req.body.phoneNumber,
      landmark: req.body.landmark,
      orderId: req.body.oid,
      address: req.body.address,
      geolocation: req.body.geolocation,
      shopDetails: shopeDetails,
      amount: req.body.totalPrice,
      deliveryamount: req.body.deliveryamount,
      products: req.body.cart,
      paymentInfo: { method: req.body.paymentMethod },
    });

    const savedOrder = await order.save();



    axios
      .post(`${process.env.NEXT_PUBLIC_HOST}/api/postTransection`, savedOrder)
      .then((response) => {
        console.log("Post Transaction successful:");
      })
      .catch((error) => {
        console.error("Error posting transaction:", error);
      });

      const userExist = await User.findOneAndUpdate(
        { email: req.body.email },
        {
          $set: {
            address: req.body.address,
            landmark: req.body.landmark,
          },
        },
        { new: true }
      );  

    res.status(200).json({
      success: true,
      orderId: savedOrder._id,
      message: "Your order is placed",
    });
  } else {
    res.status(400).json({ error: "This method is not premitted" });
  }
}

// var paytmParams = {};

//     paytmParams.body = {
//       requestType: "Payment",
//       mid: process.env.NEXT_PUBLIC_PAYTM_MID,
//       websiteName: "codewear.com",
//       orderId: req.body.oid,
//       callbackUrl: `${process.env.NEXT_PUBLIC_HOST}/api/postTransection`,
//       txnAmount: {
//         value: req.body.totalPrice,
//         currency: "INR",
//       },
//       userInfo: {
//         custId: req.body.email,
//       },
//     };

//     try {
//       const checksum = await PaytmChecksum.generateSignature(
//         JSON.stringify(paytmParams.body),
//         process.env.NEXT_PUBLIC_PAYTM_KEY
//       );

//       paytmParams.head = {
//         signature: checksum,
//       };

//       var post_data = JSON.stringify(paytmParams);

//       const requestAsync = async () => {
//         return new Promise((resolve, reject) => {
//           var options = {
//             /* for Staging */
//             hostname: "securegw-stage.paytm.in" /* for Production */, // hostname: 'securegw.paytm.in',

//             port: 443,
//             path: `/theia/api/v1/initiateTransaction?mid=${process.env.NEXT_PUBLIC_PAYTM_MID}&orderId=${req.body.oid}`,
//             method: "POST",
//             headers: {
//               "Content-Type": "application/json",
//               "Content-Length": post_data.length,
//             },
//           };

//           var response = "";
//           var post_req = https.request(options, function (post_res) {
//             post_res.on("data", function (chunk) {
//               response += chunk;
//             });

//             post_res.on("end", function () {
//               resolve(JSON.parse(response).body);
//             });
//           });

//           post_req.write(post_data);
//           post_req.end();
//         });
//       };

//       myr = await requestAsync();
//       res.status(200).json(myr);
//     } catch (error) {
//       console.error("Checksum generation error:", error);
//       res.status(500).json({ error: "Checksum generation failed" });
//     }
//   }

// if (serviceable) {
//   const a = await fetch("/api/preTransection", {
//     method: "POST",
//     headers: {
//       "Content-Type": "aplication/json"
//     },
//     body: JSON.stringify(data)
//   })

//   const tranToken = await a.json()
//   console.log(tranToken)

//   var config = {
//     "root": "",
//     "flow": "DEFAULT",
//     "data": {
//       "orderId": oid, /* update order id */
//       "token": tranToken, /* update token value */
//       "tokenType": "TXN_TOKEN",
//       "amount": totalPrice
//     },
//     "handler": {
//       "notifyMerchant": function (eventName, data) {
//         console.log("notifyMerchant handler function called");
//         console.log("eventName => ", eventName);
//         console.log("data => ", data);
//       }
//     }
//   };
//   if (window.Paytm && window.Paytm.CheckoutJS) {
//     window.Paytm.CheckoutJS.onLoad(function excecuteAfterCompleteLoad() {
//       window.Paytm.CheckoutJS.init(config).then(function onSuccess() {
//         window.Paytm.CheckoutJS.invoke();
//       }).catch(function onError(error) {
//         console.log("error => ", error);
//       });
//     });
//   }
// }
