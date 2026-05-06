import express from "express";
import connect_mongoDB from "../features/mongoDB.js";
import ShopUser from "../models/ShopUser.js";

const getAllShops = async (req, res) => {
  if (req.method !== "GET") {
    res.status(405).json({
      error: "This methos is not permitted",
    });
  }

  connect_mongoDB();

  const allShops = await ShopUser.find({ active: "true" });
  if (!getAllShops) {
    res.status(404).json({
      message: "Shop not Found",
      success: false,
    });
  }

  res.status(200).json({
    success: true,
    message: "All shop get successfully",
    shops: allShops,
  });
};

const getOnShops = async (req, res) => {
  if (req.method !== "GET") {
    res.status(405).json({
      error: "This methos is not permitted",
    });
  }

  connect_mongoDB();

  const allShops = await ShopUser.find({ shop: "on", active: "true" });
  if (!getAllShops) {
    res.status(404).json({
      message: "Shop not Found",
      success: false,
    });
  }

  res.status(200).json({
    success: true,
    message: "All shop get successfully",
    shops: allShops,
  });
};

const getShopByEmail = async (req, res) => {
  if (req.method !== "GET") {
    res.status(405).json({
      error: "This methos is not permitted",
    });
  }
  const { limit, skip = 0, email } = req.query;
  connect_mongoDB();

  const shop = await ShopUser.find({ email: email });

  if (!shop) {
    res.status(404).json({
      message: "Shop not Found",
      success: false,
    });
  }

  res.status(200).json({
    success: true,
    message: "Shop get successfully",
    shop: shop,
  });
};
export { getAllShops, getOnShops, getShopByEmail };
