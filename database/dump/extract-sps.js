const fs = require('fs');
const content = fs.readFileSync('D:\\AtendimentoOfflineAlpha\\database\\dump\\Dump20260726.sql', 'utf8');
const sps = ['sp_master_login', 'sp_auth_contexto_get', 'sp_auth_contexto_set', 'sp_sessao_contexto_get', 'sp_sessao_contexto_set'];

for (const sp of sps) {
  const startMarker = `CREATE DEFINER=\`root\`@\`localhost\` PROCEDURE \`${sp}\``;
  const start = content.indexOf(startMarker);
  if (start >= 0) {
    const afterStart = content.substring(start);
    const lines = afterStart.split('\n');
    const spLines = [];
    for (const line of lines) {
      spLines.push(line);
      if (line.trim() === ';;') {
        break;
      }
    }
    console.log(`=== ${sp} ===`);
    console.log(spLines.join('\n'));
  } else {
    console.log(`=== ${sp} === NOT FOUND`);
  }
  console.log('');
}
