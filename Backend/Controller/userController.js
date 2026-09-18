import mongoose from "mongoose";
import bcrypt from "bcryptjs";
export const createUser = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = new User({ email, password });
    await user.save();
    res.status(201).json(user);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
  module.exports = { createUser };
};
