import conn_to_mon from "@/features/mongoose";
import User from "@/models/User";
import bcrypt, { hash } from "bcryptjs";

export default async function signUp(req, res) {
  try {
    await conn_to_mon();

    const { username, email, phoneNumber, password } = req.body;

    const userExist = await User.findOne({ email: email });

    if (userExist) {
      res
        .status(500)
        .json({ success: false, message: "User Already Exist", error });
    }

    const hashPassword = await bcrypt.hash(password, 5);
    const newUser = new User({
      username,
      email,
      phoneNumber,
      password: hashPassword,
    });
    await newUser.save();
    res
      .status(200)
      .json({ success: true, message: "User sign up successfully" });
  } catch (error) {
    res
      .status(500)
      .json({ success: false, message: "Error signing up user", error });
  }
}
