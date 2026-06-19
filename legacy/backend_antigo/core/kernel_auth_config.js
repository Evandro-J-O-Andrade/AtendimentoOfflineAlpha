/**
 * ================================================================
 * Kernel Auth Config
 * ================================================================
 * 
 * Configurações do módulo de autenticação do kernel.
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

module.exports = {
    // Configurações de sessão
    session: {
        // Tempo de expiração do token (em horas)
        expiresIn: process.env.JWT_EXPIRES_IN || '8h',
        
        // Tempo máximo de inatividade (em minutos)
        maxInactivity: 30,
        
        // Máximo de sessões simultâneas por usuário
        maxSessionsPerUser: 5,
        
        // Tempo de grace period após expiração (em minutos)
        gracePeriod: 5
    },

    // Configurações de segurança
    security: {
        // Requerer MFA para admin
        requireMfaForAdmin: false,
        
        // Bloquear IP após X tentativas falhas
        lockoutAttempts: 5,
        
        // Tempo de bloqueio (em minutos)
        lockoutDuration: 15,
        
        // Comprimento mínimo da senha
        minPasswordLength: 6,
        
        // Requerer caracteres especiais na senha
        requireSpecialChar: false
    },

    // Configurações de token
    token: {
        // Algoritmo de assinatura
        algorithm: 'HS256',
        
        // Emitente do token
        issuer: 'cmdpro-kernel',
        
        // Audiência do token
        audience: 'cmdpro-runtime'
    },

    // Configurações de Rate Limiting
    rateLimit: {
        // Tentativas de login por IP
        loginAttempts: 10,
        
        // Janela de tempo (em minutos)
        windowMinutes: 15,
        
        // Tempo de bloqueio após exceder limite
        blockMinutes: 30
    },

    // Configurações de auditoria
    audit: {
        // Registrar todos os logins
        logAllLogins: true,
        
        // Registrar falhas de senha
        logFailedAttempts: true,
        
        // Nível de detalhe (debug, info, warn, error)
        logLevel: 'info'
    },

    // Configurações de cache
    cache: {
        // TTL do cache de permissões (em ms)
        permissionTtl: 30000,
        
        // TTL do cache de contexto (em ms)
        contextTtl: 60000
    }
};
