const bcrypt = require("bcryptjs");
const fs = require("fs");
const path = require("path");

async function generateSeedWithHashes() {
    const password = "123456";
    
    console.log("Generating bcrypt hash for password: 123456...");
    
    try {
        const hash = await bcrypt.hash(password, 10);
        console.log("✅ Hash gerado:", hash);
        console.log("");
        
        // Ler o seed original
        const seedPath = path.join(__dirname, "sql", "seed.sql");
        let seedContent = fs.readFileSync(seedPath, "utf-8");
        
        // Substituir todos <COLE_HASH_AQUI> pelo hash real
        seedContent = seedContent.replace(/<COLE_HASH_AQUI>/g, hash);
        
        // Guardar em um novo ficheiro
        const newSeedPath = path.join(__dirname, "sql", "seed-with-hashes.sql");
        fs.writeFileSync(newSeedPath, seedContent);
        
        console.log("✅ Novo ficheiro gerado: backend/sql/seed-with-hashes.sql");
        console.log("");
        console.log("Agora execute em MySQL:");
        console.log(`mysql -u root -proot pronto_atendimento < "backend/sql/seed-with-hashes.sql"`);
        
    } catch (err) {
        console.error("❌ Erro:", err.message);
        process.exit(1);
    }
}

generateSeedWithHashes();
