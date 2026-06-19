/**
 * ================================================================
 * PermissionService - Serviço de Permissões por Perfil
 * ================================================================
 * 
 * Gerencia verificações de permissão baseadas em:
 * - Perfil do usuário
 * - Recurso (entidade/tabela)
 * - Ação (criar, ler, atualizar, excluir)
 * 
 * O sistema de permissões é determinístico:
 * perfil + recurso + ação = permitted/denied
 * ================================================================
 */

const pool = require("../config/database");

class PermissionService {

    /**
     * Verifica se o usuário tem permissão para uma ação específica
     * @param {number} id_perfil - ID do perfil do usuário
     * @param {string} recurso - Código do recurso (ex: 'SENHA', 'FFA', 'MEDICAMENTO')
     * @param {string} acao - Ação (ex: 'CRIAR', 'LER', 'ATUALIZAR', 'EXCLUIR', 'DISPENSAR')
     * @returns {Promise<boolean>}
     */
    static async verificarPermissao(id_perfil, recurso, acao) {
        // Admin tem acesso total
        if (id_perfil === 1) {
            return true;
        }

        let conn;
        try {
            conn = await pool.getConnection();
            
            // Buscar permissão específica: perfil + recurso + ação
            // Primeiro verifica se existe a tabela perfil_permissao
            const [tables] = await conn.query(
                "SHOW TABLES LIKE 'perfil_permissao'"
            );

            if (tables.length === 0) {
                // Se não existir perfil_permissao, permite acesso básico
                console.warn("Tabela perfil_permissao não existe, permitindo acesso");
                return true;
            }

            // Verifica se há permissão direta para o perfil
            const [permissoes] = await conn.query(
                `SELECT pp.* 
                 FROM perfil_permissao pp
                 JOIN permissao p ON p.id_permissao = pp.id_permissao
                 WHERE pp.id_perfil = ? 
                 AND p.codigo = ?`,
                [id_perfil, `${recurso}_${acao}`]
            );

            if (permissoes.length > 0) {
                return true;
            }

            // Verifica permissão curinga (acesso total ao recurso)
            const [wildcardPerms] = await conn.query(
                `SELECT pp.* 
                 FROM perfil_permissao pp
                 JOIN permissao p ON p.id_permissao = pp.id_permissao
                 WHERE pp.id_perfil = ? 
                 AND p.codigo = ?`,
                [id_perfil, `${recurso}_*`]
            );

            return wildcardPerms.length > 0;

        } catch (err) {
            console.error("Erro ao verificar permissão:", err.message);
            // Em caso de erro, retorna false por segurança
            return false;
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Verifica múltiplas permissões de uma vez
     * @param {number} id_perfil - ID do perfil
     * @param {Array<{recurso: string, acao: string}>} permissoes - Array de permissões
     * @returns {Promise<Object>} - Objeto com resultado de cada permissão
     */
    static async verificarMultiplasPermissoes(id_perfil, permissoes) {
        const resultados = {};
        
        for (const perm of permissoes) {
            resultados[`${perm.recurso}_${perm.acao}`] = await this.verificarPermissao(
                id_perfil, 
                perm.recurso, 
                perm.acao
            );
        }
        
        return resultados;
    }

    /**
     * Busca todas as permissões de um perfil
     * @param {number} id_perfil - ID do perfil
     * @returns {Promise<Array>}
     */
    static async buscarPermissoesPorPerfil(id_perfil) {
        let conn;
        try {
            conn = await pool.getConnection();
            
            const [permissoes] = await conn.query(
                `SELECT p.codigo, p.descricao
                 FROM perfil_permissao pp
                 JOIN permissao p ON p.id_permissao = pp.id_permissao
                 WHERE pp.id_perfil = ?
                 ORDER BY p.codigo`,
                [id_perfil]
            );
            
            return permissoes;
        } catch (err) {
            console.error("Erro ao buscar permissões:", err.message);
            return [];
        } finally {
            if (conn) conn.release();
        }
    }

    /**
     * Retorna as permissões formatadas para o frontend
     * @param {number} id_perfil - ID do perfil
     * @returns {Promise<Object>}
     */
    static async getPermissoesFrontend(id_perfil) {
        // Admin tem todas as permissões
        if (id_perfil === 1) {
            return {
                admin: true,
                modulos: ['*'],
                permissoes: ['*']
            };
        }

        const permissoes = await this.buscarPermissoesPorPerfil(id_perfil);
        
        // Organiza permissões por módulo/recurso
        const permissoesFormatadas = permissoes.reduce((acc, perm) => {
            const [recurso, acao] = perm.codigo.split('_');
            if (!acc[recurso]) {
                acc[recurso] = [];
            }
            acc[recurso].push(acao);
            return acc;
        }, {});

        return {
            admin: false,
            permissoes: permissoesFormatadas,
            modulos: Object.keys(permissoesFormatadas)
        };
    }
}

module.exports = PermissionService;
