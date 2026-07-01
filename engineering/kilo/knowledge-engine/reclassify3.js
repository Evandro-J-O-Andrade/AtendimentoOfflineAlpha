const fs = require('fs');
const data = JSON.parse(fs.readFileSync('engineering/inventory/tables.json'));

const refined = data.all.map(t => {
    const name = t.name;
    let domain = t.refined_domain;
    
    if (domain === 'Unknown') {
        if (/^alerta|^evento_|^erros?|^erro_/.test(name)) domain = 'Operational';
        else if (/^codigo_|^config_|^map_|^vinculo/.test(name)) domain = 'Core';
        else if (/^consumo_|^escala_|^plantao_|^coordenador/.test(name)) domain = 'Workforce/Operational';
        else if (/^enfermagem|^aprazamento|^diagnostico/.test(name)) domain = 'HIS/Enfermagem';
        else if (/^exame|^pedido|^historico/.test(name)) domain = 'Diagnostics';
        else if (/^farmacia|^farmaco|^medicamento/.test(name)) domain = 'HIS/Farmacia';
        else if (/^documento|^arquivo|^assinatura/.test(name)) domain = 'Documents';
        else if (/^assistencia_social/.test(name)) domain = 'Social';
        else if (/^especialidade|^conselho/.test(name)) domain = 'Workforce';
    }
    
    return { ...t, refined_domain: domain };
});

data.all = refined;
fs.writeFileSync('engineering/inventory/tables.json', JSON.stringify(data, null, 2));

const count = {};
refined.forEach(t => { count[t.refined_domain] = (count[t.refined_domain] || 0) + 1; });
console.log('Final classification:', JSON.stringify(count, null, 2));
console.log('Unknown remaining:', refined.filter(t=>t.refined_domain=='Unknown').length);