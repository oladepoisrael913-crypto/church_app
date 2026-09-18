const User = require("../models/userModel");
import bcrypt from "bcryptjs";
export const createUser = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = new User({ email, password });
    const genSalt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(password, genSalt);
    const user = await UserModel.create({ email, password: hashedPassword });
    await user.save();
    res.status(201).json(user);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
  module.exports = { createUser };
};
