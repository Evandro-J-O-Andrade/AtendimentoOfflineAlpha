const fs = require('fs');
const path = require('path');

const CSV_PATH = path.resolve('docs/project/inventory-filtered.csv');
const OUTPUT_DIR = path.resolve('docs/project');

const data = fs.readFileSync(CSV_PATH, 'utf8').split('\n').filter(Boolean);
const headers = data[0].split(';').map(h => h.trim().replace(/^"|"$/g, ''));
const rows = data.slice(1).map(line => {
  const values = line.split(';');
  const obj = {};
  headers.forEach((h, i) => obj[h] = values[i]?.trim().replace(/^"|"$/g, '') || '');
  if (!obj.Path) return null;
  return obj;
}).filter(Boolean);

function writeMarkdown(name, content) {
  fs.writeFileSync(path.join(OUTPUT_DIR, name), content, 'utf8');
}

// Summary
const totalFiles = rows.length;
const extensions = [...new Set(rows.map(r => r.Extension))];
const totalSizeMB = (rows.reduce((sum, r) => sum + (parseFloat(r.SizeKB) || 0), 0) / 1024).toFixed(2);
const folders = [...new Set(rows.map(r => r.Path.split('\\').slice(0, -1).join('\\')))];

const summary = `# Inventory Summary\n\n## General Stats\n\n| Metric | Value |\n|--------|-------|\n| Total Files | ${totalFiles} |\n| Total Folders | ${folders.length} |\n| Total Size | ${totalSizeMB} MB |\n| Unique Extensions | ${extensions.length} |\n\n## By Extension\n\n${[...new Set(rows.map(r => r.Extension))].sort().map(ext => {
  const count = rows.filter(r => r.Extension === ext).length;
  const size = (rows.filter(r => r.Extension === ext).reduce((s, r) => s + (parseFloat(r.SizeKB) || 0), 0) / 1024).toFixed(2);
  return `- **${ext}**: ${count} files (${size} MB)`;
}).join('\n')}\n`;

// Tree
const tree = `# Project Tree\n\n\`\`\`text\n${[...new Set(rows.map(r => r.Path.split('\\').slice(0, -1).join('\\')))].sort().map(f => {
  const depth = f.split('\\').length - 1;
  const indent = '  '.repeat(depth);
  const name = f.split('\\').pop();
  const count = rows.filter(r => r.Path.startsWith(f + '\\')).length;
  return `${indent}|- ${name}/ (${count} files)`;
}).join('\n')}\n\`\`\`\n`;

// Duplicated
const byBaseExt = {};
rows.forEach(r => {
  const base = path.basename(r.Path, path.extname(r.Path));
  const ext = path.extname(r.Path);
  const key = base + ext;
  if (!byBaseExt[key]) byBaseExt[key] = [];
  byBaseExt[key].push(r.Path);
});

const duplicated = `# Duplicated Files\n\n${Object.entries(byBaseExt)
  .filter(([k, v]) => v.length > 1)
  .map(([k, v]) => `- **${k}**: ${v.length} copias\n  - ${v.join('\n  - ')}`)
  .join('\n\n') || 'Nenhuma duplicata detectada.'}\n`;

// Dead files
const deadExts = ['.log', '.tmp', '.temp', '.swp', '.bak', '.old', '.cache', '.dump', '.ps1', '.csv'];
const dead = rows.filter(r => deadExts.includes(r.Extension) || (r.Extension === '.sql' && r.Path.includes('\\stages\\') && r.Path !== 'Dump20260606.sql') || (r.Extension === '.sql' && r.Path.includes('\\dump\\') && r.Path !== 'Dump20260606.sql'));

const deadMd = `# Dead / Disposable Files\n\n${dead.length === 0 ? 'Nenhum arquivo morto detectado.' : [...new Set(dead.map(r => `- ${r.Path} (${r.Extension}, ${r.SizeKB} KB)`))].join('\n')}\n`;

// Technologies
const techMd = `# Technologies Identified\n\n## By Extension\n\n${[...new Set(rows.map(r => r.Extension))].sort().map(ext => `- ${ext}`).join('\n')}\n\n## Stack\n\n- Frontend: React/TypeScript\n- Backend: Node.js\n- Database: MySQL\n- Documentation: Markdown\n- Automation: PowerShell\n- N8N: JSON workflows\n- DevOps: Docker, Kubernetes, CI/CD\n- Assets: PNG, JPG, SVG\n`;

