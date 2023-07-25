const mongoose = require("mongoose");

const taskSchema = new mongoose.Schema({
    taskName: {
        type: String,
        required: true,
    },
    taskOwnerId: {
        type: mongoose.Schema.Types.ObjectId,
    },
    taskDescription: {
        type: String,
    },
    taskStatus: {
        type: String,
        enum: ["Not Started", "In Progress", "Completed"],
        default: "Not Started",
    },
    taskPriority: {
        type: String,
        enum: ["Low", "Normal", "High"],
        default: "Normal",
    },
    taskTime: {
        type: Date,
    },
    taskOwner: {
        type: String,
    },
    taskCreatedDate: {
        type: Date,
        default: Date.now,
    },
});

module.exports = mongoose.model("Task", taskSchema);