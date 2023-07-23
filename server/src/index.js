const express = require("express");
const mongoose = require("mongoose");
const app = express();
const cors = require("cors");
const authRoute = require('./routes/auth')
require("dotenv/config");

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoute);

app.listen(5000, () => {
    console.log("server has started on port 5000");
});

mongoose
    .connect(process.env.DB_CONNECT, { useNewUrlParser: true })
    .then(() => {
        console.log("Database connected");
    })
    .catch((error) => {
        console.error("Error connecting to database:", error);
    });