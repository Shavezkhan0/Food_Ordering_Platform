import Products from "@/models/Products";
import mongoose from "mongoose";

export default async function getMomo(req, res) {
  if (!mongoose.connections[0].readyState) {
    await mongoose.connect(process.env.MONGOOSE_CONN_STRING, {
      dbName: "okhaladastarkhan",
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
  }

  try {
    let biryanies = await Products.find({
      shop: "on",
      active: "true",
      category: { $regex: "momo", $options: "i" },
    });
    res.status(200).json(biryanies);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch products" });
  }
}
