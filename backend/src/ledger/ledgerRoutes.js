const express = require("express");
const LedgerService = require("./ledgerService");

const router = express.Router();

router.post("/ledger", async (req, res) => {
    // temporary handler
    const { action } = req.body;
    await LedgerService.recordAction(action);
    res.json({ success: true });
});

module.exports = router;
