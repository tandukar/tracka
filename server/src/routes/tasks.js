const express = require("express");
const router = express.Router();
const taskController = require("../controllers/taskController");

router.post("/create", taskController.createTask);
router.patch("/", taskController.updateTask);
router.get("/", taskController.getTasks)
router.get("/:id", taskController.getTasksById)
router.delete("/:id", taskController.deleteTask)
router.patch("/:status/status-update", taskController.bulkStatusUpdate)


module.exports = router;