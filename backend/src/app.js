const express = require("express");
const cors = require("cors");
const authRoutes = require("./auth/authRoutes");
const operacionalRoutes = require("./routes/operacionalRoutes");
const farmaciaRoutes = require("./routes/farmaciaRoutes");
const painelRoutes = require("./routes/painelRoutes");
const ledgerRoutes = require("./ledger/ledgerRoutes");
const dispatcherRoutes = require("./routes/dispatcherRoutes");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRoutes);
app.use("/api/operacional", operacionalRoutes);
app.use("/api/operacional/farmacia", farmaciaRoutes);
app.use("/api/painel", painelRoutes);
app.use("/api", ledgerRoutes);
app.use("/api/runtime", dispatcherRoutes);

module.exports = app;
