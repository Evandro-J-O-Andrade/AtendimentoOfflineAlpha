const express = require("express");
const cors = require("cors");
const authRoutes = require("./auth/authRoutes");
const operacionalRoutes = require("./routes/operacionalRoutes");
const filaRoutes = require("./routes/filaRoutes");
const totemRoutes = require("./routes/totemRoutes");
const triagemRoutes = require("./routes/triagemRoutes");
const farmaciaRoutes = require("./routes/farmaciaRoutes");
const contextoRoutes = require("./routes/contextoRoutes");
const painelRoutes = require("./routes/painelRoutes");
const ledgerRoutes = require("./ledger/ledgerRoutes");
const dispatcherRoutes = require("./routes/dispatcherRoutes");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRoutes);
app.use("/api/operacional", operacionalRoutes);
app.use("/api/fila", filaRoutes);
app.use("/api/totem", totemRoutes);
app.use("/api/triagem", triagemRoutes);
app.use("/api/farmacia", farmaciaRoutes);
app.use("/api/contexto", contextoRoutes);
app.use("/api/painel", painelRoutes);
app.use("/api", ledgerRoutes);
app.use("/api/runtime", dispatcherRoutes);

module.exports = app;
