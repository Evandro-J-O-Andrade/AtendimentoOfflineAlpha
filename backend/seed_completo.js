const mysql = require("mysql2/promise");
const bcrypt = require("bcryptjs");

async function seedCompleto() {
    const pool = mysql.createPool({
        host: "localhost",
        user: "root",
        password: "root",
        database: "pronto_atendimento",
        waitForConnections: true,
        connectionLimit: 10
    });

    try {
        console.log("🚀 Iniciando seed completo do sistema...\n");

        // ============================================
        // 1. CRIAR UNIDADES
        // ============================================
        console.log("📦 Criando unidades...");
        const unidades = [
            { id: 1, nome: "Hospital Central", tipo: "HOSPITAL" },
            { id: 2, nome: "UPA 24h", tipo: "UPA" },
            { id: 3, nome: "UBS Norte", tipo: "UBS" },
            { id: 4, nome: "UBS Sul", tipo: "UBS" },
            { id: 5, nome: "Centro de Especialidades", tipo: "AMBULATORIO" }
        ];

        for (const u of unidades) {
            await pool.execute(
                `INSERT IGNORE INTO unidade (id_unidade, nome, tipo, ativo, criado_em, id_entidade) VALUES (?, ?, ?, 1, NOW(), 1)`,
                [u.id, u.nome, u.tipo]
            );
            console.log(`  ✓ ${u.nome}`);
        }

        // ============================================
        // 2. CRIAR TIPOS DE LOCAL
        // ============================================
        console.log("\n📍 Criando tipos de local...");
        const tiposLocal = [
            { id: 1, descricao: "Recepção" },
            { id: 2, descricao: "Triagem" },
            { id: 3, descricao: "Consultório" },
            { id: 4, descricao: "Enfermaria" },
            { id: 5, descricao: "Sala de Emergência" },
            { id: 6, descricao: "Laboratório" },
            { id: 7, descricao: "Farmácia" },
            { id: 8, descricao: "Estoque" },
            { id: 9, descricao: "Ambulância" },
            { id: 10, descricao: "Recepção Emergência" },
            { id: 11, descricao: "Sala de Espera" },
            { id: 12, descricao: "Administração" },
            { id: 13, descricao: "Nutrição" },
            { id: 14, descricao: "Serviço Social" },
            { id: 15, descricao: "Faturamento" },
            { id: 16, descricao: "CAT" },
            { id: 17, descricao: "Óbito" },
            { id: 18, descricao: "PDV" },
            { id: 19, descricao: "Gasoterapia" },
            { id: 20, descricao: "Manutenção" }
        ];

        for (const t of tiposLocal) {
            await pool.execute(
                `INSERT IGNORE INTO tipo_local (id_tipo_local, descricao) VALUES (?, ?)`,
                [t.id, t.descricao]
            );
        }
        console.log(`  ✓ ${tiposLocal.length} tipos de local criados`);

        // ============================================
        // 3. CRIAR LOCAIS DE TRABALHO
        // ============================================
        console.log("\n🏢 Criando locais de trabalho...");
        const locais = [
            // Unidade 1 - Hospital Central
            { id: 1, id_unidade: 1, id_tipo_local: 1, nome: "Recepção Principal", codigo: "HC-REC-01" },
            { id: 2, id_unidade: 1, id_tipo_local: 2, nome: "Sala de Triagem", codigo: "HC-TRI-01" },
            { id: 3, id_unidade: 1, id_tipo_local: 3, nome: "Consultório Médico 1", codigo: "HC-MED-01" },
            { id: 4, id_unidade: 1, id_tipo_local: 3, nome: "Consultório Médico 2", codigo: "HC-MED-02" },
            { id: 5, id_unidade: 1, id_tipo_local: 4, nome: "Enfermaria A", codigo: "HC-ENF-A" },
            { id: 6, id_unidade: 1, id_tipo_local: 4, nome: "Enfermaria B", codigo: "HC-ENF-B" },
            { id: 7, id_unidade: 1, id_tipo_local: 5, nome: "Sala de Emergência", codigo: "HC-EME-01" },
            { id: 8, id_unidade: 1, id_tipo_local: 6, nome: "Laboratório", codigo: "HC-LAB-01" },
            { id: 9, id_unidade: 1, id_tipo_local: 7, nome: "Farmácia Central", codigo: "HC-FAR-01" },
            { id: 10, id_unidade: 1, id_tipo_local: 8, nome: "Estoque Geral", codigo: "HC-EST-01" },
            // Unidade 2 - UPA
            { id: 11, id_unidade: 2, id_tipo_local: 1, nome: "Recepção UPA", codigo: "UPA-REC-01" },
            { id: 12, id_unidade: 2, id_tipo_local: 2, nome: "Triagem UPA", codigo: "UPA-TRI-01" },
            { id: 13, id_unidade: 2, id_tipo_local: 5, nome: "Emergência UPA", codigo: "UPA-EME-01" },
            { id: 14, id_unidade: 2, id_tipo_local: 7, nome: "Farmácia UPA", codigo: "UPA-FAR-01" },
            // Setores específicos
            { id: 15, id_unidade: 1, id_tipo_local: 9, nome: "Frota Ambulâncias", codigo: "HC-AMB-01" },
            { id: 16, id_unidade: 1, id_tipo_local: 13, nome: "Nutrição", codigo: "HC-NUT-01" },
            { id: 17, id_unidade: 1, id_tipo_local: 14, nome: "Assistência Social", codigo: "HC-SOC-01" },
            { id: 18, id_unidade: 1, id_tipo_local: 15, nome: "Faturamento", codigo: "HC-FAT-01" },
            { id: 19, id_unidade: 1, id_tipo_local: 16, nome: "CAT", codigo: "HC-CAT-01" },
            { id: 20, id_unidade: 1, id_tipo_local: 17, nome: "Serviço de Óbito", codigo: "HC-OBT-01" },
            { id: 21, id_unidade: 1, id_tipo_local: 18, nome: "PDV/Vendas", codigo: "HC-PDV-01" },
            { id: 22, id_unidade: 1, id_tipo_local: 19, nome: "Gasoterapia", codigo: "HC-GAS-01" },
            { id: 23, id_unidade: 1, id_tipo_local: 20, nome: "Manutenção", codigo: "HC-MAN-01" },
            { id: 24, id_unidade: 1, id_tipo_local: 12, nome: "Administração", codigo: "HC-ADM-01" }
        ];

        for (const l of locais) {
            await pool.execute(
                `INSERT IGNORE INTO local (id_local, id_unidade, id_tipo_local, nome, codigo, ativo, criado_em) 
                 VALUES (?, ?, ?, ?, ?, 1, NOW())`,
                [l.id, l.id_unidade, l.id_tipo_local, l.nome, l.codigo]
            );
        }
        console.log(`  ✓ ${locais.length} locais criados`);

        // ============================================
        // 4. CRIAR PERFIS
        // ============================================
        console.log("\n👥 Criando perfis...");
        const perfis = [
            { id: 1, nome: "Administrador", codigo: "ADMIN", descricao: "Acesso total ao sistema", contexto: "GERAL" },
            { id: 2, nome: "Recepcionista", codigo: "RECEPCAO", descricao: "Atendimento na recepção", contexto: "ATENDIMENTO" },
            { id: 3, nome: "Enfermeiro", codigo: "ENFERMAGEM", descricao: "Triagem e enfermagem", contexto: "ATENDIMENTO" },
            { id: 4, nome: "Médico", codigo: "MEDICO", descricao: "Atendimento médico", contexto: "ATENDIMENTO" },
            { id: 5, nome: "Farmacêutico", codigo: "FARMACIA", descricao: "Dispensação de medicamentos", contexto: "FARMACIA" },
            { id: 6, nome: "Técnico de Laboratório", codigo: "LABORATORIO", descricao: "Análises laboratoriais", contexto: "LABORATORIO" },
            { id: 7, nome: "Auxiliar de Enfermagem", codigo: "AUX_ENF", descricao: "Apoio à enfermagem", contexto: "ATENDIMENTO" },
            { id: 8, nome: "Estoquista", codigo: "ESTOQUE", descricao: "Gestão de estoque", contexto: "ESTOQUE" },
            { id: 9, nome: "Técnico de Ambulância", codigo: "AMBULANCIA", descricao: "Transporte de pacientes", contexto: "AMBULANCIA" },
            { id: 10, nome: "Assistente Social", codigo: "ASSIST_SOCIAL", descricao: "Serviço social", contexto: "SOCIAL" },
            { id: 11, nome: "Nutricionista", codigo: "NUTRICAO", descricao: "Nutrição e dietas", contexto: "NUTRICAO" },
            { id: 12, nome: "Faturista", codigo: "FATURAMENTO", descricao: "Faturamento", contexto: "FATURAMENTO" },
            { id: 13, nome: "Técnico de Manutenção", codigo: "MANUTENCAO", descricao: "Manutenção", contexto: "MANUTENCAO" },
            { id: 14, nome: "Gasoterapeuta", codigo: "GASOTERAPIA", descricao: "Gasoterapia", contexto: "GASOTERAPIA" },
            { id: 15, nome: "Atendente PDV", codigo: "PDV", descricao: "Ponto de venda", contexto: "COMERCIAL" },
            { id: 16, nome: "Coordenador", codigo: "COORDENADOR", descricao: "Coordenação de setor", contexto: "GERAL" }
        ];

        for (const p of perfis) {
            await pool.execute(
                `INSERT IGNORE INTO perfil (id_perfil, nome, codigo, descricao, contexto, ativo, criado_em) 
                 VALUES (?, ?, ?, ?, ?, 1, NOW())`,
                [p.id, p.nome, p.codigo, p.descricao, p.contexto]
            );
            console.log(`  ✓ ${p.nome}`);
        }

        // ============================================
        // 5. CRIAR PERMISSÕES (AÇÕES)
        // ============================================
        console.log("\n🔐 Criando permissões...");
        const permissoes = [
            // Ações existentes
            { codigo: 'ADMIN', nome: 'Painel Admin', acao_frontend: 'painel_admin', dominio: 'GERAL', grupo_menu: 'ADMIN' },
            { codigo: 'DASHBOARD', nome: 'Dashboard', acao_frontend: 'painel_dashboard', dominio: 'GERAL', grupo_menu: 'DASHBOARD' },
            { codigo: 'RECEPCAO', nome: 'Recepção', acao_frontend: 'painel_recepcao', dominio: 'RECEPCAO', grupo_menu: 'ATENDIMENTO' },
            { codigo: 'TRIAGEM', nome: 'Triagem', acao_frontend: 'painel_triagem', dominio: 'ATENDIMENTO', grupo_menu: 'ATENDIMENTO' },
            { codigo: 'ENFERMAGEM', nome: 'Enfermagem', acao_frontend: 'painel_enfermagem', dominio: 'ATENDIMENTO', grupo_menu: 'ATENDIMENTO' },
            { codigo: 'MEDICO', nome: 'Atendimento Médico', acao_frontend: 'painel_medico', dominio: 'ATENDIMENTO', grupo_menu: 'ATENDIMENTO' },
            { codigo: 'FARMACIA', nome: 'Farmácia', acao_frontend: 'painel_farmacia', dominio: 'FARMACIA', grupo_menu: 'FARMACIA' },
            { codigo: 'LABORATORIO', nome: 'Laboratório', acao_frontend: 'painel_laboratorio', dominio: 'LABORATORIO', grupo_menu: 'LABORATORIO' },
            { codigo: 'INTERNACAO', nome: 'Internação', acao_frontend: 'painel_internacao', dominio: 'INTERNACAO', grupo_menu: 'INTERNACAO' },
            { codigo: 'ESTOQUE', nome: 'Estoque', acao_frontend: 'painel_estoque', dominio: 'ESTOQUE', grupo_menu: 'ESTOQUE' },
            
            // Novas ações
            { codigo: 'AMBULANCIA', nome: 'Ambulância', acao_frontend: 'painel_ambulancia', dominio: 'AMBULANCIA', grupo_menu: 'AMBULANCIA' },
            { codigo: 'REMOCAO', nome: 'Remoção', acao_frontend: 'painel_remocao', dominio: 'REMOCAO', grupo_menu: 'AMBULANCIA' },
            { codigo: 'MANUTENCAO', nome: 'Manutenção', acao_frontend: 'painel_manutencao', dominio: 'MANUTENCAO', grupo_menu: 'OPERACIONAL' },
            { codigo: 'GASOTERAPIA', nome: 'Gasoterapia', acao_frontend: 'painel_gasoterapia', dominio: 'GASOTERAPIA', grupo_menu: 'CLINICO' },
            { codigo: 'ASSISTENCIA_SOCIAL', nome: 'Assistência Social', acao_frontend: 'painel_assistencia_social', dominio: 'ASSISTENCIA_SOCIAL', grupo_menu: 'SOCIAL' },
            { codigo: 'FATURAMENTO', nome: 'Faturamento', acao_frontend: 'painel_faturamento', dominio: 'FATURAMENTO', grupo_menu: 'ADMINISTRATIVO' },
            { codigo: 'CAT', nome: 'CAT', acao_frontend: 'painel_cat', dominio: 'CAT', grupo_menu: 'ATENDIMENTO' },
            { codigo: 'OBITO', nome: 'Óbito', acao_frontend: 'painel_obito', dominio: 'OBITO', grupo_menu: 'ADMINISTRATIVO' },
            { codigo: 'PDV', nome: 'PDV', acao_frontend: 'painel_pdv', dominio: 'PDV', grupo_menu: 'COMERCIAL' },
            { codigo: 'NUTRICAO', nome: 'Nutrição', acao_frontend: 'painel_nutricao', dominio: 'NUTRICAO', grupo_menu: 'CLINICO' },
            { codigo: 'INTERCONSULTA', nome: 'Interconsulta', acao_frontend: 'painel_interconsulta', dominio: 'INTERCONSULTA', grupo_menu: 'ATENDIMENTO' }
        ];

        for (const p of permissoes) {
            await pool.execute(
                `INSERT IGNORE INTO permissao (codigo, nome, acao_frontend, dominio, grupo_menu, ativo, criado_em) 
                 VALUES (?, ?, ?, ?, ?, 1, NOW())`,
                [p.codigo, p.nome, p.acao_frontend, p.dominio, p.grupo_menu]
            );
        }
        console.log(`  ✓ ${permissoes.length} permissões criadas`);

        // ============================================
        // 6. VINCULAR PERMISSÕES AOS PERFIS
        // ============================================
        console.log("\n🔗 Vinculando permissões aos perfis...");
        
        // Mapeamento de perfil -> permissões
        const perfilPermissoes = {
            1: ['ADMIN', 'DASHBOARD', 'RECEPCAO', 'TRIAGEM', 'ENFERMAGEM', 'MEDICO', 'FARMACIA', 'LABORATORIO', 'INTERNACAO', 'ESTOQUE', 'AMBULANCIA', 'REMOCAO', 'MANUTENCAO', 'GASOTERAPIA', 'ASSISTENCIA_SOCIAL', 'FATURAMENTO', 'CAT', 'OBITO', 'PDV', 'NUTRICAO', 'INTERCONSULTA'],
            2: ['RECEPCAO', 'DASHBOARD'],
            3: ['TRIAGEM', 'ENFERMAGEM', 'DASHBOARD'],
            4: ['MEDICO', 'DASHBOARD', 'PRESCRICAO'],
            5: ['FARMACIA', 'DASHBOARD'],
            6: ['LABORATORIO', 'DASHBOARD'],
            7: ['ENFERMAGEM', 'TRIAGEM'],
            8: ['ESTOQUE', 'DASHBOARD'],
            9: ['AMBULANCIA', 'REMOCAO', 'DASHBOARD'],
            10: ['ASSISTENCIA_SOCIAL', 'DASHBOARD'],
            11: ['NUTRICAO', 'DASHBOARD'],
            12: ['FATURAMENTO', 'DASHBOARD'],
            13: ['MANUTENCAO', 'DASHBOARD'],
            14: ['GASOTERAPIA', 'DASHBOARD'],
            15: ['PDV', 'DASHBOARD'],
            16: ['ADMIN', 'DASHBOARD', 'RECEPCAO', 'TRIAGEM', 'ENFERMAGEM', 'MEDICO', 'FARMACIA', 'LABORATORIO', 'INTERNACAO', 'ESTOQUE']
        };

        for (const [idPerfil, codigosPermissao] of Object.entries(perfilPermissoes)) {
            for (const codigoPerm of codigosPermissao) {
                const [perm] = await pool.execute(
                    "SELECT id_permissao FROM permissao WHERE codigo = ?",
                    [codigoPerm]
                );
                
                if (perm.length > 0) {
                    await pool.execute(
                        `INSERT IGNORE INTO perfil_permissao (id_perfil, id_permissao, criado_em) 
                         VALUES (?, ?, NOW())`,
                        [idPerfil, perm[0].id_permissao]
                    );
                }
            }
            console.log(`  ✓ Perfil ${idPerfil} vinculado a ${codigosPermissao.length} permissões`);
        }

        // ============================================
        // 7. CRIAR PESSOAS (FUNCIONÁRIOS)
        // ============================================
        console.log("\n👤 Criando funcionários/pessoas...");
        const pessoas = [
            { id: 1, nome: "Administrador Sistema", tipo: "FUNCIONARIO" },
            { id: 2, nome: "Maria da Silva", tipo: "FUNCIONARIO" },
            { id: 3, nome: "João Santos", tipo: "FUNCIONARIO" },
            { id: 4, nome: "Ana Paula Oliveira", tipo: "FUNCIONARIO" },
            { id: 5, nome: "Carlos Pereira", tipo: "FUNCIONARIO" },
            { id: 6, nome: "Juliana Costa", tipo: "FUNCIONARIO" },
            { id: 7, nome: "Roberto Ferreira", tipo: "FUNCIONARIO" },
            { id: 8, nome: "Patrícia Almeida", tipo: "FUNCIONARIO" },
            { id: 9, nome: "Marcos Rodrigues", tipo: "FUNCIONARIO" },
            { id: 10, nome: "Luciana Martins", tipo: "FUNCIONARIO" },
            { id: 11, nome: "Fernanda Souza", tipo: "FUNCIONARIO" },
            { id: 12, nome: "Ricardo Lima", tipo: "FUNCIONARIO" },
            { id: 13, nome: "Carla Dias", tipo: "FUNCIONARIO" },
            { id: 14, nome: "Bruno Castro", tipo: "FUNCIONARIO" },
            { id: 15, nome: "Tatiana Reis", tipo: "FUNCIONARIO" }
        ];

        for (const p of pessoas) {
            await pool.execute(
                `INSERT IGNORE INTO pessoa (id_pessoa, nome, tipo_pessoa, ativo, criado_em, id_entidade) 
                 VALUES (?, ?, 'FUNCIONARIO', 1, NOW(), 1)`,
                [p.id, p.nome]
            );
        }
        console.log(`  ✓ ${pessoas.length} pessoas criadas`);

        // ============================================
        // 8. CRIAR USUÁRIOS
        // ============================================
        console.log("\n🔑 Criando usuários...");
        const usuarios = [
            { id: 1, id_pessoa: 1, login: "admin", senha: "admin123", id_perfil: 1, id_local: 1 },
            { id: 2, id_pessoa: 2, login: "maria.silva", senha: "123456", id_perfil: 2, id_local: 1 },
            { id: 3, id_pessoa: 3, login: "joao.santos", senha: "123456", id_perfil: 3, id_local: 2 },
            { id: 4, id_pessoa: 4, login: "ana.paula", senha: "123456", id_perfil: 4, id_local: 3 },
            { id: 5, id_pessoa: 5, login: "carlos.pereira", senha: "123456", id_perfil: 5, id_local: 9 },
            { id: 6, id_pessoa: 6, login: "juliana.costa", senha: "123456", id_perfil: 6, id_local: 8 },
            { id: 7, id_pessoa: 7, login: "roberto.ferreira", senha: "123456", id_perfil: 7, id_local: 2 },
            { id: 8, id_pessoa: 8, login: "patricia.almeida", senha: "123456", id_perfil: 8, id_local: 10 },
            { id: 9, id_pessoa: 9, login: "marcos.rodrigues", senha: "123456", id_perfil: 9, id_local: 15 },
            { id: 10, id_pessoa: 10, login: "luciana.martins", senha: "123456", id_perfil: 10, id_local: 17 },
            { id: 11, id_pessoa: 11, login: "fernanda.souza", senha: "123456", id_perfil: 11, id_local: 16 },
            { id: 12, id_pessoa: 12, login: "ricardo.lima", senha: "123456", id_perfil: 12, id_local: 18 },
            { id: 13, id_pessoa: 13, login: "carla.dias", senha: "123456", id_perfil: 13, id_local: 23 },
            { id: 14, id_pessoa: 14, login: "bruno.castro", senha: "123456", id_perfil: 14, id_local: 22 },
            { id: 15, id_pessoa: 15, login: "tatiana.reis", senha: "123456", id_perfil: 15, id_local: 21 }
        ];

        for (const u of usuarios) {
            const senhaHash = await bcrypt.hash(u.senha, 10);
            await pool.execute(
                `INSERT IGNORE INTO usuario (id_usuario, id_pessoa, login, senha_hash, ativo, tentativas_login, criado_em) 
                 VALUES (?, ?, ?, ?, 1, 0, NOW())`,
                [u.id, u.id_pessoa, u.login, senhaHash]
            );
            console.log(`  ✓ Usuário: ${u.login} / Senha: ${u.senha}`);
        }

        // ============================================
        // 9. VINCULAR USUÁRIOS AOS PERFIS
        // ============================================
        console.log("\n👥 Vinculando usuários aos perfis...");
        for (const u of usuarios) {
            await pool.execute(
                `INSERT IGNORE INTO usuario_perfil (id_usuario, id_perfil, criado_em) 
                 VALUES (?, ?, NOW())`,
                [u.id, u.id_perfil]
            );
            console.log(`  ✓ Usuário ${u.login} -> Perfil ${u.id_perfil}`);
        }

        // ============================================
        // 10. VINCULAR USUÁRIOS AOS LOCAIS
        // ============================================
        console.log("\n📍 Vinculando usuários aos locais de trabalho...");
        for (const u of usuarios) {
            await pool.execute(
                `INSERT IGNORE INTO usuario_local (id_usuario, id_local, criado_em) 
                 VALUES (?, ?, NOW())`,
                [u.id, u.id_local]
            );
            console.log(`  ✓ Usuário ${u.login} -> Local ${u.id_local}`);
        }

        console.log("\n✅ ============================================");
        console.log("   SEED COMPLETO EXECUTADO COM SUCESSO!");
        console.log("   ============================================");
        console.log("\n📋 RESUMO:");
        console.log(`   - ${unidades.length} unidades`);
        console.log(`   - ${locais.length} locais de trabalho`);
        console.log(`   - ${perfis.length} perfis`);
        console.log(`   - ${permissoes.length} permissões`);
        console.log(`   - ${usuarios.length} usuários criados`);
        console.log("\n🔑 USUÁRIOS PARA TESTE:");
        console.log("   admin / admin123 (Administrador)");
        console.log("   maria.silva / 123456 (Recepcionista)");
        console.log("   joao.santos / 123456 (Enfermeiro)");
        console.log("   ana.paula / 123456 (Médico)");
        console.log("   carlos.pereira / 123456 (Farmacêutico)");
        console.log("   juliana.costa / 123456 (Técnico Lab)");
        console.log("   marcos.rodrigues / 123456 (Ambulância)");
        console.log("   luciana.martins / 123456 (Assist. Social)");
        
    } catch (error) {
        console.error("\n❌ Erro ao executar seed completo:", error.message);
    } finally {
        await pool.end();
    }
}

seedCompleto();
