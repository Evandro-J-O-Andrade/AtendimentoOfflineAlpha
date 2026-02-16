import { createContext, useContext, useEffect, useState } from "react";
import { getUnidadeContext, setUnidadeContext } from "../services/contexto.service";

const UnidadeContext = createContext({ unidadeId: null, setUnidade: async () => {} });

export function UnidadeProvider({ children }) {
  const [unidadeId, setUnidadeId] = useState(null);

  useEffect(() => {
    getUnidadeContext().then((id) => setUnidadeId(id)).catch(() => {});
  }, []);

  const setUnidade = async (id) => {
    const updated = await setUnidadeContext(id);
    setUnidadeId(updated);
  };

  return (
    <UnidadeContext.Provider value={{ unidadeId, setUnidade }}>
      {children}
    </UnidadeContext.Provider>
  );
}

export function useUnidadeContext() {
  return useContext(UnidadeContext);
}