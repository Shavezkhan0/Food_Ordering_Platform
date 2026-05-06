import express from "express";
import {
  SendOrdersDataToMongoAtles,
  SendProductsDataToMongoAtles,
  SendShopsDataToMongoAtles,
  SendUsersDataToMongoAtles,
} from "../sendDataToMongoAtles/SendDataToMongoAtles.js";

const sendAllProducts = async (req, res) => {
    // SendProductsDataToMongoAtles()
  res.send("SendProductsDataToMongoAtles Successfully");
};

const sendAllShops = async (req, res) => {
  // SendShopsDataToMongoAtles()
  res.send("SendShopsDataToMongoAtles Successfully");
};

const sendAllOders = async (req, res) => {
  // SendOrdersDataToMongoAtles()
  res.send("sendAllOdersDataToMongoAtles Successfully");
};

const sendAllUsers = async (req, res) => {
  // SendUsersDataToMongoAtles()
  res.send("sendAllUsersDataToMongoAtles Successfully");
};

export { sendAllProducts, sendAllShops ,sendAllOders,sendAllUsers};
