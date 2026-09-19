const UserModel = require("../Model/userModel");
const bcrypt = require("bcrypt");
const createUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    const genSalt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, genSalt);
    const user = await UserModel.create({ email, password: hashedPassword });
    await user.save();
    res.status(201).json(user);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
  module.exports = { createUser };
};
