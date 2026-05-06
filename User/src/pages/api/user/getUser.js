import conn_to_mon from "@/features/mongoose";
import User from "@/models/User";

export default async function getUser(req, res) {
  try {
    await conn_to_mon();

    let user = await User.find({ email: req.body.email });

    res.status(200).json({
      success: true,
      message: "User find Successfully",
      user: { user },
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch hoodies" });
  }
}
