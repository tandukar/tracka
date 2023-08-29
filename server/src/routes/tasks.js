const express = require("express");
const router = express.Router();
const taskController = require("../controllers/taskController");

// router.post("/create", taskController.createTask);
// router.patch("/", taskController.updateTask);
// router.get("/", taskController.getTasks)
// router.get("/:id", taskController.getTasksById)
// router.delete("/:id", taskController.deleteTask)
// router.patch("/:status/status-update", taskController.bulkStatusUpdate)
// router.get("/search", taskController.searchTaskByName)

router.post("/create", taskController.createTask);
router.patch("/", taskController.updateTask);
router.get("/search", taskController.searchTaskByName);
router.get("/filter", taskController.filterTasks);
router.get('/get-tasks-by-date-range', taskController.getTasksByDateRange);
router.get("/:id", taskController.getTasksById);
router.get("/", taskController.getTasks);
router.delete("/:id", taskController.deleteTask);
router.patch("/:status/status-update", taskController.bulkStatusUpdate);

module.exports = router;