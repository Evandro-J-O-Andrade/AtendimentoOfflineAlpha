import { useState, useEffect, useCallback, useMemo } from 'react';
import { Modulo } from '../../../shared/types/module';

const STORAGE_KEY = 'nw_recent_modules';
const MAX_RECENT = 3;

/**
 * Hook para gerenciar os módulos acessados recentemente no Portal Corporativo.
 * Armazena apenas os códigos dos módulos no localStorage para garantir persistência
 * segura sem problemas de serialização de ícones.
 */
export function useRecentModules(allModules: Modulo[]) {
  const [recentCodes, setRecentCodes] = useState<string[]>([]);

  // Carrega os dados do localStorage na inicialização
  useEffect(() => {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored) {
      try {
        setRecentCodes(JSON.parse(stored));
      } catch (e) {
        setRecentCodes([]);
      }
    }
  }, []);

  // Adiciona um módulo à lista de recentes (ou move para o topo se já existir)
  const addRecentModule = useCallback((codigo: string) => {
    setRecentCodes((prev) => {
      const filtered = prev.filter((c) => c !== codigo);
      const next = [codigo, ...filtered].slice(0, MAX_RECENT);
      localStorage.setItem(STORAGE_KEY, JSON.stringify(next));
      return next;
    });
  }, []);

  // Mapeia os códigos de volta para os objetos de Modulo completos
  const recentModules = useMemo(() => {
    return recentCodes
      .map((code) => allModules.find((m) => m.codigo === code))
      .filter((m): m is Modulo => !!m && m.ativo);
  }, [recentCodes, allModules]);

  return {
    recentModules,
    addRecentModule,
  };
}