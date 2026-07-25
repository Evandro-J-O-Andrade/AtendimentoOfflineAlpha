import type { DispatcherClient, EventClient } from '../../lib/DispatcherContracts'
import type {
  IdentityId,
  PersonData,
  UserData,
  IdentityRuntimeState,
  IdentityRuntimeMethods
} from './contracts/IdentityContracts'

/**
 * Runtime de Identity do Kernel Enterprise (MD-KERNEL-001).
 *
 * @fileoverview Implementação canônica do IdentityRuntime.
 */
export class IdentityRuntime implements IdentityRuntimeMethods {
  private readonly dispatcher: DispatcherClient
  private readonly events?: EventClient

  constructor(dispatcher: DispatcherClient, events?: EventClient) {
    this.dispatcher = dispatcher
    this.events = events
  }

  async loadPerson(idPessoa: IdentityId): Promise<PersonData> {
    const response = await this.dispatcher.send({
      modulo: 'IAM',
      acao: 'PERSON.LOAD',
      payload: { id_pessoa: idPessoa },
      idSessao: Number(idPessoa)
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_CARREGAR_PESSOA')
    }

    const person = response.resultado as PersonData
    this.events?.track({ modulo: 'KERNEL', acao: 'IDENTITY.PERSON_LOADED', payload: { id_pessoa: idPessoa } })
    return person
  }

  async loadUser(idUsuario: IdentityId): Promise<UserData> {
    const response = await this.dispatcher.send({
      modulo: 'IAM',
      acao: 'USER.LOAD',
      payload: { id_usuario: idUsuario },
      idSessao: Number(idUsuario)
    })

    if (!response.sucesso || !response.resultado) {
      throw new Error(response.mensagem ?? 'FALHA_CARREGAR_USUARIO')
    }

    const user = response.resultado as UserData
    this.events?.track({ modulo: 'KERNEL', acao: 'IDENTITY.USER_LOADED', payload: { id_usuario: idUsuario } })
    return user
  }

  isAuthenticated(): boolean {
    return false
  }

  compose(session: unknown): IdentityRuntimeState {
    const state: IdentityRuntimeState = { loading: false, error: null }

    if (session && typeof session === 'object' && 'idSessao' in session) {
      const s = session as { idUsuario?: IdentityId; idEntidade?: IdentityId }

      if (s.idUsuario) {
        state.user = {
          id: s.idUsuario,
          login: '',
          senha_hash: '',
          ativo: true,
          id_pessoa: s.idEntidade ?? s.idUsuario
        } as UserData
      }

      if (s.idEntidade) {
        state.person = {
          id: s.idEntidade,
          nome: '',
          documento: '',
          email: ''
        } as PersonData
      }
    }

    return state
  }
}
