describe('Gestão de Usuários - permissões', () => {
  beforeEach(() => {
    // intercepta perfis
    cy.intercept('GET', '/api/perfil_lista.php', [
      { id_perfil: 1, nome: 'ADMIN' },
      { id_perfil: 2, nome: 'SUPORTE' },
      { id_perfil: 3, nome: 'MEDICO' }
    ]).as('getPerfis')
  })

  it('redireciona não autenticado para /login', () => {
    cy.clearLocalStorage()
    cy.visit('/admin/usuarios')
    cy.url().should('include', '/login')
  })

  it('permite ADMIN acessar a página', () => {
    const user = { perfis: ['ADMIN'] }
    window.localStorage.setItem('token', 'fake-token')
    window.localStorage.setItem('user', JSON.stringify(user))
    cy.visit('/admin/usuarios')
    cy.contains('Gestão de Usuários')
  })

  it('permite SUPORTE acessar a página', () => {
    const user = { perfis: ['SUPORTE'] }
    window.localStorage.setItem('token', 'fake-token')
    window.localStorage.setItem('user', JSON.stringify(user))
    cy.visit('/admin/usuarios')
    cy.contains('Gestão de Usuários')
  })

  it('bloqueia perfis não autorizados', () => {
    const user = { perfis: ['MEDICO'] }
    window.localStorage.setItem('token', 'fake-token')
    window.localStorage.setItem('user', JSON.stringify(user))
    cy.visit('/admin/usuarios')
    cy.contains('Você não tem permissão')
  })

  it('cria usuário (API stubbed) e atualiza lista', () => {
    const admin = { perfis: ['ADMIN'] }
    window.localStorage.setItem('token', 'fake-token')
    window.localStorage.setItem('user', JSON.stringify(admin))

    // Resposta do POST de criação
    cy.intercept('POST', '/api/usuario_criar.php', { ok: true, id_usuario: 999 }).as('postCreate')

    // Após criação, a listagem retorna um usuário novo
    cy.intercept('GET', '/api/usuario_listar.php', {
      ok: true,
      usuarios: [
        { id_usuario: 999, login: 'novo', nome_completo: 'Usuário Novo', perfis: ['SUPORTE'], ativo: 1 }
      ]
    }).as('getUsuarios')

    cy.visit('/admin/usuarios')

    cy.get('input[placeholder="Nome"]').type('Usuário Novo')
    cy.get('input[placeholder="CPF"]').type('00000000000')
    cy.get('input[placeholder="Login"]').type('novo')
    cy.get('input[placeholder="Senha inicial"]').type('senha123')
    cy.get('select').select('2') // SUPORTE

    cy.contains('Criar').click()

    cy.wait('@postCreate')
    cy.wait('@getUsuarios')

    cy.contains('Usuário Novo')
    cy.contains('novo')
  })
})
