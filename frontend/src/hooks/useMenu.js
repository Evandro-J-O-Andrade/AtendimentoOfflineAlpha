import { useState, useEffect, useCallback } from "react";
import { useApp } from "../context/AppContext";

export function useMenu() {
  const { permissoes: permissoesContexto } = useApp();
  const [menu, setMenu] = useState({});
  const [permissoes, setPermissoes] = useState([]);
  const [carregando, setCarregando] = useState(true);
  const [erro, setErro] = useState(null);

  const carregarPermissoes = useCallback(() => {
    try {
      setCarregando(true);
      setErro(null);

      const perms = permissoesContexto || [];
      setPermissoes(perms);

      const menuMontado = {};
      perms.forEach((perm) => {
        const grupo = perm.grupo_menu || "Geral";
        const ordem = perm.ordem_menu || 999;
        if (!menuMontado[grupo]) menuMontado[grupo] = [];
        menuMontado[grupo].push({
          codigo: perm.codigo,
          nome: perm.nome,
          icone: perm.icone,
          ordem,
          acao: perm.acao_frontend,
          url: perm.url_menu,
        });
      });
      Object.keys(menuMontado).forEach((g) =>
        menuMontado[g].sort((a, b) => a.ordem - b.ordem)
      );
      setMenu(menuMontado);
    } catch (err) {
      console.error("Erro ao carregar menu:", err);
      setErro(err.message);
    } finally {
      setCarregando(false);
    }
  }, [permissoesContexto]);

  useEffect(() => {
    carregarPermissoes();
  }, [carregarPermissoes]);

  const verificarPermissao = useCallback(
    (codigo) => permissoes.some((p) => p.codigo === codigo),
    [permissoes]
  );

  return {
    menu,
    permissoes,
    carregando,
    erro,
    temPermissao: verificarPermissao,
    recarregar: carregarPermissoes,
  };
}

export default useMenu;
