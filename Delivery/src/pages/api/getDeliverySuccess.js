import conn_to_mon from "@/features/mongoose";
import Order from "@/models/Order";

export default async function deliveyOrderSuccess(req, res) {
  try {
    await conn_to_mon();

   
    const cancellOrder = await Order.findByIdAndUpdate(
      req.body._id,
      {
        $set: {
          "deliverystatus.pack": "success",
          "deliverystatus.shipped": "success",
          "deliverystatus.deliver": "success",
        },
      },
      
    );

    

    res.status(200).json({ success: true, message: "Delivery Success" });
  } catch (error) {
    res
      .status(500)
      .json({ success: false, message: "Order not Cancelled", error });
  }
}
