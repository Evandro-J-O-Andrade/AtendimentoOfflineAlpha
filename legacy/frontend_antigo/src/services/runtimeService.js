import api from "../api/api";

export async function executeRuntimeAction(acao, payload = {}, contexto = "DEFAULT") {
  const { data } = await api.post(
    `/runtime`,
    { acao, contexto, payload }
  );
  return data;
}
