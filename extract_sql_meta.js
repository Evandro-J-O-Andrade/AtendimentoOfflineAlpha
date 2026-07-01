const fs = require('fs');
const path = 'D:\\AtendimentoOfflineAlpha\\legacy\\backend_antigo\\sql\\Dump20260606.sql';
const lines = fs.readFileSync(path, 'utf8').split(/\r?\n/);

const tables = [];
let currentTable = null;

for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (line.startsWith('CREATE TABLE')) {
        if (currentTable) {
            currentTable.endLine = i;
            tables.push(currentTable);
        }
        const m = line.match(/CREATE TABLE\s+(?:IF NOT EXISTS\s+)?`([^`]+)`/i);
        currentTable = { name: m[1], startLine: i, endLine: lines.length };
    }
}
if (currentTable) {
    currentTable.endLine = lines.length;
    tables.push(currentTable);
}

// Save each table block as JSON
const tablesDir = 'D:\\AtendimentoOfflineAlpha\\docs\\database\\tables_raw';
fs.mkdirSync(tablesDir, { recursive: true });
tables.forEach((t, idx) => {
    const block = lines.slice(t.startLine - 1, t.endLine).join('\n');
    fs.writeFileSync(`${tablesDir}\\${t.name}.json`, JSON.stringify({name: t.name, block}, null, 2));
});

let inDelim = false;
let routineStart = -1;
let buffer = [];
const routines = [];

for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (line === 'DELIMITER ;;') {
        inDelim = true;
        routineStart = i + 1;
        buffer = [];
        continue;
    }
    if (inDelim) {
        buffer.push(line);
        if (line.trim().endsWith(';;')) {
            const text = buffer.join('\n');
            const m = text.match(/(?:ALGORITHM=UNDEFINED\s+DEFINER=`[^`]+@[^`]+`\s+)?(PROCEDURE|FUNCTION|TRIGGER|EVENT)\s+(?:IF NOT EXISTS\s+)?`([^`]+)`/i);
            if (m) {
                routines.push({ name: m[2], type: m[1], startLine: routineStart, endLine: i, text });
            }
            inDelim = false;
            buffer = [];
        }
    }
}

const proceduresDir = 'D:\\AtendimentoOfflineAlpha\\docs\\database\\procedures_raw';
fs.mkdirSync(proceduresDir, { recursive: true });
routines.forEach(r => {
    fs.writeFileSync(`${proceduresDir}\\${r.name}.json`, JSON.stringify(r, null, 2));
});

fs.writeFileSync('D:\\AtendimentoOfflineAlpha\\tables_meta.json', JSON.stringify({tables, routines}, null, 2));
console.log('Tables saved:', tables.length);
console.log('Routines saved:', routines.length);
