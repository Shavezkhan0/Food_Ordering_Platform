import nodemailer from "nodemailer";

export default async function handler(req, res) {
  if (req.method !== "POST") {
    return res.status(400).json({ error: "This method is not permitted" });
  }

  // shop user details
  const items = req.body.products;

  let shopeDetails = [];
  for (let i = 0; i < items.length; i++) {
    const item = items[i];
    const existingShopDetails = shopeDetails.find(
      (shop) => shop.shopemail === item.shopemail
    );
    if (existingShopDetails) {
      existingShopDetails.products.push({
        _id: item.id,
        name: item.name,
        description: item.description,
        quantity: item.quantity,
        price: item.price,
        foodCategory: item.foodCategory,
      });
    } else {
      shopeDetails.push({
        shopemail: item.shopemail,
        products: [
          {
            _id: item.id,
            name: item.name,
            description: item.description,
            quantity: item.quantity,
            price: item.price,
            foodCategory: item.foodCategory,
          },
        ],
      });
    }
  }

  const transporter = nodemailer.createTransport({
    service: "gmail",
    secure: true,
    host: "smtp.gmail.com",
    port: 465,
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });

  // Function to generate the order details text
  function generateOrderDetailsText(products, amount, forShop = false) {
    let orderDetails = forShop
      ? "Please Pack orders delivery boy will reach you at any moment\nOrders Details:\n"
      : "Order Placed Successfully. Your order will reach you as soon as possible.\nThank You for Ordering. Stay connected with Us\nOrders Details:\n";

    products.forEach((product) => {
      orderDetails += `
Name: ${product.name}
Description: ${product.description}
Quantity: ${product.quantity}
Price: ${product.price * product.quantity}
FoodCategory: ${product.foodCategory}
-------------------------`;
    });

    if (!forShop) {
      orderDetails += `
Total Price: ${amount}`;
    }

    return orderDetails;
  }

  const sendMail = async (mailOptions) => {
    try {
      await transporter.sendMail(mailOptions);
    } catch (error) {
      console.error("Error sending email:", error);
      throw new Error("Error sending email: " + error.message);
    }
  };

  try {
    // Send email to user
    const userMailOptions = {
      from: {
        name: "okhaladastarkhan",
        address: process.env.EMAIL_USER,
      },
      // to: [req.body.email,"shavez.khanccc@gmail.com","zahiriqbal198@gmail.com"],
      to: [],
      subject: "Order", // Subject line
      text: generateOrderDetailsText(req.body.products, req.body.amount),
    };
    await sendMail(userMailOptions);

    // Send emails to shops
    const shopMailPromises = shopeDetails.map((shop) => {
      const shopMailOptions = {
        from: {
          name: "okhaladastarkhan",
          address: process.env.EMAIL_USER,
        },
        to: [],
        subject: "Order", // Subject line
        text: generateOrderDetailsText(shop.products, req.body.amount, true),
      };
      return sendMail(shopMailOptions);
    });

    await Promise.all(shopMailPromises);

    // Insert in the ordered table after checking the transaction status
    // Initialize shipping
    // Redirect to the order confirmation page

    res
      .status(200)
      .json({ message: "Emails sent successfully", success: true });
  } catch (error) {
    res
      .status(500)
      .json({ error: "Error sending emails", details: error.message });
  }
}

// import nodemailer from "nodemailer";

// export default async function handler(req, res) {
//   //sanr email to shop and user

//   if (req.method !== "POST") {
//     res.status(400).json({ error: "This method is not premitted" });
//   }

//   // shop user details
//   const items = req.body.products;

//   let shopeDetails = [];
//   for (let i = 0; i < items.length; i++) {
//     const item = items[i];
//     const existingShopDetails = shopeDetails.find(
//       (shop) => shop.shopemail === item.shopemail
//     );
//     if (existingShopDetails) {
//       existingShopDetails.products.push({
//         _id: item.id,
//         name: item.name,
//         description: item.description,
//         quantity: item.quantity,
//         price: item.price,
//         foodCategory: item.foodCategory,
//       });
//     } else {
//       shopeDetails.push({
//         shopemail: item.shopemail,
//         products: [
//           {
//             _id: item.id,
//             name: item.name,
//             description: item.description,
//             quantity: item.quantity,
//             price: item.price,
//             foodCategory: item.foodCategory,
//           },
//         ],
//       });
//     }
//   }

//   // sending email to shop and user
//   const transporter = nodemailer.createTransport({
//     service: "gmail",
//     secure: true,
//     host: "smtp.gmail.com",
//     port: 465,
//     auth: {
//       user: process.env.EMAIL_USER,
//       pass: process.env.EMAIL_PASS,
//     },
//   });

//   console.log(req.body);
//   console.log(req.body.email);
//   console.log(req.body.products);

//   // send email to user
//   const mailOptions = {
//     from: {
//       name: "okhaladastarkhan",
//       address: process.env.EMAIL_USER,
//     },
//     to: [`${req.body.email}`],
//     subject: "Order", // Subject line
//     text: generateOrderDetailsText(req.body.products),
//   };

//   // Function to generate the order details text
//   function generateOrderDetailsText(products) {
//     let orderDetails =
//       "Order Placed Successfully . Your order will react you as possible as soon\nThank You for Order. Stay connect Us\nOrders Details:\n";

//     products.forEach((product) => {
//       orderDetails += `
// Name: ${product.name}
// Description: ${product.description}
// Quantity: ${product.quantity}
// Price: ${product.price}
// FoodCategory: ${product.foodCategory}
// -------------------------`;
//     });

//     return orderDetails;
//   }
//   await sendMail(transporter, mailOptions);

//   //send email to shop
//   shopeDetails.forEach(async (item) => {
//     const mailOptions = {
//       from: {
//         name: "okhaladastarkhan",
//         address: process.env.EMAIL_USER,
//       },
//       to: [`${item.shopemail}`],
//       subject: "Order", // Subject line
//       text: generateOrderDetailsText(item.products),
//     };

//     // Function to generate the order details text
//     function generateOrderDetailsText(products) {
//       let orderDetails =
//         "Please Pack orders delivery boy will reach you at any moment\nOrders Details:\n";

//       products.forEach((product) => {
//         orderDetails += `
// Name: ${product.name}
// Description: ${product.description}
// Quantity: ${product.quantity}
// Price: ${product.price}
// FoodCategory: ${product.foodCategory}
// -------------------------`;
//       });

//       return orderDetails;
//     }

//     const sendMail = async (transporter, mailOptions) => {
//       try {
//         await transporter.sendMail(mailOptions);

//         res.status(200).json({
//           message: "Email  send to Shop successfully",
//           success: true,
//         });
//       } catch (error) {
//         console.error("Error sending email:", error);
//         res
//           .status(500)
//           .json({ error: "Error sending email", details: error.message });
//       }
//     };
//     await sendMail(transporter, mailOptions);
//   });

//   //insert in the ordered table after chscking the transection status
//   //initale shipping
//   //redirect to the orderd confermation page

//   res.status(200).json({ body: req.body });
// }
