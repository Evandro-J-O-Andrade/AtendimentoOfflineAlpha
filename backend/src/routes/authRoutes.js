const express = require("express");
const router = express.Router();

const loginController = require("../controllers/auth/loginController");

router.post("/login", loginController);

module.exports = router;