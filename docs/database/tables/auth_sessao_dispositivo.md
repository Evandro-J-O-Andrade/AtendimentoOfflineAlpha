# auth_sessao_dispositivo

Objetivo: Registrar dispositivos confiáveis utilizados pelos usuários para autenticação.
Descrição: Tabela que mantiene o registro de dispositivos conhecidos pelos usuários, permitindo reconhecimento de dispositivos confiáveis e detecção de login em novos dispositivos.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_dispositivo_confiavel | bigint | NOT NULL | - | Identificador único do registro, chave primária auto incrementada. |
| id_usuario | bigint | NOT NULL | - | Referência ao usuário dono do dispositivo. |
| dispositivo_hash | varchar(255) | NOT NULL | - | Hash único que identifica o dispositivo. |
| nome_dispositivo | varchar(100) | Nullable | - | Nome amigável do dispositivo (ex: "iPhone João", "Desktop Maria"). |
| sistema_operacional | varchar(50) | Nullable | - | Sistema operacional do dispositivo (ex: Windows, macOS, iOS, Android). |
| navegador | varchar(50) | Nullable | - | Navegador utilizado para login (ex: Chrome, Firefox, Safari). |
| ultimo_ip | varchar(45) | Nullable | - | Último IP de acesso com este dispositivo. |
| ultimo_acesso | datetime | Nullable | CURRENT_TIMESTAMP | Data e hora do último acesso com este dispositivo. |
| primeiro_acesso | datetime | Nullable | CURRENT_TIMESTAMP | Data e hora do primeiro registro do dispositivo. |
| confiavel | tinyint(1) | Nullable | '0' | Indicador se o dispositivo é marcado como confiável. |
| ativo | tinyint(1) | Nullable | '1' | Indicador se o registro está ativo. |
| id_entidade | bigint unsigned | NOT NULL | - | Referência à entidade (organização) à qual o registro pertence. |

## Chaves
- Primária: id_dispositivo_confiavel
- Únicas: nenhuma
- Estrangeiras:
  - fk_dispositivo_usuario: id_usuario → usuario (id_usuario) - Relacionamento N:1, deleta em cascata

## Índices
- PRIMARY KEY (id_dispositivo_confiavel)
- KEY idx_dispositivo_usuario (id_usuario)
- KEY idx_dispositivo_hash (dispositivo_hash)

## Constraints
- PRIMARY KEY: id_dispositivo_confiavel
- FOREIGN KEY: fk_dispositivo_usuario (id_usuario) REFERENCES usuario (id_usuario) ON DELETE CASCADE

## Relacionamentos e Cardinalidade
- N:1 com usuario (id_usuario) - muitos dispositivos podem pertencer a um usuário
- N:1 com saas_entidade (id_entidade)

## Dependências
- Tabelas que dependem desta: nenhuma
- Dependência desta tabela: usuario, saas_entidade

## Fluxo de utilização dentro do sistema
- Criado automaticamente na primeira autenticação com um dispositivo
- Usado para notificar usuário de login em dispositivo desconhecido
- Permite marcar dispositivos como confiáveis para não gerar alertas
- Ajudada para detectar ataques de credencial stuffing