import express from "express";
import { getAllOrders, getByOrderId, placeOrder, userOrders } from "../controller/orderController.js";

const orderRoutes=express.Router()

orderRoutes.get("/", (req, res) => {
  res.send("Orders Router");
});

orderRoutes.get("/allOrders",getAllOrders)
orderRoutes.put("/placeOrder",placeOrder)
orderRoutes.get("/userOrders",userOrders)
orderRoutes.get("/byOrderId",getByOrderId)

export default orderRoutes;
