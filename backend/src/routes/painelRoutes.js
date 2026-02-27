const express = require("express");
const router = express.Router();

const guardiaoRuntime = require("../middleware/guardiaoRuntime");

/*
=====================================
Painel Assistencial Runtime
=====================================
*/

router.get("/painel", guardiaoRuntime, (req, res) => {

    res.json({
        status: "ok",
        runtime: req.runtime
    });

});

module.exports = router;