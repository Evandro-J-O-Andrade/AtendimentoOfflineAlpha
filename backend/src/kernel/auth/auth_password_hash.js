/**
 * ================================================================
 * Kernel Auth Password Hash
 * ================================================================
 * 
 * Utilitários para hash de senhas.
 * Suporta múltiplos algoritmos de hashing.
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

const bcrypt = require("bcryptjs");

/**
 * Configurações de hash
 */
const HASH_CONFIG = {
    // Salt rounds para bcrypt (maior = mais seguro, mais lento)
    saltRounds: 10,
    
    // Comprimento mínimo da senha
    minLength: 6,
    
    // Requerer maiúsculas
    requireUppercase: false,
    
    // Requerer minúsculas
    requireLowercase: false,
    
    // Requerer números
    requireNumbers: false,
    
    // Requerer caracteres especiais
    requireSpecial: false
};

/**
 * Gera hash de senha
 * @param {string} password - Senha em texto plano
 * @returns {Promise<string>} Hash da senha
 */
async function hashPassword(password) {
    if (!password) {
        throw new Error("SENHA_OBRIGATORIA");
    }
    
    if (password.length < HASH_CONFIG.minLength) {
        throw new Error(`SENHA_MUITO_CURTA (mínimo ${HASH_CONFIG.minLength} caracteres)`);
    }
    
    return await bcrypt.hash(password, HASH_CONFIG.saltRounds);
}

/**
 * Verifica senha
 * @param {string} password - Senha em texto plano
 * @param {string} hash - Hash armazenado
 * @returns {Promise<boolean>} True se válido
 */
async function verifyPassword(password, hash) {
    if (!password || !hash) {
        return false;
    }
    
    try {
        return await bcrypt.compare(password, hash);
    } catch (error) {
        console.error("[auth_password_hash] Erro ao verificar senha:", error.message);
        return false;
    }
}

/**
 * Valida requisitos de senha
 * @param {string} password - Senha a validar
 * @returns {Object} Resultado da validação
 */
function validatePasswordRequirements(password) {
    const errors = [];
    
    if (!password) {
        return { valid: false, errors: ["SENHA_OBRIGATORIA"] };
    }
    
    if (password.length < HASH_CONFIG.minLength) {
        errors.push(`Mínimo de ${HASH_CONFIG.minLength} caracteres`);
    }
    
    if (HASH_CONFIG.requireUppercase && !/[A-Z]/.test(password)) {
        errors.push("Deve conter pelo menos uma letra maiúscula");
    }
    
    if (HASH_CONFIG.requireLowercase && !/[a-z]/.test(password)) {
        errors.push("Deve conter pelo menos uma letra minúscula");
    }
    
    if (HASH_CONFIG.requireNumbers && !/[0-9]/.test(password)) {
        errors.push("Deve conter pelo menos um número");
    }
    
    if (HASH_CONFIG.requireSpecial && !/[!@#$%^&*(),.?":{}|<>]/.test(password)) {
        errors.push("Deve conter pelo menos um caractere especial");
    }
    
    return {
        valid: errors.length === 0,
        errors
    };
}

/**
 * Gera senha aleatória
 * @param {number} length - Comprimento
 * @returns {string} Senha gerada
 */
function generateRandomPassword(length = 8) {
    const uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const lowercase = "abcdefghijklmnopqrstuvwxyz";
    const numbers = "0123456789";
    const special = "!@#$%^&*()_+-=[]{}|;:,.<>?";
    
    let chars = lowercase + numbers;
    if (HASH_CONFIG.requireUppercase) chars += uppercase;
    if (HASH_CONFIG.requireSpecial) chars += special;
    
    let password = "";
    const array = new Uint32Array(length);
    
    // Usar crypto se disponível
    if (typeof crypto !== 'undefined' && crypto.getRandomValues) {
        crypto.getRandomValues(array);
    } else {
        for (let i = 0; i < length; i++) {
            array[i] = Math.floor(Math.random() * 0xffffffff);
        }
    }
    
    for (let i = 0; i < length; i++) {
        password += chars[array[i] % chars.length];
    }
    
    return password;
}

/**
 * Verifica se senha foi comprometida
 * @param {string} password - Senha a verificar
 * @returns {Promise<boolean>} True se comprometida
 */
async function isPasswordCompromised(password) {
    // Lista de senhas comuns (simplificada)
    const commonPasswords = [
        "123456", "password", "12345678", "qwerty", "123456789",
        "12345", "1234", "111111", "1234567", "dragon",
        "123123", "baseball", "iloveyou", "trustno1", "sunshine"
    ];
    
    return commonPasswords.includes(password.toLowerCase());
}

/**
 * Atualiza configuração de hash
 * @param {Object} config - Nova configuração
 */
function updateHashConfig(config) {
    Object.assign(HASH_CONFIG, config);
}

module.exports = {
    hashPassword,
    verifyPassword,
    validatePasswordRequirements,
    generateRandomPassword,
    isPasswordCompromised,
    updateHashConfig,
    HASH_CONFIG
};
