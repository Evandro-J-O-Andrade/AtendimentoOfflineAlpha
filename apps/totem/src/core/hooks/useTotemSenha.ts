import { useEffect, useMemo, useState } from 'react'
import type { ApiClient } from '@atendimentooffline/api'
import { createApiClient } from '@atendimentooffline/api'
import type { TotemOpcao, TotemPlantaoItem } from '@atendimentooffline/contracts'
import { createTotemApi } from '@atendimentooffline/api'
import { printSenhaTicket } from '../utils/printTicket'
import type { TotemSenhaGrupos } from '../types/totem.types'

export interface UseTotemSenhaReturn {
  opcoes: TotemOpcao[]
  plantao: TotemPlantaoItem[]
  loading: boolean
  mensagem: string
  erro: string
  grupos: TotemSenhaGrupos
  gerarSenha: (id_opcao: number, nomeOpcao: string) => Promise<void>
}

export function useTotemSenha(config: { apiUrl: string; id_unidade: number; id_local_operacional: number; id_sessao: number | null }): UseTotemSenhaReturn {
  const [opcoes, setOpcoes] = useState<TotemOpcao[]>([])
  const [plantao, setPlantao] = useState<TotemPlantaoItem[]>([])
  const [loading, setLoading] = useState(false)
  const [mensagem, setMensagem] = useState('')
  const [erro, setErro] = useState('')

  const api = useMemo<ApiClient>(() => createApiClient({ baseUrl: config.apiUrl }), [config.apiUrl])
  const totemApi = useMemo(() => createTotemApi(api), [api])

  useEffect(() => {
    async function carregarDados() {
      if (!config.id_sessao) {
        setErro('Sessao invalida. Faca login para continuar.')
        return
      }

      try {
        const [opcoesData, plantaoData] = await Promise.all([
          totemApi.listarOpcoes({
            id_unidade: config.id_unidade,
            id_local_operacional: config.id_local_operacional,
            id_sessao: config.id_sessao
          }),
          totemApi.buscarPlantaoMedico({
            id_unidade: config.id_unidade,
            id_sessao: config.id_sessao
          })
        ])

        setOpcoes(opcoesData)
        setPlantao(plantaoData)
      } catch (e) {
        console.error(e)
        setErro('Falha ao carregar dados do totem.')
      }
    }

    carregarDados()
  }, [config.id_unidade, config.id_sessao, totemApi])

  const grupos = useMemo<TotemSenhaGrupos>(() => {
    const g: TotemSenhaGrupos = {
      prioritario: [],
      pediatria: [],
      normalAdulto: []
    }

    for (const opcao of opcoes) {
      const nome = normalizarLabel(opcao.label)
      if (nome.includes('PEDI')) {
        g.pediatria.push(opcao)
      } else if (
        nome.includes('PRIOR') ||
        nome.includes('PREFER') ||
        nome.includes('EMERGEN') ||
        nome.includes('URG')
      ) {
        g.prioritario.push(opcao)
      } else {
        g.normalAdulto.push(opcao)
      }
    }

    return g
  }, [opcoes])

  async function gerarSenha(id_opcao: number, nomeOpcao: string) {
    if (!config.id_sessao) {
      setErro('Sessao invalida. Faca login para continuar.')
      return
    }

    setLoading(true)
    setErro('')
    setMensagem('')

    try {
      const senha = await totemApi.gerarSenha({
        id_opcao,
        id_unidade: config.id_unidade,
        id_local_operacional: config.id_local_operacional,
        id_sessao: config.id_sessao
      })

      const ticketData = {
        tipo: senha.numero_senha,
        label: nomeOpcao || 'Atendimento'
      }

      setMensagem(`Senha gerada: ${senha.numero_senha}`)

      setTimeout(() => printSenhaTicket(ticketData), 500)
    } catch {
      setErro('Erro de comunicacao com o servidor.')
    } finally {
      setLoading(false)
    }
  }

  return {
    opcoes,
    plantao,
    loading,
    mensagem,
    erro,
    grupos,
    gerarSenha
  }
}

function normalizarLabel(nome: string): string {
  return String(nome || '')
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toUpperCase()
}
