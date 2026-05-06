import connect_mongoDB from "../features/mongoDB.js";
import User from "../models/User.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import nodemailer from "nodemailer";

const allUser = async (req, res) => {

  if (req.method !== "GET") {
    res.status(405).json({
      error: "This method is not permitted",
      success: false,
    });
  }
 
  await connect_mongoDB();

  const users = await User.find();
  if (!users) {
    res.status(404).json({
      message: "User not found",
      success: false,
    });
  }

  res.status(200).json({
    success: true,
    message: "Users found Successfully",
    Users: users,
  });
};

const userLogin = async (req, res) => {
  const { email, password } = req.body;

  if (req.method !== "POST") {
    res.status(405).json({
      error: "This method is not permitted",
      success: false,
    });
  }

  if (!email && !password) {
    res.status(400).json({
      error: "Please enter Email and Password",
      success: false,
    });
  }

  await connect_mongoDB();

  
  const user = await User.findOne({ email: email });
  if (!user) {
    res.status(404).json({
      message: "User not found",
      success: false,
    });
  }


  const passwordMatch = await bcrypt.compare(password, user.password);

  if (!passwordMatch) {
    res.status(401).json({
      message: "Password not Match",
      success: false,
    });
  }

  const payload = {
    id: user._id,
    username: user.username,
    email: user.email,
    phoneNumber: user.phoneNumber,
  };

  const token = jwt.sign(payload, process.env.JWT_Secret, { expiresIn: "10m" });

  // console.log(token);
  // console.log(user);

  res.status(200).json({
    success: true,
    message: "User found Successfully",
    token: token,
    User: user,
  });
};

const userRegister = async (req, res) => {
  const { username, email, phoneNumber, password } = req.body;

  if (req.method !== "POST") {
    res.status(405).json({
      error: "This method is not permitted",
      success: false,
    });
  }

  if (!username && !email && !phoneNumber && !password) {
    res.status(400).json({
      error: "Please fill all  Fields",
      success: false,
    });
  }

  await connect_mongoDB();

  const user = await User.findOne({ email: email });
  if (user) {
    res.status(409).json({
      message: "User Alreday Exist",
      success: false,
    });
  }

  const hashPassword = await bcrypt.hash(password, 5);

  const newUser = new User({
    username,
    email,
    phoneNumber,
    password: hashPassword,
  });

  await newUser.save();

  const payload = {
    id: newUser._id,
    username: newUser.username,
    email: newUser.email,
    phoneNumber: newUser.phoneNumber,
  };

  const token = jwt.sign(payload, process.env.JWT_Secret, { expiresIn: "10m" });

  console.log(payload);

  res.status(200).json({
    success: true,
    message: "User Register Successfully",
    token: token,
    User: newUser,
  });
};

const userExist = async (req, res) => {
  const { email } = req.body;

  if (req.method !== "POST") {
    res.status(405).json({
      error: "This method is not permitted",
      success: false,
    });
  }

  if (!email) {
    res.status(400).json({
      error: "Please Enter Email",
      success: false,
    });
  }

  await connect_mongoDB();

  const user = await User.findOne({ email: email });
  if (user) {
    res.status(409).json({
      message: "User Alreday Exist",
      success: false,
    });
  }

  if (!user) {
    res.status(200).json({
      success: true,
      message: "User Not Exist",
    });
  }
};

const userOtpVerify = async (req, res) => {
  const { email, otp } = req.body;

  // Check if the method is POST
  if (req.method !== "POST") {
    return res.status(405).json({
      error: "This method is not permitted",
      success: false,
    });
  }

  // Check if email and otp are provided
  if (!email || !otp) {
    return res.status(400).json({
      error: "Please enter Email and OTP",
      success: false,
    });
  }

  // Create a transporter for nodemailer
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

  // Define mail options
  const mailOptions = {
    from: {
      name: "Okados",
      address: process.env.EMAIL_USER,
    },
    to: email, // Use the email variable
    subject: "OTP Verification for your Okados account", // Subject line
    text: ` Please DO NOT share this code with anyone.\nYour OTP verification code is ${otp}.`, // Plain text body
  };

  // Function to send the email
  const sendEmail = async (transporter, mailOptions) => {
    try {
      await transporter.sendMail(mailOptions);
      res.status(200).json({
        success: true,
        message: "OTP sent successfully",
        otp: otp,
      });
    } catch (error) {
      console.log("Error sending email:", error);

      if (error.response) {
        // Email failed to send; may be invalid or due to other issues
        res.status(400).json({
          success: false,
          message:
            "Failed to send OTP. Please check the email address or try again later.",
        });
      } else {
        res.status(500).json({
          success: false,
          message: "An unexpected error occurred. Please try again later.",
        });
      }
    }
  };

  // Call the sendEmail function
  await sendEmail(transporter, mailOptions);
};

