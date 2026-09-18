import express from "express";
import mongoose from "mongoose";

const app = express();

const PORT = 3000;

app.get("/api/health", (req, res) => {
  res.json({
    message: "Gatherly API is running",
  });
});

const compass_string = "mongodb://localhost:27017/oladepoisrael913_db";
const atlas_string =
  process.env.ATLAS_STRING ||
  "mongodb+srv://oladepoisrael913_db:MyPassword.com@cluster0.u9mlh5i.mongodb.net/oladepoisrael913_db?appName=Cluster0";

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