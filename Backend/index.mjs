import express from "express";
import dotenv from "dotenv";
import mongoose from "mongoose";
dotenv.config();
const app = express();
import userRoute from "./Routes/userRoute.js"

const PORT = 3000;

app.get("/api/health", (req, res) => {
  res.json({
    message: "Gatherly API is running",
  });
});
app.use("/users", userRoute);

const compass_string = "mongodb://localhost:27017/oladepoisrael913_db";
const atlas_string = process.env.MONGO_URI;

mongoose
  .connect(atlas_string)

  .then(() => {
    console.log("Connected to MongoDB");
    app.listen(PORT, () => {
      console.log(`Gatherly server running on port ${PORT}`);
    });
  })
  .catch((error) => {
    console.error("Error connecting to MongoDB:", error);
  });
