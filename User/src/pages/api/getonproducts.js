import conn_to_mon from "@/features/mongoose";
import Products from "@/models/Products";

export default async function getproducts(req, res) {
  if (req.method === "GET") {
    await conn_to_mon();

    const { limit = 20, skip = 0 } = req.query; // Default to 20 items, skip none

    try {
      const products = await Products.find({ shop: "on", active: "true" })
        .limit(parseInt(limit))
        .skip(parseInt(skip))
        .exec(); // Ensure execution of the query

      res.status(200).json({ products });
    } catch (error) {
      console.error("Error fetching products:", error); // Add error logging
      res.status(500).json({ error: "Failed to fetch products" });
    }
  } else {
    res.status(400).json({ error: "This method is not permitted" });
  }
}
