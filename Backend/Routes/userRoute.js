import express from "express";
import User from "../models/User.js";

const userRoute = express.Router()

userRoute.post("/register", async (req, res) => {
  res.send("register");
const existingUser = await userRoute.findOne({email})
  
});
userRoute.post("/login", (req, res) => {
  res.send("Login ");
});
  export default userRoute;
