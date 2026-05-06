import conn_to_mon from "@/features/mongoose";
import Order from "@/models/Order";

export default async function deliveyOrderPending(req, res) {
  try {
    await conn_to_mon();

   
    const cancellOrder = await Order.findByIdAndUpdate(
      req.body._id,
      {
        $set: {
          "deliverystatus.pack": "pending",
          "deliverystatus.shipped": "pending",
          "deliverystatus.deliver": "pending",
        },
      },
      
    );

    

    res.status(200).json({ success: true, message: "Order Pending" });
  } catch (error) {
    res
      .status(500)
      .json({ success: false, message: "Order not Cancelled", error });
  }
}
