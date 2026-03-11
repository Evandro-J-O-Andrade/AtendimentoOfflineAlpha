// Serviço de sincronização online/offline
// Mantém o runtime sempre atualizado quando há internet

import { getUserData, getToken } from "./loginService";
import { useState, useEffect } from "react";

const API_BASE = "http://localhost:3001/api";

// Verificar se está online
export function isOnline() {
  return navigator.onLine;
}

// Event listeners para online/offline
export function onOnline(callback) {
  window.addEventListener("online", callback);
}

export function onOffline(callback) {
  window.addEventListener("offline", callback);
}

// Sincronizar runtime com backend
export async function syncRuntime() {
  if (!isOnline()) {
    console.log("🔴 Offline - usando dados em cache");
    return { success: false, reason: "offline" };
  }

  try {
    const token = getToken();
    if (!token) {
      return { success: false, reason: "not_authenticated" };
    }

    // Buscar runtime atualizado do backend
    const response = await fetch(`${API_BASE}/auth/runtime`, {
      method: "GET",
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      }
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const dados = await response.json();

    if (dados.runtime) {
      // Merge com dados locais (preferir dados mais recentes do servidor)
      const dadosLocais = getUserData();
      
      const dadosMerge = {
        ...dadosLocais,
        runtime: dados.runtime,
        contexto: dados.contexto || dadosLocais.contexto,
        permissoes: dados.permissoes || dadosLocais.permissoes
      };

      // Salvar dados mesclados
      localStorage.setItem("hispa_auth", JSON.stringify(dadosMerge));
      console.log("🟢 Runtime sincronizado com sucesso!");
      
      return { success: true, data: dadosMerge };
    }

    return { success: false, reason: "no_runtime" };

  } catch (error) {
    console.error("❌ Erro ao sincronizar runtime:", error);
    return { success: false, reason: error.message };
  }
}

// Sincronizar fila operacional
export async function syncFila(idFila) {
  if (!isOnline()) {
    console.log("🔴 Offline - usando fila em cache");
    return { success: false, reason: "offline" };
  }

  try {
    const token = getToken();
    if (!token) {
      return { success: false, reason: "not_authenticated" };
    }

    const response = await fetch(`${API_BASE}/fila/${idFila}/senhas`, {
      method: "GET",
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      }
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const senhas = await response.json();

    // Salvar no cache offline
    const cacheKey = `fila_cache_${idFila}`;
    localStorage.setItem(cacheKey, JSON.stringify({
      data: senhas,
      timestamp: Date.now()
    }));

    console.log("🟢 Fila sincronizada!");
    return { success: true, data: senhas };

  } catch (error) {
    console.error("❌ Erro ao sincronizar fila:", error);
    return { success: false, reason: error.message };
  }
}

// Pegar fila do cache (offline)
export function getFilaCache(idFila) {
  const cacheKey = `fila_cache_${idFila}`;
  const cache = localStorage.getItem(cacheKey);
  
  if (!cache) return null;
  
  const { data, timestamp } = JSON.parse(cache);
  
  // Cache válido por 5 minutos
  const maxAge = 5 * 60 * 1000;
  if (Date.now() - timestamp > maxAge) {
    return null;
  }
  
  return data;
}

// Hook React para sincronização automática
export function useSync(onSyncComplete) {
  const [isSyncing, setIsSyncing] = useState(false);
  const [lastSync, setLastSync] = useState(null);

  // Sincronizar quando ficar online
  useEffect(() => {
    const handleOnline = async () => {
      console.log("📡 Voltou online! Sincronizando...");
      setIsSyncing(true);
      const resultado = await syncRuntime();
      setLastSync(Date.now());
      setIsSyncing(false);
      if (onSyncComplete) onSyncComplete(resultado);
    };

    onOnline(handleOnline);

    return () => {
      window.removeEventListener("online", handleOnline);
    };
  }, [onSyncComplete]);

  // Sincronização manual
  const sync = async () => {
    setIsSyncing(true);
    const resultado = await syncRuntime();
    setLastSync(Date.now());
    setIsSyncing(false);
    return resultado;
  };

  return { isSyncing, lastSync, sync };
}
