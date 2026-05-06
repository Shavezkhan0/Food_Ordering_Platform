import express from "express";
import connect_mongoDB from "../features/mongoDB.js";
import Products from "../models/Products.js";

const allProducts = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({ active: "true" })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const momo = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({ active: "true", category: "momo" })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const chowmein = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({
    active: "true",
    category: "chowmein",
  })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const noodles = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({ active: "true", category: "noodles" })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const fries = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({ active: "true", category: "fries" })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const pizza = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({ active: "true", category: "pizza" })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const burger = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({ active: "true", category: "burger" })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const shawarma = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({
    active: "true",
    category: "shawarma",
  })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const roll = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({ active: "true", category: "roll" })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const nihari = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({ active: "true", category: "nihari" })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const biryani = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({ active: "true", category: "biryani" })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const korma = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({ active: "true", category: "korma" })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const tikka = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({ active: "true", category: "tikka" })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const fry = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({ active: "true", category: "fry" })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const roti = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0 } = req.query;
  await connect_mongoDB();

  const products = await Products.find({ active: "true", category: "roti" })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();
  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const product_search_id = async (req, res) => {
  const id = req.query.id;

  if (!id || id.length !== 24) {
    return res.status(400).json({
      success: false,
      message: "Invalid ID",
    });
  }

  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  await connect_mongoDB();

  const products = await Products.findById(id);

  if (!products) {
    res.status(404).json({
      success: false,
      message: "Products not found",
    });
  }

  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const search = async (req, res) => {

  const {search, limit, skip = 0 } = req.query;
  
  if (!search) {
    return res.status(400).json({
      success: false,
      message: "Search query is empty",
    });
  }
  
  if (req.method !== "GET") {
    res
    .status(405)
    .json({ error: "This method is not premitted", success: false });
  }
  
  
  await connect_mongoDB();
  
  const query = {
    $or: [
      { title: { $regex: search, $options: "i" } },
      { foodCategory: { $regex: search, $options: "i" } },
      { category: { $regex: search, $options: "i" } },
      { shopName: { $regex: search, $options: "i" } },
    ],
  };
  
  const products = await Products.find(query)
  .limit(parseInt(limit))
  .skip(parseInt(skip))
  .exec();

  if (!products) {
    res.status(404).json({
      success: false,
      message: "Products not found",
    });
  }

  res.status(200).json({
    Products: products,
    success: true,
    message: "Products get Successfully",
  });
};

const shopAllProducts = async (req, res) => {
  if (req.method !== "GET") {
    res
      .status(405)
      .json({ error: "This method is not premitted", success: false });
  }

  const { limit, skip = 0, email } = req.query;

  await connect_mongoDB();
  const products = await Products.find({
    active: "true",
    email: email,
  })
    .limit(parseInt(limit))
    .skip(parseInt(skip))
    .exec();

  if (!products) {
    res.status(404).json({
      success: false,
      message: "Products not found",
    });
  }

  res.status(200).json({
    Products: products,
    success: true,
    message: "Shop Products get Successfully",
  });
};

export {
  allProducts,
  momo,
  chowmein,
  noodles,
  fries,
  pizza,
  burger,
  shawarma,
  roll,
  nihari,
  biryani,
  korma,
  tikka,
  fry,
  roti,
  product_search_id,
  shopAllProducts,
  search,
};
