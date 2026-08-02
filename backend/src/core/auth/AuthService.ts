import { getDatabasePool } from '@backend/database/mysql/connection'
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import type { AuthLoginResponse, AuthSessionResponse, AuthContextResponse } from '@backend/shared/types/auth'

export class AuthService {
  private connection = getDatabasePool()

  async login(login: string, tokenJwt: string, refreshToken: string, ip: string, device: string) {
    const conn = await this.connection
    const payload = JSON.stringify({
      login,
      token_jwt: tokenJwt,
      refresh_token: refreshToken,
      ip,
      device,
      fingerprint: device
    })

    await conn.query('SET @p_resultado = NULL, @p_sucesso = NULL, @p_mensagem = NULL')
    const [rows] = await conn.query('CALL sp_master_login(?, ?, @p_resultado, @p_sucesso, @p_mensagem)', [
      'AUTH.LOGIN.REQUEST',
      payload
    ])

    const [outRows] = await conn.query('SELECT @p_resultado AS resultado, @p_sucesso AS sucesso, @p_mensagem AS mensagem')
    const resultado = (outRows as any[])[0]
    const sucesso = Boolean(resultado?.sucesso)

    if (!sucesso) {
      return {
        authenticated: false,
        state: 'ERROR' as const,
        message: resultado?.mensagem ?? 'LOGIN_FAILED'
      }
    }

    const parsed = typeof resultado?.resultado === 'string'
      ? JSON.parse(resultado.resultado)
      : (resultado?.resultado ?? {})

    const sessao = parsed?.sessao ?? {}
    const session = {
      id_sessao_usuario: Number(sessao?.id_sessao_usuario ?? 0),
      id_usuario: Number(sessao?.id_usuario ?? 0),
      id_entidade: Number(sessao?.id_entidade ?? 0),
      id_unidade: Number(sessao?.id_unidade ?? 0),
      id_local: Number(sessao?.id_local ?? 0),
      id_perfil: Number(sessao?.id_perfil ?? 0),
      token_jwt: String(sessao?.token_jwt ?? ''),
      refresh_token: String(sessao?.refresh_token ?? ''),
      expira_em: new Date(sessao?.expira_em ?? Date.now())
    }

    return {
      authenticated: true,
      session,
      state: 'AUTHENTICATED' as const
    }
  }

  async authenticate(username: string, password: string, ip: string, device: string) {
    const conn = await this.connection
    const [rows] = await conn.query(
      'SELECT id_usuario, senha_hash, ativo FROM usuario WHERE login = ? LIMIT 1',
      [username]
    )
    const user = (rows as any[])[0]

    if (!user) {
      return { authenticated: false, state: 'ERROR' as const, message: 'USUARIO_NAO_ENCONTRADO' }
    }
    if (Number(user.ativo) !== 1) {
      return { authenticated: false, state: 'ERROR' as const, message: 'USUARIO_INATIVO' }
    }

    const senhaOk = await bcrypt.compare(password, String(user.senha_hash ?? ''))
    if (!senhaOk) {
      return { authenticated: false, state: 'ERROR' as const, message: 'CREDENCIAIS_INVALIDAS' }
    }

    const token = jwt.sign(
      { sub: Number(user.id_usuario), login: username },
      process.env.JWT_SECRET ?? 'dev-secret-atendimento-offline',
      { expiresIn: '24h' }
    )

    return this.login(username, token, '', ip, device)
  }

  async session(idSessao: number) {
    const conn = await this.connection
    try {
      const [rows] = await conn.query('CALL sp_sessao_contexto_get(?)', [idSessao])
      const data = ((rows as any[])[0] as any[])[0]
      
      if (!data) {
        return null
      }
      const result = {
        id_sessao_usuario: Number(data.id_sessao_usuario),
        id_usuario: Number(data.id_usuario),
        id_entidade: Number(data.id_sistema ?? 0),
        id_unidade: Number(data.id_unidade),
        id_local: Number(data.id_local_operacional ?? 0),
        id_perfil: Number(data.id_perfil ?? 0),
        expira_em: new Date(data.expira_em ?? Date.now()),
        ativo: Number(data.ativo ?? 0)
      } as AuthSessionResponse
      
      return result
    } catch (error) {
      console.error('SESSION_ERROR', error)
      throw error
    }
  }

  async context(idSessao: number) {
    const conn = await this.connection
    try {
      const [result] = await conn.query('CALL sp_auth_contexto_get(?)', [idSessao])
      const unidades = (((result as any)[0] as any[]) ?? []).map((u: any) => ({ id_unidade: Number(u.id_unidade), nome_unidade: String(u.nome_unidade) }))
      const perfis = (((result as any)[1] as any[]) ?? []).map((p: any) => ({ id_perfil: Number(p.id_perfil), nome_perfil: String(p.nome_perfil), id_unidade: Number(p.id_unidade) }))
      const salas = (((result as any)[2] as any[]) ?? []).map((s: any) => ({ id_sala: Number(s.id_sala), nome_sala: String(s.nome_sala), id_unidade: Number(s.id_unidade) }))

      return {
        unidades,
        perfis,
        salas
      } as AuthContextResponse
    } catch (error) {
      console.error('CONTEXT_ERROR', error)
      throw error
    }
  }

  async selectContext(idSessao: number, idUnidade: number, idPerfil: number, idLocal: number) {
    const conn = await this.connection
    try {
      const [result] = await conn.query('CALL sp_auth_contexto_set(?, ?, ?, ?)', [idSessao, idUnidade, idPerfil, idLocal])
      const data = ((result as any)[0] as any[])[0]
      if (!data) {
        return null
      }
      return {
        id_sessao_usuario: Number(data.id_sessao_usuario),
        id_usuario: Number(data.id_usuario),
        id_entidade: Number(data.id_sistema ?? 0),
        id_unidade: Number(data.id_unidade),
        id_local: Number(data.id_local_operacional ?? 0),
        id_perfil: Number(data.id_perfil ?? 0),
        expira_em: new Date(data.expira_em ?? Date.now()),
        ativo: Number(data.ativo ?? 0)
      } as any
    } catch (error) {
      console.error('SELECT_CONTEXT_ERROR', error)
      throw error
    }
  }
}

export const authService = new AuthService()
