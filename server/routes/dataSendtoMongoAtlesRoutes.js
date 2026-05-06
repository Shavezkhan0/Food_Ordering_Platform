import express from "express";
import { sendAllOders, sendAllProducts, sendAllShops, sendAllUsers } from "../controller/dataSendtoMongoAtlesControllers.js";

const dataSendtoMongoAtlesRoutes = express.Router();


dataSendtoMongoAtlesRoutes.get("/products",sendAllProducts)
dataSendtoMongoAtlesRoutes.get("/shops",sendAllShops)
dataSendtoMongoAtlesRoutes.get("/orders",sendAllOders)
dataSendtoMongoAtlesRoutes.get("/users",sendAllUsers)

dataSendtoMongoAtlesRoutes.get("/",(req,res)=>{
    res.send("dataSendtoMongoAtlesRoutes")
})



export default dataSendtoMongoAtlesRoutes;