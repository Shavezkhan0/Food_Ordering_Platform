import nodemailer from "nodemailer";

export default async function emailOTP(req, res) {
  const RandomOTP = Math.floor(Math.random() * 1000000);

  if (req.method === "POST") {
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
    

    const mailOptions = {
  from: {
    name: "Okhla Dastarkhan",
    address: process.env.EMAIL_USER,
  },
  to: req.body.email,
  subject: "OTP Verification - Okhla Dastarkhan Account",
  text: `
Hello,

Your OTP verification code for your Okhla Dastarkhan account is:

${RandomOTP}

Please do not share this OTP with anyone for security reasons.

This OTP is valid for a limited time only.

Thank you,
Team Okhla Dastarkhan
  `,
  html: `
    <div style="font-family: Arial, sans-serif; padding: 20px; color: #333;">
      <h2 style="color: #ff6b00;">Okhla Dastarkhan</h2>
      
      <p>Hello,</p>
      
      <p>Your OTP verification code is:</p>
      
      <div style="
        font-size: 28px;
        font-weight: bold;
        letter-spacing: 5px;
        background: #f4f4f4;
        padding: 15px;
        text-align: center;
        border-radius: 8px;
        margin: 20px 0;
      ">
        ${RandomOTP}
      </div>

      <p style="color: red;">
        Please do not share this OTP with anyone.
      </p>

      <p>This OTP is valid for a limited time only.</p>

      <br />

      <p>Thank you,</p>
      <p><strong>Team Okhla Dastarkhan</strong></p>
    </div>
  `,
};
    

    const sendMail = async (transporter, mailOptions) => {
      try {
        await transporter.sendMail(mailOptions);

        res.status(200).json({
          message: "OTP send successfully",
          success: true,
          otp: RandomOTP,
        });
      } catch (error) {
        console.error("Error sending email:", error);
        res
          .status(500)
          .json({ error: "Error sending email", details: error.message });
      }
    };

    sendMail(transporter, mailOptions);
  } else {
    res.status(400).json({ error: "This method is not permitted" });
  }
}
