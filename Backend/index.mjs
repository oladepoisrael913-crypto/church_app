import express from "express";
require("dotenv").config();
import mongoose from "mongoose";

const app = express();

const PORT = 3000;

app.get("/api/health", (req, res) => {
  res.json({
    message: "Gatherly API is running",
  });
});

const compass_string = "mongodb://localhost:27017/oladepoisrael913_db";
const atlas_string = process.env.MONGO_URI;

mongoose.connect(atlas_string)

  .then(() => {
    console.log("Connected to MongoDB");
    app.listen(PORT, () => {
      console.log(`Gatherly server running on port ${PORT}`);
    });
  })
  .catch((error) => {
    console.error("Error connecting to MongoDB:", error);
  });