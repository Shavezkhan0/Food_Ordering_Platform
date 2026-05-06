import express from "express";
import connect_mongoDB from "../features/mongoDB.js";
import Products from "../models/Products.js";
import AppOrders from "../models/AppOrders.js";

const getAllOrders = async (req, res) => {
  if (req.method !== "GET") {
    res.status(405).json({
      error: "This methos is not permitted",
      message: "This methos is not permitted",
      success: false,
    });
  }

  connect_mongoDB();

  const orders = await Orders.find({});

  if (!orders) {
    res.status(404).json({
      message: "Shop not Found",
      success: false,
    });
  }

  res.status(200).json({
    success: true,
    message: "All Orders get successfully",
    orders: orders,
  });
};

const getByOrderId = async (req, res) => {
  if (req.method !== "GET") {
    res.status(405).json({
      error: "This methos is not permitted",
      message: "This methos is not permitted",
      success: false,
    });
  }

  connect_mongoDB();

  const order = await AppOrders.findOne({
    orderId: req.query.orderId,
  });

  if (!order) {
    res.status(404).json({
      message: `Order not Found By this Id ${req.query.orderId}`,
      success: false,
    });
  }

  res.status(200).json({
    success: true,
    message: "All Orders get successfully",
    order: order,
  });
};

const placeOrder = async (req, res) => {
  if (req.method !== "PUT") {
    res.status(405).json({
      error: "This methos is not permitted",
    });
  }

  const { orderId, subTotal, deliveryCharge, textCharge } = req.body;

  var SubTotal = 0;
  const sId_Quantity = [];
  req.body["cart"].forEach((item) => {
    sId_Quantity.push({
      sId: item.sId,
      quantity: item.quantity,
    });
  });

  const shopDetails = [];
  for (const item of req.body["cart"]) {
    const shopEmailExist = shopDetails.find(
      (shop) => shop.shopemail === item.email
    );
    if (shopEmailExist) {
      shopEmailExist.products.push(item.sId);
    } else {
      shopDetails.push({
        shopemail: item.email,
        products: [item.sId],
      });
    }
  }

  await connect_mongoDB();
  const getSubtotal = async () => {
    for (const item of sId_Quantity) {
      const product = await Products.findById(item.sId);
      if (product.shop === "off") {
        res.status(403).json({
          success: false,
          message: `${product.title} is not available now`,
        });
        return;
      }
      SubTotal = SubTotal + product.price * item.quantity;
    }
  };
  await getSubtotal();

  if (subTotal !== SubTotal) {
    res.status(422).json({ error: "Cart is Tempered" });
  }

  const newOrder = new AppOrders({
    orderId,
    username: req.body["userInfo"].username,
    email: req.body["userInfo"].email,
    username: req.body["userInfo"].username,
    phoneNumber: req.body["userInfo"].phoneNumber,
    address: req.body["userInfo"].address,
    landmark: req.body["userInfo"].landmark,
    pincode: req.body["userInfo"].pincode,
    totalPrice: subTotal,
    deliveryCharge,
    textCharge,
    geolocation: {
      latitude: req.body["geoLocation"].latitude,
      longitude: req.body["geoLocation"].longitude,
      accuracy: req.body["geoLocation"].accuracy || 0,
    },
    shopDetails,
    products: req.body["cart"],
  });

  console.log(newOrder);

  await newOrder.save();

  res.status(200).json({
    success: true,
    message: "Order Place Successfully",
  });
};

const userOrders = async (req, res) => {
  if (req.method !== "GET") {
    return res.status(405).json({
      success: false,
      error: "This method is not permitted",
      message: "This method is not permitted",
    });
  }

  const { email } = req.query;

  try {
    await connect_mongoDB();
    const orders = await AppOrders.find({
      email: email,
    });

    console.log(orders);

    if (orders.length === 0) {
      return res.status(404).json({
        success: false,
        message: "No order found",
      });
    }

    return res.status(200).json({
      success: true,
      message: "All orders fetched successfully",
      orders: orders,
    });
  } catch (error) {
    // Handle any database or unexpected errors
    console.error("Error fetching orders:", error);
    return res.status(500).json({
      success: false,
      message: "Server error. Please try again later.",
      error: error.message,
    });
  }
};

export { getAllOrders, placeOrder, userOrders, getByOrderId };
