import express from "express";
import { getAllShops, getOnShops, getShopByEmail } from "../controller/shopControllers.js";

const shopRoutes=express.Router()


shopRoutes.get("/",(req,res)=>{
    res.send("Shop Router")
})

shopRoutes.get("/allShops",getAllShops)
shopRoutes.get("/onShops",getOnShops)
shopRoutes.get("/byEmail",getShopByEmail)


export default shopRoutes;