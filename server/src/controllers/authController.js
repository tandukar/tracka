const express = require("express");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const User = require("../models/Users");

exports.createUser = async(req, res) => {
    try {
        const { username, email, password } = req.body;
        const emailExists = await User.findOne({ email });
        if (emailExists) {
            console.log("email already exists");
            return res.status(400).json({ message: "Email already exists!" });
        }
        const salt = await bcrypt.genSalt(10);
        const hashPwd = await bcrypt.hash(password, salt);
        const newUser = await User({
            username,
            email,
            password: hashPwd,
        });
        await newUser.save();
        return res
            .status(200)
            .json({ message: "User Created Successfully", newUser });
    } catch (err) {
        console.log(err);
        res.status(500).json({ message: "Internal server error" });
    }
};
exports.getUser = async(req, res) => {
    try {
        const user = await User.find();
        return res.status(200).json({ message: " Successfully", user });
    } catch (err) {
        console.log(err);
        res.status(500).json({ message: "Internal server error" });
    }
};
exports.loginUser = async(req, res) => {
    try {
        const { email, password } = req.body;
        const emailExists = await User.findOne({ email });
        if (!emailExists)
            return res
                .status(400)
                .json({ message: "Email or Password doesn't match!!" });
        const validPwd = await bcrypt.compare(password, emailExists.password);
        if (!validPwd)
            return res
                .status(400)
                .json({ message: "Email or Password doesn't match!!" });
        const token = jwt.sign({ _id: emailExists._id }, process.env.TOKEN_SECRET);
        console.log(token);

        return res
            .header("auth-token", token)
            .status(200)
            .json({ status: 200, message: "Logged in successfully", token: token });
    } catch (err) {
        console.log(err);
        res.status(500).json({ message: "Internal server error" });
    }
};