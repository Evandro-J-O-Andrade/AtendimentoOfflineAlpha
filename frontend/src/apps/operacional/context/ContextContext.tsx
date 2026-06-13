// Re-export from canonical location for compatibility
export { RuntimeProvider as ContextProvider, useRuntime as useOperationalContext, defaultRuntime as defaultContext } from "@/app/providers/RuntimeContext";
export type { Runtime as OperationalContext } from "@/app/providers/RuntimeContext";