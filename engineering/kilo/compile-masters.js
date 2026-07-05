const fs = require('fs');
const path = require('path');

function getAllMarkdownFiles(dir, files = []) {
    fs.readdirSync(dir).forEach(item => {
        const fullPath = path.join(dir, item);
        if (fs.statSync(fullPath).isDirectory()) {
            getAllMarkdownFiles(fullPath, files);
        } else if (item.endsWith('.md')) {
            files.push(fullPath);
        }
    });
    return files;
}

function compileMaster() {
    const master = [];
    master.push('# PROJECT BRAIN — FCA/MIDAS Enterprise\n');
    master.push('## Generated: ' + new Date().toISOString() + '\n');
    
    // Canonical docs
    ['engineering/canonical/index.md', 'engineering/metadata/domain-mapping.md', 
     'engineering/metadata/canonical-mapping-index.md', 'engineering/metadata/orphan-analysis.md']
    .forEach(f => {
        if (fs.existsSync(f)) master.push(fs.readFileSync(f, 'utf8') + '\n\n---\n\n');
    });
    
    // MDs
    const mdDir = 'engineering/canonical/md';
    if (fs.existsSync(mdDir)) {
        fs.readdirSync(mdDir).forEach(f => {
            if (f.endsWith('.md')) master.push(fs.readFileSync(path.join(mdDir, f), 'utf8') + '\n\n---\n\n');
        });
    }
    
    fs.writeFileSync('docs/PROJECT_BRAIN.md', master.join(''));
    console.log('✅ PROJECT_BRAIN.md compilado');
}

compileMaster();