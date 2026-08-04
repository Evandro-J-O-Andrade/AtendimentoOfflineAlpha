import {
  createContext,
  useContext,
  useState,
  type ReactNode,
  useCallback,
} from 'react'

export type ToastType =
  | 'success'
  | 'error'
  | 'warning'
  | 'info'
  | 'offline'
  | 'unauthorized'
  | 'forbidden'
  | 'timeout'

interface Toast {
  id: number
  type: ToastType
  title: string
  message: string
  action?: { label: string; onClick: () => void }
  duration?: number
}

interface ToastContextValue {
  add: (toast: Omit<Toast, 'id'>) => void
  remove: (id: number) => void
}

const ToastContext = createContext<ToastContextValue | null>(null)

export function useToast() {
  const ctx = useContext(ToastContext)
  if (!ctx) {
    throw new Error('useToast deve ser usado dentro de ToastProvider')
  }
  return ctx
}

export function ToastProvider({ children }: { children: ReactNode }) {
  const [toasts, setToasts] = useState<Toast[]>([])

  const remove = useCallback((id: number) => {
    setToasts((prev) => prev.filter((t) => t.id !== id))
  }, [])

  const add = useCallback(
    (toast: Omit<Toast, 'id'>) => {
      const id = Date.now()
      const duration = toast.duration ?? 5000
      setToasts((prev) => [...prev, { id, ...toast }])
      if (duration > 0) {
        setTimeout(() => remove(id), duration)
      }
    },
    [remove]
  )

  return (
    <ToastContext.Provider value={{ add, remove }}>
      {children}
      <ToastContainer toasts={toasts} onRemove={remove} />
    </ToastContext.Provider>
  )
}

function ToastContainer({
  toasts,
  onRemove,
}: {
  toasts: Toast[]
  onRemove: (id: number) => void
}) {
  if (toasts.length === 0) return null

  return (
    <div
      style={{
        position: 'fixed',
        bottom: '1rem',
        right: '1rem',
        display: 'flex',
        flexDirection: 'column',
        gap: '0.5rem',
        zIndex: 9999,
      }}
    >
      {toasts.map((toast) => (
        <ToastItem
          key={toast.id}
          toast={toast}
          onClose={() => onRemove(toast.id)}
        />
      ))}
    </div>
  )
}

function ToastItem({
  toast,
  onClose,
}: {
  toast: Toast
  onClose: () => void
}) {
  const colorMap: Record<ToastType, string> = {
    success: '#28a745',
    error: '#dc3545',
    warning: '#ffc107',
    info: '#17a2b8',
    offline: '#6c757d',
    unauthorized: '#fd7e14',
    forbidden: '#6f42c1',
    timeout: '#e83e8c',
  }

  return (
    <div
      style={{
        minWidth: '300px',
        padding: '0.75rem 1rem',
        borderRadius: '6px',
        color: 'white',
        backgroundColor: colorMap[toast.type] ?? '#17a2b8',
        fontSize: '0.85rem',
        boxShadow: '0 2px 8px rgba(0,0,0,0.2)',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
      }}
    >
      <div>
        <strong>{toast.title}</strong>
        <p style={{ margin: '0.25rem 0 0', opacity: 0.9 }}>{toast.message}</p>
        {toast.action && (
          <button
            onClick={() => {
              toast.action?.onClick()
              onClose()
            }}
            style={{
              marginTop: '0.5rem',
              padding: '0.25rem 0.75rem',
              border: '1px solid rgba(255,255,255,0.5)',
              borderRadius: '4px',
              background: 'rgba(255,255,255,0.2)',
              color: 'white',
              cursor: 'pointer',
              fontSize: '0.75rem',
            }}
          >
            {toast.action.label}
          </button>
        )}
      </div>
      <button
        onClick={onClose}
        style={{
          border: 'none',
          background: 'transparent',
          color: 'white',
          cursor: 'pointer',
          fontSize: '1.1rem',
          lineHeight: 1,
          paddingLeft: '0.5rem',
        }}
      >
        ×
      </button>
    </div>
  )
}