// Folder purpose
const folderMap = {};
folders.forEach(f => {
  const parts = f.split('\\');
  const purpose = [];
  if (parts.includes('frontend')) purpose.push('Frontend');
  else if (parts.includes('backend')) purpose.push('Backend');
  else if (parts.includes('database')) purpose.push('Database');
  else if (parts.includes('engineering')) purpose.push('Engineering');
  else if (parts.includes('docs')) purpose.push('Documentation');
  else if (parts.includes('legacy')) purpose.push('Legacy');
  else if (parts.includes('packages')) purpose.push('Packages');
  else if (parts.includes('infrastructure')) purpose.push('Infrastructure');
  else if (parts.includes('workflow')) purpose.push('Workflow');
  else if (parts.includes('automation')) purpose.push('Automation');
  else if (parts.includes('ai')) purpose.push('Artificial Intelligence');
  else if (parts.includes('deployment')) purpose.push('Deployment');
  else if (parts.includes('scripts')) purpose.push('Scripts');
  else if (parts.includes('domain')) purpose.push('Domain');
  else purpose.push('General');
  
  folderMap[f] = {
    name: parts[parts.length - 1],
    purpose: [...new Set(purpose)].join(', ') || 'General',
    count: rows.filter(r => r.Path.startsWith(f + '\\')).length,
    extensions: [...new Set(rows.filter(r => r.Path.startsWith(f + '\\')).map(r => r.Extension))]
  };
});

const folderMd = `# Folder Purpose\n\n| Folder | Purpose | Files | Extensions |\n|--------|---------|-------|------------|\n${Object.values(folderMap).map(f => `| ${f.name} | ${f.purpose} | ${f.count} | ${[...new Set(f.extensions)].slice(0, 5).join(', ')} |`).join('\n')}\n`;

// Migration report
const migrationMd = `# Migration Report\n\n## Current State\n\n- Total arquivos analisados: ${totalFiles}\n- Pastas identificadas: ${folders.length}\n\n## Classification\n\n- CODE: ${rows.filter(r => ['.ts', '.tsx', '.js', '.jsx'].includes(r.Extension)).length}\n- SQL: ${rows.filter(r => r.Extension === '.sql').length}\n- Docs: ${rows.filter(r => r.Extension === '.md').length}\n- JSON: ${rows.filter(r => r.Extension === '.json').length}\n- Config: ${rows.filter(r => ['.json', '.yaml', '.yml', '.ps1', '.env'].includes(r.Extension)).length}\n- Assets: ${rows.filter(r => ['.png', '.jpg', '.svg', '.gif', '.ico'].includes(r.Extension)).length}\n\n## Recommendations\n\n### Maintain\n- database/dump/Dump20260606.sql\n- docs/canonical/\n- engineering/canonical/\n- docs/database/\n- database/stages/\n\n### Migrate\n- engineering/ -> engineering/\n- docs/ -> docs/\n- database/ -> database/\n\n### Remove\n- ${dead.length} arquivos identificados\n- ${Object.entries(byBaseExt).filter(([k, v]) => v.length > 1).length} grupos de duplicatas\n\n## Next Steps\n\n1. Validar este inventario com a equipe\n2. Aprovar arquivos para remocao\n3. Executar limpeza cirurgica\n4. Reconstruir estrutura SaaS\n`;

writeMarkdown('inventory-summary.md', summary);
writeMarkdown('inventory-tree.md', tree);
writeMarkdown('duplicated-files.md', duplicated);
writeMarkdown('dead-files.md', deadMd);
writeMarkdown('technologies.md', techMd);
writeMarkdown('folder-purpose.md', folderMd);
writeMarkdown('migration-report.md', migrationMd);

console.log('✅ Todos os relatórios de inventário gerados em docs/project/');
console.log('   - inventory-summary.md');
console.log('   - inventory-tree.md');
console.log('   - duplicated-files.md');
console.log('   - dead-files.md');
console.log('   - technologies.md');
console.log('   - folder-purpose.md');
console.log('   - migration-report.md');
