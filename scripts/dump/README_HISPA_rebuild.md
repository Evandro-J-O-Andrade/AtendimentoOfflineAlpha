# HIS/PA – Rebuild do Banco (gerado automaticamente)

Arquivos gerados:

1) **pronto_atendimento_rebuild_full_clean_v2.sql**  
   - Recria o schema completo (tabelas, VWs, SPs, FNs, TRGs) **sem dados de produção** (sem INSERTs do dump).
   - Inclui `DROP DATABASE` + `CREATE DATABASE` + `USE`.
   - Mantém `AUTO_INCREMENT` conforme estava no dump (padrão mysqldump).

2) **pronto_atendimento_seed_minimo_admin.sql** *(opcional)*  
   - Cria registros mínimos (cidade/sistema/unidade/local) + perfis base + usuário `admin` (senha **admin**).
   - Vincula via `usuario_sistema` e `usuario_local_operacional`.

## Contagem de objetos (no rebuild)
- Tabelas: 139
- Views: 28
- Procedures: 109
- Functions: 11
- Triggers: 6

## Correções aplicadas automaticamente
- `fila_senha.id_paciente` passou a aceitar **NULL** (regra: paciente só nasce após a senha).
- `sp_criar_usuario`: troca de coluna `senha` -> `senha_hash` na inserção em `usuario`.
- Ajuste pontual de referência antiga: `UPDATE senha` -> `UPDATE senhas`.

## Observação importante sobre TRIGGERS “extras”
Existem scripts antigos em `scripts/triggers.sql` e `scripts/dump_sps/pronto_atendimento_V2.sql` com TRGs que referenciam campos/tabelas que **não existem no dump atual** (ex.: `fila_senha.status`).  
Por segurança, este rebuild **não injeta TRGs de rascunho/incompatíveis** – ele recria exatamente o que o dump atual contém.

Se você quiser que eu *normalize* o modelo (ex.: mover `status` para `fila_senha`, consolidar `senhas` x `fila_senha`, retirar legado, etc.), isso precisa virar uma **migração versionada** (V3) para não quebrar SPs/VWs já existentes.
