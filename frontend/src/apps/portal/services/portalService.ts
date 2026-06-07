import api from "../../operacional/services/api";
import type { PortalModule } from "../types";

interface PortalModulesResponse {
  sucesso?: boolean;
  modules?: PortalModule[];
}

export async function fetchPortalModules(): Promise<PortalModule[]> {
  const { data } = await api.get<PortalModulesResponse | PortalModule[]>("/portal/modules");

  if (Array.isArray(data)) return data;
  if (Array.isArray(data?.modules)) return data.modules;

  return [];
}
