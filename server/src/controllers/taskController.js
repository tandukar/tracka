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
};

exports.deleteTask = async(req, res) => {
    try {
        console.log(req.params);
        const { id } = req.params;
        const userTask = await Task.findById(id);
        if (!userTask) return res.status(400).json({ message: "Task not found!" });
        console.log(userTask);
        const deleteTask = await Task.findByIdAndDelete(id);
        if (!deleteTask)
            return res.status(400).json({ message: "Task not deleted!" });
        return res.status(200).json({ message: "Task deleted successfully!" });
    } catch (err) {
        console.log(err);
        res.status(500).json({ message: "Internal server error" });
    }
};

exports.getTasksById = async(req, res) => {
    try {
        const { id } = req.params;
        const userTasks = await Task.find({ taskOwnerId: id });
        console.log(userTasks);
        if (!userTasks) return res.status(400).json({ message: "User not found!" });
        return res.status(200).json(userTasks);
    } catch (err) {
        console.log(err);
        res.status(500).json({ message: "Internal server error" });
    }
};

exports.updateTask = async(req, res) => {
    try {
        const { id, taskId } = req.query;
        const { taskName, taskDescription, taskStatus, taskPriority, taskTime } =
        req.body;

        console.log(req.query);

        const user = await User.findById(id);
        if (!user) return res.status(400).json({ message: "User not found!" });
        const task = await Task.find({ taskOwnerId: id });
        const taskIds = task.map((task) => task._id.toString());
        if (!taskIds.includes(taskId))
            return res.status(400).json({ message: "Task not found!" });
        const update = await Task.findByIdAndUpdate(req.query.taskId, {
            taskName,
            taskDescription,
            taskStatus,
            taskPriority,
            taskTime,
        });
        if (!update) return res.status(400).json({ message: "Task not updated!" });
        return res.status(200).json({ message: "Task updated successfully!" });
    } catch (err) {
        console.log(err);
        res.status(500).json({ message: "Internal server error" });
    }
};


exports.searchTaskByName = async(req, res) => {
    console.log(req.query);
    try {
        const { userId, taskName } = req.query; // Use req.query instead of req.params
        const user = await User.findById(userId);
        const task = await Task.find({ taskOwnerId: userId, taskName: taskName });
        console.log(user)

        // if (!task || task.length === 0) {
        //     return res.status(400).json({ message: "Task not found!" });
        // }
        if (!task) return res.status(400).json({ message: "Task not found!" });
        return res.status(200).json(task);
    } catch (err) {
        console.log(err);
        res.status(500).json({ message: "Internal server error" });
    }
};

exports.bulkStatusUpdate = async(req, res) => {
    let foundTaskIds = [];
    try {
        const { taskIds } = req.body;
        const { status } = req.params;
        console.log(req.params.status);
        const tasks = await Task.find({ _id: { $in: taskIds } });
        console.log("Found Tasks:", tasks);
        if (!tasks || tasks.length !== taskIds.length) {
            foundTaskIds = tasks.map((task) => task._id.toString());
            const notFoundTaskIds = taskIds.filter(
                (id) => !foundTaskIds.includes(id)
            );
            console.log("Tasks Not Found:", notFoundTaskIds);
            console.log("Tasks Found:", foundTaskIds);
            if (notFoundTaskIds.length > 0) {
                console.log("Some tasks not found!");
            }
        }
        const update = await Task.updateMany({ _id: { $in: foundTaskIds } }, { taskStatus: status });
        return res.status(200).json({ message: "Tasks updated successfully!" });
    } catch (err) {
        console.log(err);
        res.status(500).json({ message: "Internal server error" });
    }
};

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