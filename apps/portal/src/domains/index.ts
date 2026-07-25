/**
 * Domain Registry
 *
 * Mapeia módulos canônicos para suas configurações de rota e workspace.
 * Centraliza a resolução de domínios para o router do Portal.
 *
 * @module domains
 *
 * @see {@link DomainConfig}
 */

export interface DomainConfig {
  id: string
  nome: string
  modulo: string
  rota: string
  icone: string
  acoes: string[]
}
