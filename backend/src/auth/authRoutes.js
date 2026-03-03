const express = require("express");
const AuthController = require("./authController");
const authMiddleware = require("./authMiddleware");

const router = express.Router();

router.post("/login", AuthController.login);
router.get("/me", authMiddleware, AuthController.me);

module.exports = router;