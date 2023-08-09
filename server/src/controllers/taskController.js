const express = require("express");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const User = require("../models/Users");
const Task = require("../models/Tasks");


exports.getTasks = async(req, res) => {
    try {
        const task = await Task.find();
        return res.status(200).json(task);
    } catch (err) {
        console.log(err);
        res.status(500).json({ message: "Internal server error" });
    }

}

exports.deleteTask = async(req, res) => {
    try {
        console.log(req.params)
        const { id } = req.params;
        const userTask = await Task.findById(id);
        if (!userTask) return res.status(400).json({ message: "Task not found!" });
        console.log(userTask)
        const deleteTask = await Task.findByIdAndDelete(id);
        if (!deleteTask) return res.status(400).json({ message: "Task not deleted!" });
        return res.status(200).json({ message: "Task deleted successfully!" });

    } catch (err) {
        console.log(err);
        res.status(500).json({ message: "Internal server error" });
    }
}

exports.getTasksById = async(req, res) => {
    try {
        const { id } = req.params;
        const userTasks = await Task.find({ taskOwnerId: id });
        console.log(userTasks)
        if (!userTasks) return res.status(400).json({ message: "User not found!" })
        return res.status(200).json(userTasks);

    } catch (err) {
        console.log(err);
        res.status(500).json({ message: "Internal server error" });
    }
}

exports.createTask = async(req, res) => {
    try {
        const {
            taskName,
            taskOwnerId,
            taskDescription,
            taskStatus,
            taskPriority,
            taskTime,
        } = req.body;

        const user = await User.findById(taskOwnerId);
        if (!user) return res.status(400).json({ message: "User not found!" });

        const newTask = await Task({
            taskName,
            taskOwnerId,
            taskDescription,
            taskStatus,
            taskPriority,
            taskTime,
            taskOwner: user.username,
        });
        const saveTask = await newTask.save();
        if (!saveTask) return res.status(400).json({ message: "Task not saved!" });
        return res
            .status(200)
            .json({ message: "Task Created Successfully", newTask });
    } catch (err) {
        console.log(err);
        res.status(500).json({ message: "Internal server error" });
    }
};