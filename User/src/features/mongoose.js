import mongoose from "mongoose";

const conn_to_mon = async () => {
  try {
    if (mongoose.connections[0].readyState) {
      return;
    }

    await mongoose.connect(process.env.MONGOOSE_CONN_STRING, {
      dbName: "okhaladastarkhan",
    });
  } catch (error) {
    console.error("error in mongoose connection ", error);
  }
};

export default conn_to_mon;
