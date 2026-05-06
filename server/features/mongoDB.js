import { mongoose } from "mongoose";


const connect_mongoDB=async()=>{

    try {

        if(mongoose.connections[0].readyState ){
            return;
        }
        
         await mongoose.connect(process.env.MONGOOSE_CONN_STRING,{
            dbName: "okhaladastarkhan",
         });
         console.log("Mongoose Connect sucessfully")

    } catch (error) {
        console.error("Connection fail to connect to mongoDB")
    }

}


export default connect_mongoDB;