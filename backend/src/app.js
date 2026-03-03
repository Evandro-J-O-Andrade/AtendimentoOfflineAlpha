const express = require("express");
const cors = require("cors");
const authRoutes = require("./auth/authRoutes");
const operacionalRoutes = require("./routes/operacionalRoutes");
const painelRoutes = require("./routes/painelRoutes");
const ledgerRoutes = require("./ledger/ledgerRoutes");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRoutes);
app.use("/api/operacional", operacionalRoutes);
app.use("/api/painel", painelRoutes);
app.use("/api", ledgerRoutes);

module.exports = app;
