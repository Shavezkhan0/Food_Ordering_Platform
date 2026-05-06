import express from "express";
import {
  allProducts,
  biryani,
  burger,
  chowmein,
  fries,
  fry,
  korma,
  momo,
  nihari,
  noodles,
  pizza,
  product_search_id,
  roll,
  roti,
  search,
  shawarma,
  shopAllProducts,
  tikka,
} from "../controller/productControllers.js";

const productRoutes = express.Router();

productRoutes.get("/", (req, res) => {
  res.send("product Api");
});

productRoutes.get("/allProducts", allProducts);
productRoutes.get("/momo", momo);
productRoutes.get("/chowmein", chowmein);
productRoutes.get("/noodles", noodles);
productRoutes.get("/fries", fries);
productRoutes.get("/pizza", pizza);
productRoutes.get("/burger", burger);
productRoutes.get("/shawarma", shawarma);
productRoutes.get("/roll", roll);
productRoutes.get("/nihari", nihari);
productRoutes.get("/biryani", biryani);
productRoutes.get("/korma", korma);
productRoutes.get("/tikka", tikka);
productRoutes.get("/fry", fry);
productRoutes.get("/roti", roti);
productRoutes.get("/search_by_id", product_search_id);
productRoutes.get("/shopProducts", shopAllProducts);
productRoutes.get("/search", search);

export default productRoutes;
