import api from "./api";

export async function getLocalContext() {
  const { data } = await api.get("/contexto/contexto_local.php");
  return data?.contexto?.local_id ?? null;
}

export async function setLocalContext(localId) {
  const { data } = await api.post("/contexto/contexto_local.php", { local_id: localId });
  return data?.contexto?.local_id ?? null;
}

export async function getUnidadeContext() {
  const { data } = await api.get("/contexto/contexto_unidade.php");
  return data?.contexto?.unidade_id ?? null;
}

export async function setUnidadeContext(unidadeId) {
  const { data } = await api.post("/contexto/contexto_unidade.php", { unidade_id: unidadeId });
  return data?.contexto?.unidade_id ?? null;
}