# seed_usuarios_teste

Objetivo: seed usuarios teste conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| - | - | - | nenhum parÃ¢metro declarado. |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: usuario, usuario_contexto, usuario_local_operacional, usuario_perfil, usuario_sistema, usuario_unidade
- INSERT: usuario
- UPDATE: (nenhuma)
- DELETE: usuario, usuario_contexto, usuario_local_operacional, usuario_perfil, usuario_sistema, usuario_unidade

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT
- FLOOR
- NOW
- RAND

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- (nenhum)

## Tratamento de Erros

- Sem Tratamento de erro explicito detectado.

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: nao detectado
- Commit: nao detectado

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: inicio do bloco de execucao.
- **Linha 3**: Declaracao de variavel local i.
- **Linha 4**: Declaracao de variavel local nome.
- **Linha 5**: Declaracao de variavel local login_valor.
- **Linha 6**: Declaracao de variavel local perfil_id.
- **Linha 8** (Comentario): Limpar usuários de teste anteriores (manter admin)
- **Linha 9**: Remove registros da tabela usuario.
- **Linha 10**: Remove registros da tabela usuario_perfil.
- **Linha 11**: Remove registros da tabela usuario_unidade.
- **Linha 12**: Remove registros da tabela usuario_sistema.
- **Linha 13**: Remove registros da tabela usuario_local_operacional.
- **Linha 14**: Remove registros da tabela usuario_contexto.
- **Linha 16** (Comentario): Loop para criar 500 usuários
- **Linha 17**: Estrutura de repeticao/controle de loop.
- **Linha 18** (Comentario): Gerar nome aleatório
- **Linha 19**: atribuicao de valor Ã  variavel nome.
- **Linha 20**: ELT(FLOOR(1 + RAND() * 10), 'João', 'Maria', 'José', 'Ana', 'Pedro', 'Paulo', 'Lucas', 'Fernanda', 'Carla', 'Roberto'),
- **Linha 21**: ' ',
- **Linha 22**: ELT(FLOOR(1 + RAND() * 15), 'Silva', 'Santos', 'Oliveira', 'Souza', 'Lima', 'Pereira', 'Almeida', 'Nascimento', 'Melo', 'Costa', 'Rodrigues', 'Ferreira', 'Araujo', 'Cardoso', 'Teixeira')
- **Linha 23**: );
- **Linha 25** (Comentario): Gerar login
- **Linha 26**: atribuicao de valor Ã  variavel login_valor.
- **Linha 27**: ELT(FLOOR(1 + RAND() * 6), 'medico', 'enfermeiro', 'recepcionista', 'tecnico', 'farmaceutico', 'admin'),
- **Linha 28**: LPAD(i, 4, '0')
- **Linha 29**: );
- **Linha 31** (Comentario): Atribuir perfil baseado no tipo
- **Linha 32**: atribuicao de valor Ã  variavel perfil_id.
- **Linha 34** (Comentario): Inserir usuário
- **Linha 35**: Insere um novo registro na tabela usuario.
- **Linha 36**: VALUES (
- **Linha 37**: i + 1,
- **Linha 38**: nome,
- **Linha 39**: login_valor,
- **Linha 40**: '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a', -- senha: admin123
- **Linha 41**: CONCAT(login_valor, '@hospital.com'),
- **Linha 42**: 1,
- **Linha 43**: NOW()
- **Linha 44**: );
- **Linha 46** (Comentario): Vincular a unidade 1 (UPA)
- **Linha 47**: INSERT IGNORE INTO usuario_unidade (id_usuario, id_unidade, ativo)
- **Linha 48**: VALUES (i + 1, 1, 1);
- **Linha 50** (Comentario): Vincular ao sistema 1
- **Linha 51**: INSERT IGNORE INTO usuario_sistema (id_usuario_sistema, id_usuario, id_sistema, id_perfil, ativo)
- **Linha 52**: VALUES (i + 1, i + 1, 1, perfil_id, 1);
- **Linha 54** (Comentario): Vincular a um local operacional
- **Linha 55**: INSERT IGNORE INTO usuario_local_operacional (id_usuario, id_local_operacional)
- **Linha 56**: VALUES (i + 1, FLOOR(1 + RAND() * 20));
- **Linha 58**: atribuicao de valor Ã  variavel i.
- **Linha 59**: END WHILE;
- **Linha 61**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `seed_usuarios_teste`()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE nome VARCHAR(100);
    DECLARE login_valor VARCHAR(50);
    DECLARE perfil_id INT;
    
    -- Limpar usuários de teste anteriores (manter admin)
    DELETE FROM usuario WHERE login != 'admin';
    DELETE FROM usuario_perfil WHERE id_usuario > 1;
    DELETE FROM usuario_unidade WHERE id_usuario > 1;
    DELETE FROM usuario_sistema WHERE id_usuario > 1;
    DELETE FROM usuario_local_operacional WHERE id_usuario > 1;
    DELETE FROM usuario_contexto WHERE id_usuario > 1;
    
    -- Loop para criar 500 usuários
    WHILE i <= 500 DO
        -- Gerar nome aleatório
        SET nome = CONCAT(
            ELT(FLOOR(1 + RAND() * 10), 'João', 'Maria', 'José', 'Ana', 'Pedro', 'Paulo', 'Lucas', 'Fernanda', 'Carla', 'Roberto'),
            ' ',
            ELT(FLOOR(1 + RAND() * 15), 'Silva', 'Santos', 'Oliveira', 'Souza', 'Lima', 'Pereira', 'Almeida', 'Nascimento', 'Melo', 'Costa', 'Rodrigues', 'Ferreira', 'Araujo', 'Cardoso', 'Teixeira')
        );
        
        -- Gerar login
        SET login_valor = CONCAT(
            ELT(FLOOR(1 + RAND() * 6), 'medico', 'enfermeiro', 'recepcionista', 'tecnico', 'farmaceutico', 'admin'),
            LPAD(i, 4, '0')
        );
        
        -- Atribuir perfil baseado no tipo
        SET perfil_id = ELT(FLOOR(1 + RAND() * 6), 2, 3, 4, 5, 6, 1); -- MEDICO, ENFERMEIRO, RECEPCIONISTA, TECNICO, FARMACEUTICO, ADMIN
        
        -- Inserir usuário
        INSERT INTO usuario (id_usuario, nome, login, senha_hash, email, ativo, criado_em)
        VALUES (
            i + 1,
            nome,
            login_valor,
            '$2a$10$N9qo8uLOickgx2ZMRZoMy.MqrqQlC8kCXVvXtHjXMqqGNmuprJf0a', -- senha: admin123
            CONCAT(login_valor, '@hospital.com'),
            1,
            NOW()
        );
        
        -- Vincular a unidade 1 (UPA)
        INSERT IGNORE INTO usuario_unidade (id_usuario, id_unidade, ativo)
        VALUES (i + 1, 1, 1);
        
        -- Vincular ao sistema 1
        INSERT IGNORE INTO usuario_sistema (id_usuario_sistema, id_usuario, id_sistema, id_perfil, ativo)
        VALUES (i + 1, i + 1, 1, perfil_id, 1);
        
        -- Vincular a um local operacional
        INSERT IGNORE INTO usuario_local_operacional (id_usuario, id_local_operacional)
        VALUES (i + 1, FLOOR(1 + RAND() * 20));
        
        SET i = i + 1;
    END WHILE;

END ;;
```

