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
const permissaoRoutes = require("./routes/permissaoRoutes");
const sessionRoutes = require("./routes/sessionRoutes");
const spRoutes = require("./routes/spRoutes");

const app = express();

app.use(cors());
app.use(express.json({ limit: '10mb' }));

app.use("/api/auth", authRoutes);
app.use("/api/operacional", operacionalRoutes);
app.use("/api/fila", filaRoutes);
app.use("/api/totem", totemRoutes);
app.use("/api/triagem", triagemRoutes);
app.use("/api/farmacia", farmaciaRoutes);
app.use("/api/contexto", contextoRoutes);
app.use("/api/painel", painelRoutes);
app.use("/api/permissoes", permissaoRoutes);
app.use("/api", ledgerRoutes);
app.use("/api", sessionRoutes);
app.use("/api", spRoutes);

module.exports = app;
