import connect_mongoDB from "../features/mongoDB.js";
import Order from "../models/Order.js";
import Products from "../models/Products.js";
import ShopUser from "../models/ShopUser.js";
import User from "../models/User.js";




const SendProductsDataToMongoAtles = async () => {
    const getDataAndStore = async () => {
        const response = await fetch("https://serverapk.okhladastarkhan.in/api/v1/product/allProducts");

        if (!response.ok) {
            throw new Error(`Response status: ${response.status}`);
        }

        const data = await response.json();
        let products = data.Products;

        // Ensure all products have the `availability` field
        products = products.map(product => ({
            ...product,
            availability: product.availability ?? false
        }));

        await connect_mongoDB();

        try {
            // Delete all existing documents
            await Products.deleteMany({});
            console.log("Existing product data deleted successfully");

            // Insert new product data
            const insertResults = await Products.insertMany(products);
            console.log("Products successfully stored in MongoDB Atlas:", insertResults);
        } catch (error) {
            console.error("Error inserting data:", error);
        }
    };

    await getDataAndStore();
};

const SendShopsDataToMongoAtles = async () => {
    const getDataAndStore = async () => {
      const response = await fetch(
        "https://serverapk.okhladastarkhan.in/api/v1/shop/allShops"
      );
  
      if (!response.ok) {
        throw new Error(`Response status: ${response.status}`);
      }
  
      const data = await response.json();
      const shops = data.shops;
  
      //  console.log(data);
      console.log(shops);
      //  console.log(shops[0]);
  
      connect_mongoDB();
  
      try {
        // await ShopUser.deleteMany()
        const insertResults = await ShopUser.insertMany(shops);
        console.log("Shops successfully stored in MongoDB Atlas:", insertResults);
      } catch (error) {
        console.error("Error inserting data:", error);
      }
    };
  
    getDataAndStore();
  };

  const SendOrdersDataToMongoAtles = async () => {
    const getDataAndStore = async () => {
      const response = await fetch(
        "https://serverapk.okhladastarkhan.in/api/v1/order/allOrders"
      );
  
      if (!response.ok) {
        throw new Error(`Response status: ${response.status}`);
      }
  
      const data = await response.json();
      const order = data.orders;
  
      //  console.log(data);
      // console.log(orders);
      //  console.log(shops[0]);
  
      console.log("1")
      connect_mongoDB();
      console.log("2")
  
      try {
        console.log("3")
        await Order.deleteMany()
        console.log("4")
        const insertResults = await Order.insertMany(order);
        console.log("5")
        console.log("Shops successfully stored in MongoDB Atlas:", insertResults);
      } catch (error) {
        console.error("Error inserting data:", error);
      }
    };
  
    getDataAndStore();
  };

  const SendUsersDataToMongoAtles = async () => {
    const getDataAndStore = async () => {
      const response = await fetch(
        "https://serverapk.okhladastarkhan.in/api/v1/user/allUser"
      );
  
      if (!response.ok) {
        throw new Error(`Response status: ${response.status}`);
      }
  
      const data = await response.json();
      const order = data.Users;
  
      //  console.log(data);
      console.log(order);
      //  console.log(shops[0]);
  
      console.log("1")
      connect_mongoDB();
      console.log("2")
  
      try {
        console.log("3")
        await User.deleteMany()
        console.log("4")
        const insertResults = await User.insertMany(order);
        console.log("5")
        console.log("Shops successfully stored in MongoDB Atlas:", insertResults);
      } catch (error) {
        console.error("Error inserting data:", error);
      }
    };
  
    getDataAndStore();
  };

export { SendShopsDataToMongoAtles, SendProductsDataToMongoAtles ,SendOrdersDataToMongoAtles,SendUsersDataToMongoAtles};
