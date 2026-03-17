const mysql = require("mysql2/promise");

async function seedAcoes() {
    const pool = mysql.createPool({
        host: "localhost",
        user: "root",
        password: "root",
        database: "pronto_atendimento",
        waitForConnections: true,
        connectionLimit: 10
    });

    try {
        // Inserir permissões para novos setores
        const permissoes = [
            { codigo: 'AMBULANCIA', nome: 'Painel Ambulância', descricao: 'Acesso ao painel de ambulância/transporte', acao_frontend: 'painel_ambulancia', dominio: 'AMBULANCIA', grupo_menu: 'AMBULANCIA' },
            { codigo: 'REMOCAO', nome: 'Painel Remoção', descricao: 'Acesso ao painel de remoção', acao_frontend: 'painel_remocao', dominio: 'REMOCAO', grupo_menu: 'REMOCAO' },
            { codigo: 'MANUTENCAO', nome: 'Painel Manutenção', descricao: 'Acesso ao painel de manutenção', acao_frontend: 'painel_manutencao', dominio: 'MANUTENCAO', grupo_menu: 'MANUTENCAO' },
            { codigo: 'GASOTERAPIA', nome: 'Painel Gasoterapia', descricao: 'Acesso ao painel de gasoterapia', acao_frontend: 'painel_gasoterapia', dominio: 'GASOTERAPIA', grupo_menu: 'GASOTERAPIA' },
            { codigo: 'ASSISTENCIA_SOCIAL', nome: 'Painel Assistência Social', descricao: 'Acesso ao painel de assistência social', acao_frontend: 'painel_assistencia_social', dominio: 'ASSISTENCIA_SOCIAL', grupo_menu: 'ASSISTENCIA_SOCIAL' },
            { codigo: 'FATURAMENTO', nome: 'Painel Faturamento', descricao: 'Acesso ao painel de faturamento', acao_frontend: 'painel_faturamento', dominio: 'FATURAMENTO', grupo_menu: 'FATURAMENTO' },
            { codigo: 'CAT', nome: 'Painel CAT', descricao: 'Acesso ao painel de CAT (Acidentes de Trabalho)', acao_frontend: 'painel_cat', dominio: 'CAT', grupo_menu: 'CAT' },
            { codigo: 'OBITO', nome: 'Painel Óbito', descricao: 'Acesso ao painel de óbito', acao_frontend: 'painel_obito', dominio: 'OBITO', grupo_menu: 'OBITO' },
            { codigo: 'PDV', nome: 'Painel PDV', descricao: 'Acesso ao painel de PDV/Vendas', acao_frontend: 'painel_pdv', dominio: 'PDV', grupo_menu: 'PDV' },
            { codigo: 'NUTRICAO', nome: 'Painel Nutrição', descricao: 'Acesso ao painel de nutrição', acao_frontend: 'painel_nutricao', dominio: 'NUTRICAO', grupo_menu: 'NUTRICAO' },
            { codigo: 'INTERCONSULTA', nome: 'Painel Interconsulta', descricao: 'Acesso ao painel de interconsulta', acao_frontend: 'painel_interconsulta', dominio: 'INTERCONSULTA', grupo_menu: 'INTERCONSULTA' }
        ];

        // Verificar se perfil admin existe e vincular permissões
        const [perfis] = await pool.execute("SELECT id_perfil, nome FROM perfil WHERE nome LIKE '%ADMIN%' LIMIT 1");
        
        if (perfis.length > 0) {
            const id_perfil = perfis[0].id_perfil;
            console.log(`Vincular permissões ao perfil ID: ${id_perfil} (${perfis[0].nome})`);
            
            // Buscar IDs das permissões inseridas
            for (const p of permissoes) {
                const [perm] = await pool.execute(
                    "SELECT id_permissao FROM permissao WHERE codigo = ?",
                    [p.codigo]
                );
                
                if (perm.length > 0) {
                    const id_permissao = perm[0].id_permissao;
                    // Tabela perfil_permissao só tem id_perfil, id_permissao, criado_em
                    await pool.execute(
                        `INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
                         VALUES (?, ?, NOW())`,
                        [id_perfil, id_permissao]
                    );
                    console.log(`✓ Vincular ${p.codigo} ao perfil admin`);
                }
            }
        } else {
            console.log("\n⚠ Perfil ADMINISTRADOR não encontrado. Permissões criadas mas não vinculadas.");
        }

        console.log('\n✅ Seed de permissões concluído com sucesso!');
    } catch (error) {
        console.error('❌ Erro ao executar seed:', error.message);
    } finally {
        await pool.end();
    }
}

seedAcoes();
