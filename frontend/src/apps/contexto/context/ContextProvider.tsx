import React, { createContext, useContext, useState, useCallback } from "react";
import { useAuth } from "@/context/AuthProvider";
import api from "@/apps/operacional/services/api";
import type {
    ContextoState,
    ContextoSelecao,
    Unidade,
    Local,
    Sala,
} from "../types";

interface ContextContextValue extends ContextoState {
    unidades: Unidade[];
    locais: Local[];
    salas: Sala[];
    getContexto: () => Promise<ContextoSelecao | null>;
    setContexto: (data: { id_unidade: number; id_perfil: number; id_local: number | null; id_sala: number | null }) => Promise<{ sucesso: boolean; mensagem?: string }>;
    selectUnidade: (unidade: Unidade) => void;
    selectLocal: (local: Local) => void;
    selectSala: (sala: Sala) => void;
}

const ContextContext = createContext<ContextContextValue | undefined>(undefined);

export function ContextProvider({ children }: { children: React.ReactNode }) {
    const { session } = useAuth();
    const [unidades, setUnidades] = useState<Unidade[]>([]);
    const [locais, setLocais] = useState<Local[]>([]);
    const [salas, setSalas] = useState<Sala[]>([]);
    
    const [unidade, setUnidade] = useState<Unidade | null>(null);
    const [local, setLocal] = useState<Local | null>(null);
    const [sala, setSala] = useState<Sala | null>(null);
    const [loading, setLoading] = useState(false);

    const getContexto = useCallback(async (): Promise<ContextoSelecao | null> => {
        setLoading(true);
        try {
            const response = await api.get("/contexto");
            const data = response.data;
            if (data?.unidades) setUnidades(data.unidades);
            return data;
        } catch (err) {
            console.error("Erro ao buscar contexto:", err);
            return null;
        } finally {
            setLoading(false);
        }
    }, []);

    const setContexto = useCallback(async (data: { id_unidade: number; id_perfil: number; id_local: number | null; id_sala: number | null }) => {
        setLoading(true);
        try {
            await api.post("/contexto", data);
            return { sucesso: true };
        } catch (err: any) {
            return { 
                sucesso: false, 
                mensagem: err.response?.data?.mensagem || "Erro ao definir contexto" 
            };
        } finally {
            setLoading(false);
        }
    }, []);

    const selectUnidade = useCallback((unidade: Unidade) => {
        setUnidade(unidade);
    }, []);

    const selectLocal = useCallback((local: Local) => {
        setLocal(local);
    }, []);

    const selectSala = useCallback((sala: Sala) => {
        setSala(sala);
    }, []);

    return (
        <ContextContext.Provider
            value={{
                unidades,
                locais,
                salas,
                unidade: unidade || null,
                local: local || null,
                sala: sala || null,
                loading,
                sessao: session,
                getContexto,
                setContexto,
                selectUnidade,
                selectLocal,
                selectSala,
            }}
        >
            {children}
        </ContextContext.Provider>
    );
}

export const useContextSelection = () => {
    const context = useContext(ContextContext);
    if (!context) {
        throw new Error("useContextSelection must be used within a ContextProvider");
    }
    return context;
};