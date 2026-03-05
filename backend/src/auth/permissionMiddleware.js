/**
 * ================================================================
 * PermissionMiddleware - Middleware de Verificação de Permissões
 * ================================================================
 * 
 * Middleware para proteger rotas baseado em permissões do perfil.
 * Deve ser usado APÓS o authMiddleware que já valida a sessão.
 * 
 * Uso:
 * const permissionMiddleware = require('./permissionMiddleware');
 * router.post('/senha/criar', authMiddleware, permissionMiddleware('SENHA', 'CRIAR'), controller);
 * ================================================================
 */

const PermissionService = require('./permissionService');

/**
 * Cria um middleware de verificação de permissão
 * @param {string} recurso - Código do recurso (ex: 'SENHA', 'FFA', 'MEDICAMENTO')
 * @param {string} acao - Ação (ex: 'CRIAR', 'LER', 'ATUALIZAR', 'EXCLUIR', 'DISPENSAR')
 * @returns {Function}
 */
function verificarPermissao(recurso, acao) {
    return async (req, res, next) => {
        try {
            // O authMiddleware já deve ter populado req.user com o contexto
            if (!req.user || !req.user.id_usuario) {
                return res.status(401).json({
                    error: "USUARIO_NAO_AUTENTICADO",
                    message: "Usuário não autenticado"
                });
            }

            // Obter o ID do perfil do usuário logado
            // O perfil pode estar em req.user.perfil (string) ou precisamos buscar
            const perfil = req.user.perfil;
            
            if (!perfil) {
                return res.status(403).json({
                    error: "PERFIL_NAO_DEFINIDO",
                    message: "Perfil do usuário não definido no contexto"
                });
            }

            // Se for ADMIN (perfil = 1 ou string 'ADMIN'), permite tudo
            if (perfil === 1 || perfil === 'ADMIN') {
                return next();
            }

            // Converter perfil string para ID se necessário
            let id_perfil = perfil;
            if (typeof perfil === 'string') {
                const perfilMapeamento = {
                    'MEDICO': 2,
                    'RECEPCIONISTA': 3,
                    'ENFERMEIRO': 4,
                    'TECNICO_ENFERMAGEM': 5,
                    'FARMACEUTICO': 6,
                    'TECNICO_RADIOLOGIA': 7,
                    'ANALISTA': 8
                };
                id_perfil = perfilMapeamento[perfil] || perfil;
            }

            // Verificar permissão no banco
            const temPermissao = await PermissionService.verificarPermissao(
                id_perfil,
                recurso,
                acao
            );

            if (!temPermissao) {
                console.warn(`Permissão negada: Usuário ${req.user.id_usuario} (perfil: ${perfil}) tentou ${acao} em ${recurso}`);
                
                return res.status(403).json({
                    error: "PERMISSAO_NEGADA",
                    message: `Você não tem permissão para ${acao} ${recurso}`,
                    recurso,
                    acao
                });
            }

            // Permissão concedida
            next();

        } catch (err) {
            console.error("Erro no middleware de permissão:", err);
            return res.status(500).json({
                error: "ERRO_INTERNO_PERMISSAO",
                message: "Erro ao verificar permissões"
            });
        }
    };
}

/**
 * Middleware para verificar múltiplas permissões (ANY)
 * @param {Array<{recurso: string, acao: string}>} permissoes - Array de permissões
 * @returns {Function}
 */
function verificarUmaDasPermissoes(permissoes) {
    return async (req, res, next) => {
        try {
            if (!req.user || !req.user.id_usuario) {
                return res.status(401).json({
                    error: "USUARIO_NAO_AUTENTICADO",
                    message: "Usuário não autenticado"
                });
            }

            const perfil = req.user.perfil;

            // ADMIN tem acesso total
            if (perfil === 1 || perfil === 'ADMIN') {
                return next();
            }

            let id_perfil = perfil;
            if (typeof perfil === 'string') {
                const perfilMapeamento = {
                    'MEDICO': 2,
                    'RECEPCIONISTA': 3,
                    'ENFERMEIRO': 4,
                    'TECNICO_ENFERMAGEM': 5,
                    'FARMACEUTICO': 6,
                    'TECNICO_RADIOLOGIA': 7,
                    'ANALISTA': 8
                };
                id_perfil = perfilMapeamento[perfil] || perfil;
            }

            // Verifica se tem pelo menos uma das permissões
            for (const perm of permissoes) {
                const temPermissao = await PermissionService.verificarPermissao(
                    id_perfil,
                    perm.recurso,
                    perm.acao
                );

                if (temPermissao) {
                    return next();
                }
            }

            // Nenhuma permissão encontrada
            return res.status(403).json({
                error: "PERMISSAO_NEGADA",
                message: "Você não tem nenhuma das permissões requeridas para esta ação"
            });

        } catch (err) {
            console.error("Erro no middleware de permissão (any):", err);
            return res.status(500).json({
                error: "ERRO_INTERNO_PERMISSAO",
                message: "Erro ao verificar permissões"
            });
        }
    };
}

/**
 * Middleware para verificar todas as permissões (ALL)
 * @param {Array<{recurso: string, acao: string}>} permissoes - Array de permissões
 * @returns {Function}
 */
function verificarTodasPermissoes(permissoes) {
    return async (req, res, next) => {
        try {
            if (!req.user || !req.user.id_usuario) {
                return res.status(401).json({
                    error: "USUARIO_NAO_AUTENTICADO",
                    message: "Usuário não autenticado"
                });
            }

            const perfil = req.user.perfil;

            // ADMIN tem acesso total
            if (perfil === 1 || perfil === 'ADMIN') {
                return next();
            }

            let id_perfil = perfil;
            if (typeof perfil === 'string') {
                const perfilMapeamento = {
                    'MEDICO': 2,
                    'RECEPCIONISTA': 3,
                    'ENFERMEIRO': 4,
                    'TECNICO_ENFERMAGEM': 5,
                    'FARMACEUTICO': 6,
                    'TECNICO_RADIOLOGIA': 7,
                    'ANALISTA': 8
                };
                id_perfil = perfilMapeamento[perfil] || perfil;
            }

            // Verifica se tem todas as permissões
            for (const perm of permissoes) {
                const temPermissao = await PermissionService.verificarPermissao(
                    id_perfil,
                    perm.recurso,
                    perm.acao
                );

                if (!temPermissao) {
                    return res.status(403).json({
                        error: "PERMISSAO_NEGADA",
                        message: `Permissão obrigatória não encontrada: ${perm.recurso}_${perm.acao}`
                    });
                }
            }

            next();

        } catch (err) {
            console.error("Erro no middleware de permissão (all):", err);
            return res.status(500).json({
                error: "ERRO_INTERNO_PERMISSAO",
                message: "Erro ao verificar permissões"
            });
        }
    };
}

module.exports = {
    verificarPermissao,
    verificarUmaDasPermissoes,
    verificarTodasPermissoes
};
