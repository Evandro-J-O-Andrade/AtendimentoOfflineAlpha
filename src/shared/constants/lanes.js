// Padrão-base imutável
export const LANES = [
  { key: 'CLINICO', label: 'Clínico / Adulto', css: 'azul' },
  { key: 'PEDIATRICO', label: 'Pediátrico', css: 'amarelo' },
  { key: 'PRIORITARIO', label: 'Prioridade', css: 'laranja' },
  { key: 'EMERGENCIA', label: 'Emergência', css: 'vermelho' }
]

export function laneCssByTipo(tipo) {
  const t = (tipo || '').toUpperCase()
  const found = LANES.find((l) => l.key === t)
  return found?.css || 'azul'
}

export function laneLabelByTipo(tipo) {
  const t = (tipo || '').toUpperCase()
  const found = LANES.find((l) => l.key === t)
  return found?.label || 'Clínico / Adulto'
}
