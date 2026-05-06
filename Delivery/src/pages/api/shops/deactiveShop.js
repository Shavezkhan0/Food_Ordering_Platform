import conn_to_mon from "@/features/mongoose";
import ShopUser from "@/models/ShopUser";

export default async function activeShop(req, res) {
  try {
    await conn_to_mon();
    const { email } = req.body;
    
    const decodedEmail = decodeURIComponent(email);

    console.log(req.body.email)
    
    const userExist = await ShopUser.findOneAndUpdate(
        { email: decodedEmail },
        { $set: { active: "false" } },
        { new: true }
    );
    console.log(userExist)

    res.status(200).json({ success: true, message: "Shop Deactivate" });
  } catch (error) {
    res
      .status(500)
      .json({ success: false, message: "Error signing up user", error });
  }
}
