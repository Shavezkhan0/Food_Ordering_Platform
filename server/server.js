import express from "express";
import dotenv from "dotenv";
import userRoutes from "./routes/userRoutes.js"; // Correctly import the user routes
import productRoutes from "./routes/productRouters.js";
import connect_mongoDB from "./features/mongoDB.js";
import shopRoutes from "./routes/shopRouters.js";
import cors from "cors";
import bodyParser from "body-parser";
import dataSendtoMongoAtlesRoutes from "./routes/dataSendtoMongoAtlesRoutes.js";
import orderRoutes from "./routes/orderRouters.js";

dotenv.config({
  path: "./.env.local", 
});

const app = express();
app.use(bodyParser.json());
const PORT = process.env.PORT || 3000;

//Connect To Mongoose
connect_mongoDB();

// Middleware to parse JSON bodies
app.use(cors({ origin: "*" }));
app.use(cors());
app.use(express.json());

// Use the userRoutes for handling routes under /api/v1/user
app.use("/api/v1/user", userRoutes);
app.use("/api/v1/product", productRoutes);
app.use("/api/v1/shop", shopRoutes);
app.use("/api/v1/order", orderRoutes);
app.use("/dataSendtoMongoAtles", dataSendtoMongoAtlesRoutes);

// Basic route
app.get("/", (req, res) => {
  res.send("Hello, World!");
});

// Example of a post route
app.post("/data", (req, res) => {
  const { name, age } = req.body;
  res.json({ message: `Received data for ${name}, age ${age}` });
});

// Start the server
app.listen(PORT,"0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
