import { createContext, useContext, useEffect, useState } from "react";
import { getLocalContext, setLocalContext } from "../services/contexto.service";

const LocalContext = createContext({ localId: null, setLocal: async () => {} });

export function LocalProvider({ children }) {
  const [localId, setLocalId] = useState(null);

  useEffect(() => {
    getLocalContext().then((id) => setLocalId(id)).catch(() => {});
  }, []);

  const setLocal = async (id) => {
    const updated = await setLocalContext(id);
    setLocalId(updated);
  };

  return (
    <LocalContext.Provider value={{ localId, setLocal }}>
      {children}
    </LocalContext.Provider>
  );
}

export function useLocalContext() {
  return useContext(LocalContext);
}