const userSetPassword = async (req, res) => {
  const { email, password } = req.body;
  console.log(req.body)

  if (req.method !== "POST") {
    res.status(405).json({
      error: "This method is not permitted",
      success: false,
    });
  }

  if (!email && !password) {
    res.status(400).json({
      error: "Please Enter Email and Password",
      success: false,
    });
  }

  await connect_mongoDB();

  const hashPassword = await bcrypt.hash(password, 5);

  const user = await User.findOneAndUpdate(
    { email: email },
    { $set: { password: hashPassword } },
    { new: true }
  );
  if (!user) {
    res.status(404).json({
      success: true,
      message: "Password Update Successfully",
    });
  }

  if (user) {
    res.status(200).json({
      success: true,
      message: "Password Update Successfully",
    });
  }
};

const userUpdateNamePhone = async (req, res) => {
  const { email, username, phoneNumber } = req.body;

  if (req.method !== "POST") {
    res.status(405).json({
      error: "This method is not permitted",
      success: false,
    });
  }

  await connect_mongoDB();

  const user = await User.findOne({ email: email });
  if (!user) {
    res.status(404).json({
      message: "User not found",
      success: false,
    });
  }

  const userUpdate = await User.findOneAndUpdate(
    { email: email },
    { $set: { username, phoneNumber } },
    { new: true }
  );

  // console.log(user);

  res.status(200).json({
    success: true,
    message: "User Update Successfully",
    User: userUpdate,
  });
};

const userUpdateAddress = async (req, res) => {
  const { email, address, landmark, pincode, city, state } = req.body;

  if (req.method !== "POST") {
    res.status(405).json({
      error: "This method is not permitted",
      success: false,
    });
  }

  await connect_mongoDB();

  const user = await User.findOne({ email: email });
  if (!user) {
    res.status(404).json({
      message: "User not found",
      success: false,
    });
  }

  const userUpdate = await User.findOneAndUpdate(
    { email: email },
    { $set: { address, landmark, pincode, city, state } },
    { new: true }
  );

  // console.log(user);

  res.status(200).json({
    success: true,
    message: "Address Update Successfully",
    User: userUpdate,
  });
};

const userUpdatePassword = async (req, res) => {
  const { email, password, newPassword } = req.body;

  if (req.method !== "POST") {
    res.status(405).json({
      error: "This method is not permitted",
      success: false,
    });
  }

  if (!email && !password && !newPassword) {
    res.status(400).json({
      error: "Please Enter All Details",
      success: false,
    });
  }

  await connect_mongoDB();

  const user = await User.findOne({ email: email });
  if (!user) {
    res.status(404).json({
      message: "User not found",
      success: false,
    });
  }

  const passwordMatch = await bcrypt.compare(password, user.password);

  if (!passwordMatch) {
    res.status(401).json({
      message: "Password not Match",
      success: false,
    });
  }

  const hashPassword = await bcrypt.hash(newPassword, 5);

  const newUser = await User.findOneAndUpdate(
    { email: email },
    { $set: { password: hashPassword } },
    { new: true }
  );

  if (!newUser) {
    res.status(404).json({
      success: true,
      message: "Password Update Successfully",
    });
  }

  if (newUser) {
    res.status(200).json({
      success: true,
      message: "Password Update Successfully",
    });
  }
};

export {
  allUser,
  userLogin,
  userRegister,
  userOtpVerify,
  userExist,
  userSetPassword,
  userUpdateNamePhone,
  userUpdateAddress,
  userUpdatePassword,
};
