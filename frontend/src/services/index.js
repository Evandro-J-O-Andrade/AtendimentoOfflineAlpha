/**
 * Services Index - Exporta todos os serviços do frontend
 *HIS/PA - Sistema de Prontuário Ambulatorial
 */

// Autenticação
export { default as AuthService } from './AuthService';

// Serviços principais
export { default as UserService } from './UserService';
export { default as PacienteService } from './PacienteService';
export { default as PermissionService } from './PermissionService';
export { default as AssistencialService } from './AssistencialService';
export { default as FilaService } from './FilaService';

// API direta (para casos específicos)
export * from '../api/spApi';
