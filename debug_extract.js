const fs = require('fs');
const path = 'D:\\AtendimentoOfflineAlpha\\legacy\\backend_antigo\\sql\\Dump20260606.sql';
const lines = fs.readFileSync(path, 'utf8').split(/\r?\n/);

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
                routines.push({ name: m[2], type: m[1], startLine: routineStart, endLine: i });
            }
            inDelim = false;
            buffer = [];
        }
    }
}

console.log('Routines found:', routines.length);
const procs = routines.filter(r => r.type === 'PROCEDURE');
const funcs = routines.filter(r => r.type === 'FUNCTION');
const evts = routines.filter(r => r.type === 'EVENT');
const trigs = routines.filter(r => r.type === 'TRIGGER');
console.log('Procedures:', procs.length);
console.log('Functions:', funcs.length);
console.log('Events:', evts.length);
console.log('Triggers:', trigs.length);
procs.slice(0, 5).forEach(r => console.log('PROC', r.name));
funcs.forEach(r => console.log('FUNC', r.name));
evts.forEach(r => console.log('EVENT', r.name));
trigs.forEach(r => console.log('TRIG', r.name));
