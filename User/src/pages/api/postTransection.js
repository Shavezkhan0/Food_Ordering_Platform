import nodemailer from "nodemailer";

export default async function handler(req, res) {
  if (req.method !== "POST") {
    return res.status(405).json({
      success: false,
      message: "Method Not Allowed",
    });
  }

  try {
    const items = req.body.products;

    // ================= GROUP PRODUCTS BY SHOP =================
    let shopeDetails = [];

    items.forEach((item) => {
      const existingShop = shopeDetails.find(
        (shop) => shop.shopemail === item.shopemail
      );

      const productData = {
        _id: item.id,
        name: item.name,
        description: item.description,
        quantity: item.quantity,
        price: item.price,
        foodCategory: item.foodCategory,
      };

      if (existingShop) {
        existingShop.products.push(productData);
      } else {
        shopeDetails.push({
          shopemail: item.shopemail,
          products: [productData],
        });
      }
    });

    // ================= MAIL TRANSPORTER =================
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

    // ================= GENERATE PRODUCTS HTML =================
    const generateProductsHTML = (products) => {
      return products
        .map(
          (product) => `
            <tr>
              <td style="padding:10px;border:1px solid #ddd;">
                ${product.name}
              </td>
              <td style="padding:10px;border:1px solid #ddd;">
                ${product.quantity}
              </td>
              <td style="padding:10px;border:1px solid #ddd;">
                ₹${product.price}
              </td>
              <td style="padding:10px;border:1px solid #ddd;">
                ₹${product.price * product.quantity}
              </td>
            </tr>
          `
        )
        .join("");
    };

    // ================= USER EMAIL TEMPLATE =================
    const userMailOptions = {
      from: {
        name: "Okhla Dastarkhan",
        address: process.env.EMAIL_USER,
      },

      to: req.body.email,

      subject: "Your Order Has Been Placed Successfully 🍔",

      text: `Your order has been placed successfully.`,

      html: `
      <div style="font-family: Arial, sans-serif; padding:20px;">
        
        <h2 style="color:#ff6600;">
          Order Confirmed ✅
        </h2>

        <p>Hello ${req.body.name || "Customer"},</p>

        <p>
          Thank you for ordering from 
          <strong>Okhla Dastarkhan</strong>.
        </p>

        <p>
          Your order is being prepared and will arrive soon.
        </p>

        <table 
          style="
            width:100%;
            border-collapse:collapse;
            margin-top:20px;
          "
        >
          <thead>
            <tr style="background:#f5f5f5;">
              <th style="padding:10px;border:1px solid #ddd;">
                Product
              </th>

              <th style="padding:10px;border:1px solid #ddd;">
                Qty
              </th>

              <th style="padding:10px;border:1px solid #ddd;">
                Price
              </th>

              <th style="padding:10px;border:1px solid #ddd;">
                Total
              </th>
            </tr>
          </thead>

          <tbody>
            ${generateProductsHTML(req.body.products)}
          </tbody>
        </table>

        <h3 style="margin-top:20px;">
          Grand Total: ₹${req.body.amount}
        </h3>

        <p>
          Thank you for choosing us ❤️
        </p>

        <br/>

        <p>
          Team Okhla Dastarkhan
        </p>

      </div>
      `,
    };

    // ================= SEND USER EMAIL =================
    await transporter.sendMail(userMailOptions);

    // ================= SEND SHOP EMAILS =================
    const shopPromises = shopeDetails.map(async (shop) => {
      const shopMailOptions = {
        from: {
          name: "Okhla Dastarkhan",
          address: process.env.EMAIL_USER,
        },

        to: shop.shopemail,

        subject: "New Order Received 🍽️",

        text: `You received a new order.`,

        html: `
        <div style="font-family: Arial, sans-serif; padding:20px;">

          <h2 style="color:#28a745;">
            New Order Received
          </h2>

          <p>
            Please prepare the following order.
          </p>

          <table 
            style="
              width:100%;
              border-collapse:collapse;
              margin-top:20px;
            "
          >
            <thead>
              <tr style="background:#f5f5f5;">
                <th style="padding:10px;border:1px solid #ddd;">
                  Product
                </th>

                <th style="padding:10px;border:1px solid #ddd;">
                  Qty
                </th>

                <th style="padding:10px;border:1px solid #ddd;">
                  Price
                </th>

                <th style="padding:10px;border:1px solid #ddd;">
                  Total
                </th>
              </tr>
            </thead>

            <tbody>
              ${generateProductsHTML(shop.products)}
            </tbody>
          </table>

          <br/>

          <p>
            Delivery partner may arrive soon.
          </p>

          <p>
            Team Okhla Dastarkhan
          </p>

        </div>
        `,
      };

      return transporter.sendMail(shopMailOptions);
    });

    await Promise.all(shopPromises);

    return res.status(200).json({
      success: true,
      message: "Emails sent successfully",
    });
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      success: false,
      message: "Something went wrong",
      error: error.message,
    });
  }
}