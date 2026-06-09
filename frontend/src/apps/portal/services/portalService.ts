import api from "../../operacional/services/api";
import type { PortalAccess } from "../types/portal";

/**
 * Estrutura genérica de resposta da API do backend.
 */
interface ApiEnvelope<T> {
  sucesso?: boolean;
  resultado?: T;
  modulos?: T;
}

/**
 * Normaliza diferentes formatos de retorno do backend para uma lista de
 * códigos de permissão de módulo.
 */
function extractPermissions(payload: unknown): string[] | null {
  if (!payload) return null;

  const candidates: unknown[] = [];
  if (Array.isArray(payload)) {
    candidates.push(...payload);
  } else if (typeof payload === "object") {
    const env = payload as ApiEnvelope<unknown>;
    const list = env.resultado ?? env.modulos;
    if (Array.isArray(list)) candidates.push(...list);
  }

  if (candidates.length === 0) return null;

  const codes = candidates
    .map((item) => {
      if (typeof item === "string") return item;
      if (item && typeof item === "object") {
        const obj = item as Record<string, unknown>;
        const code = obj.codigo ?? obj.permissao ?? obj.code ?? obj.modulo;
        return typeof code === "string" ? code : null;
      }
      return null;
    })
    .filter((c): c is string => Boolean(c));

  return codes.length > 0 ? codes : null;
}

/**
 * Busca as permissões de módulos do usuário autenticado.
 *
 * O Portal funciona em ambientes onde o backend pode não estar disponível
 * (modo offline). Quando não é possível obter as permissões, retornamos
 * `fallback: true` para que o portal exiba todos os módulos ativos.
 */
export async function fetchPortalAccess(): Promise<PortalAccess> {
  try {
    const { data } = await api.get<ApiEnvelope<unknown>>("/portal/modulos");
    const permissions = extractPermissions(data);
    if (permissions) {
      return { permissions, fallback: false };
    }
    return { permissions: [], fallback: true };
  } catch {
    return { permissions: [], fallback: true };
  }
}
