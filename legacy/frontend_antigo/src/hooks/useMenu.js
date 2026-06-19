import { useEffect, useState } from "react";
import { useAuth } from "../apps/operacional/auth/AuthProvider";
import spApi from "../api/spApi";

export function useMenu() {
    const { session } = useAuth();
    const [menu, setMenu] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (!session?.id_sessao) {
            setMenu([]);
            setLoading(false);
            return;
        }

        async function load() {
            try {
                // Usa o modelo canônico: metodo + rota + id_sessao + payload
                const res = await spApi.callRoute({
                    metodo: "GET",
                    rota: "AUTH.MENU",
                    id_sessao: session.id_sessao,
                    payload: {}
                });

                if (res && res.modulos) {
                    setMenu(res.modulos);
                } else if (Array.isArray(res)) {
                    setMenu(res);
                } else {
                    setMenu([]);
                }
            } catch (err) {
                console.error("Erro ao carregar menu:", err);
                setMenu([]);
            } finally {
                setLoading(false);
            }
        }

        load();
    }, [session?.id_sessao]);

    return { menu, loading };
}
