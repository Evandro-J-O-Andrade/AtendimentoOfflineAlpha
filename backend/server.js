// simple bootstrap for the API; most configuration lives in src/app.js
require("dotenv").config();

const app = require("./src/app");

// port may be configured via env
const port = process.env.PORT || 3001;

app.listen(port, () => {
    console.log(`Servidor rodando na porta ${port}`);
});