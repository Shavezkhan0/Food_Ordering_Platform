import mongoose, { Schema } from "mongoose";

const geolocationData = new Schema({
  latitude: {
    type: Number,
    required: true,
  },
  longitude: {
    type: Number,
    required: true,
  },
  accuracy: {
    type: Number,
    required: false,
  },
});

const OrderSchema = new Schema(
  {
    orderId: {
      type: String,
      required: true,
    },
    username: {
      type: String,
      required: false,
    },
    email: {
      type: String,
      required: true,
    },
    phoneNumber: {
      type: Number,
      required: true,
    },
    address: { type: String, required: true },
    landmark: {
      type: String,
    },
    pincode: {
      type: String,
      required: true,
    },
    totalPrice: {
      type: Number,
      required: true,
    },
    deliveryCharge: {
      type: Number,
      required: true,
    },
    textCharge: {
      type: Number,
      required: true,
    },
    geolocation: geolocationData,
    shopDetails: [
      {
        shopemail: {
          type: String,
          required: true,
        },
        products: [
          {
            type: mongoose.Schema.Types.ObjectId,
            ref: "Products",
            required: false,
          },
        ],
      },
    ],
    products: {
      type: Object,
      required: false,
    },
    paymentInfo: {
      method: {
        type: String,
        default: "Pay on delivery",
      },
      paymentStatus: {
        type: String,
        default: "pending",
      },
    },
    deliverystatus: {
      pack: {
        type: String,
        default: "pending",
      },
      shipped: {
        type: String,
        default: "pending",
      },
      deliver: {
        type: String,
        default: "pending",
      },
    },
  },
  { timestamps: true }
);

export default mongoose.models.AppOrders ||
  mongoose.model("AppOrders", OrderSchema);
