# NEW WAVE Enterprise Platform - CONSOLIDATED MEMORY

## 1. ENTIDADE RAIZ
- Pessoa = identidade global única
- Usuario/Paciente/Funcionario = papéis

## 2. FLUXO CANÔNICO
Login → Portal → Context Selector → Dashboard → Apps

## 3. IAM/MODELO
Pessoa → Usuario → Sessão → Contexto → Perfil → Role → Permissão → DECISÃO

## 4. CONTEXTO
- Tenant + Unidade obrigatório
- Dashboard só após contexto

## 5. BANCO
- MySQL source of truth
- SP-first (Stored Procedures)
- Eventos + kernel_ledger

## 6. EVENT DRIVEN
- Tudo gera evento
- Nada é apagado (DELETE)

## 7. ESTRUTURA
engineering/canonical/md (488 MDs)
engineering/canonical/br (25 BRs)
engineering/canonical/front (5 FRONTs)
apps/ (react components)

## 8. LEGACY STRATEGY
KEEP / WRAP / DROP

## 9. REGRAS
- MD congelado
- Portal sempre pós-login
- JWT via HttpOnly cookie
- Derivação > perfeição

## 10. PRÓXIMO
Portal → Context → Dashboard (React + Legacy)