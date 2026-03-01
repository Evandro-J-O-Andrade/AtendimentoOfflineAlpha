const express = require("express");
const AuthController = require("./authController");

const router = express.Router();

router.post("/login", AuthController.login);

module.exports = router;