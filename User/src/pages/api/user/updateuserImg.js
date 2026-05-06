import conn_to_mon from "@/features/mongoose";
import User from "@/models/User";

export default async function updateuseraddress(req, res) {
  try {
    await conn_to_mon();
    const { email, image } = req.body;

    const userExist = await User.findOneAndUpdate(
      { email: email },
      {
        $set: {
          image: image, 
        },
      },
      { new: true }
    );

    if (userExist) {
      res.status(200).json({ success: true, message: "Image saved successfully", user: userExist });
    } else {
      res.status(404).json({ success: false, message: "User not found" });
    }
  } catch (error) {
    res.status(500).json({ success: false, message: "Error updating user image", error });
  }
}
