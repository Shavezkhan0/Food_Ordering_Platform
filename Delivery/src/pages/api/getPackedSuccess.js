import conn_to_mon from "@/features/mongoose";
import Order from "@/models/Order";

export default async function packedOrderSuccess(req, res) {
  try {
    await conn_to_mon();

   console.log("packedOrder")
    const packedOrder = await Order.findByIdAndUpdate(
      req.body._id,
      {
        $set: {
          "deliverystatus.pack": "success",
        },
      }
      
    );

    

    

    res.status(200).json({ success: true, message: "Packed Success" });
  } catch (error) {
    res
      .status(500)
      .json({ success: false, message: "Order not Cancelled", error });
  }
}
