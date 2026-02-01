# Arquitetura do Frontend - Atendimento

## 📋 Visão Geral

Frontend refatorado com lógica imutável alinhada à estrutura do banco de dados. Nomes simples e diretos, sem prefixos desnecessários.

## 📁 Estrutura de Pastas

```
src/
├── shared/
│   ├── store/
│   │   └── store.js              # Factories, Operações, Validações
│   ├── hooks/
│   │   └── useAtendimento.js     # Hooks: useFFA, useFila, useOrdem
├── context/
│   ├── AtendimentoContext.jsx    # Context com Reducer
│   ├── AuthContext.jsx           # Autenticação
│   └── ContextoAtendimento.jsx   # Contexto de local/unidade
├── services/
│   ├── api.js
│   ├── atendimento.service.js
│   ├── fila.service.js
│   └── ...
└── pages/
    └── operacao/
        ├── Recepcao.jsx
        ├── Medico.jsx
        └── Atendimento.jsx
```

## 🏗️ Componentes Principais

### 1. **EntidadeFactory** - Criação de Entidades

```javascript
import { EntidadeFactory } from '@/shared/store/store';

// Criar FFA
const ffa = EntidadeFactory.ffa({
  id_paciente: 123,
  protocolo: 'ATD-2026-001',
  id_local: 1,
});

// Criar item de fila
const fila = EntidadeFactory.fila({
  id_ffa: ffa.id,
  tipo_evento: 'ATENDIMENTO',
});

// Criar ordem
const ordem = EntidadeFactory.ordem({
  id_ffa: ffa.id,
  tipo: 'MEDICACAO',
  payload: { medicamento: 'Dipirona' },
});
```

### 2. **Operacoes** - Modificar Imutavelmente

```javascript
import { Operacoes } from '@/shared/store/store';

// Alterar status
const ffaAtualizada = Operacoes.alterarStatusFFA(
  ffa,
  'EM_ATENDIMENTO',
  'TRIAGEM'
);

// Chamar na fila
const filaChamada = Operacoes.chamarFilaItem(fila, idUsuario);

// Iniciar fila
const filaIniciada = Operacoes.iniciarFilaItem(fila, idUsuario);
```

### 3. **Colecoes** - Operações com Arrays

```javascript
import { Colecoes } from '@/shared/store/store';

// Adicionar
const novaLista = Colecoes.adicionar(filas, novaFila);

// Remover
const listaAtualizada = Colecoes.remover(filas, idFila, 'id');

// Atualizar
const listaModificada = Colecoes.atualizar(
  filas,
  idFila,
  { status: 'CHAMANDO' },
  'id'
);

// Filtrar
const filtradas = Colecoes.filtrar(filas, f => f.status === 'AGUARDANDO');
```

### 4. **Validacoes** - Regras de Transição

```javascript
import { Validacoes } from '@/shared/store/store';

const valido = Validacoes.transicaoFFAValida('ABERTO', 'EM_ATENDIMENTO');
// true

const invalido = Validacoes.transicaoFFAValida('FINALIZADO', 'ABERTO');
// false
```

### 5. **Historico** - Rastreamento

```javascript
import { Historico } from '@/shared/store/store';

const hist = new Historico();

// Registrar evento
hist.registrarEvento({
  tipo: 'STATUS_CHANGED',
  idFFA: 123,
});

// Registrar snapshot
hist.registrarSnapshot(123, 'FFA', estado, 'UPDATE');

// Obter histórico
const historico = hist.obterHistorico(123);

// Reverter
const estadoAnterior = hist.reverter(123, 1); // 1 passo atrás
```

## 🪝 Hooks Customizados

### **useAtendimento()**

Acesso direto ao contexto:

```javascript
import { useAtendimento } from '@/shared/hooks/useAtendimento';

function MeuComponente() {
  const {
    ffa,
    filaOperacional,
    ordensAssistenciais,
    definirFFA,
    alterarStatusFFA,
    adicionarFila,
    registrarEvento,
    carregando,
    erro,
  } = useAtendimento();

  return <div>{ffa?.protocolo}</div>;
}
```

### **useFFA()**

Gerenciar FFA completo:

```javascript
import { useFFA } from '@/shared/hooks/useAtendimento';

function AberturaAtendimento() {
  const { ffa, iniciar, alterarStatus, alterarPrioridade, finalizar } = useFFA();

  const handleAbrir = async () => {
    await iniciar(pacienteId, especialidadeId);
  };

  const handleMudarStatus = async () => {
    await alterarStatus('EM_ATENDIMENTO', 'TRIAGEM');
  };

  return (
    <>
      <button onClick={handleAbrir}>Abrir Atendimento</button>
      {ffa && (
        <>
          <button onClick={handleMudarStatus}>Em Atendimento</button>
          <button onClick={() => alterarPrioridade('ALTA')}>Priorizar</button>
        </>
      )}
    </>
  );
}
```

### **useFila()**

Gerenciar fila operacional:

```javascript
import { useFila } from '@/shared/hooks/useAtendimento';

function PainelFila() {
  const { fila, chamar, iniciar, finalizar, naoCompareceu } = useFila();

  return (
    <ul>
      {fila.map((item) => (
        <li key={item.id}>
          <button onClick={() => chamar(item.id, userId)}>Chamar</button>
          <button onClick={() => iniciar(item.id, userId)}>Iniciar</button>
          <button onClick={() => finalizar(item.id, userId)}>Finalizar</button>
        </li>
      ))}
    </ul>
  );
}
```

### **useOrdem()**

Gerenciar ordens assistenciais:

```javascript
import { useOrdem } from '@/shared/hooks/useAtendimento';

function CriarOrdem() {
  const { ordens, criar, atualizar, concluir } = useOrdem();

  const handleCriar = async () => {
    await criar(ffaId, 'MEDICACAO', {
      medicamento: 'Dipirona 500mg',
      dose: '1 comprimido',
    });
  };

  return <button onClick={handleCriar}>Criar Ordem</button>;
}
```

### **useAuditoria()**

Acessar auditoria:

```javascript
import { useAuditoria } from '@/shared/hooks/useAtendimento';

function TelaAuditoria() {
  const { eventos, obterHistoricoFFA, obterEventos } = useAuditoria();

  const historico = obterHistoricoFFA(ffaId);
  const evento Modificacoes = obterEventos({ entidade: 'FFA', acao: 'CRIACAO' });

  return <ul>{eventos.map(e => <li>{e.tipo}</li>)}</ul>;
}
```

## 📊 Validações de Transição

### FFA Status

```
ABERTO → [EM_ATENDIMENTO, CANCELADO]
EM_ATENDIMENTO → [EM_OBSERVACAO, INTERNADO, FINALIZADO]
EM_OBSERVACAO → [INTERNADO, FINALIZADO]
INTERNADO → [FINALIZADO, ALTA]
FINALIZADO → []
```

### Fila Status

```
AGUARDANDO → [CHAMANDO, CANCELADO]
CHAMANDO → [EM_EXECUCAO, NAO_COMPARECEU]
EM_EXECUCAO → [FINALIZADO, EM_OBSERVACAO]
EM_OBSERVACAO → [FINALIZADO]
FINALIZADO → []
```

## 🔄 Fluxo Típico

### 1. Abrir Atendimento

```javascript
const { ffa, iniciar } = useFFA();

// Usuário clica
await iniciar(pacienteId, especialidadeId);

// Internamente:
// 1. API POST /atendimento/abrir
// 2. Criar FFA imutável via EntidadeFactory
// 3. Dispatch DEFINIR_FFA
// 4. Registrar evento de auditoria
// 5. Atualizar componente
```

### 2. Gerenciar Fila

```javascript
const { fila, chamar, iniciar } = useFila();

// Chamar próximo
await chamar(filaId, userId);
// Dispatch CHAMAR_FILA → Operacoes.chamarFilaItem

// Iniciar atendimento
await iniciar(filaId, userId);
// Dispatch INICIAR_FILA → Operacoes.iniciarFilaItem
```

### 3. Finalizar

```javascript
const { ffa, finalizar } = useFFA();

await finalizar('ALTA');
// Dispatch FINALIZAR_FFA
// FFA ativo = false, status = FINALIZADO
```

## ✅ Princípios Implementados

- ✅ **Imutabilidade**: Nunca muta estado diretamente
- ✅ **Unidirecionalidade**: Fluxo de dados one-way
- ✅ **Validação**: Transições sempre validadas
- ✅ **Rastreamento**: Histórico completo de mudanças
- ✅ **Simplificidade**: Nomes claros e diretos
- ✅ **Alinhamento**: Estrutura bate com BD

## 🚀 Próximos Passos

1. Refatorar componentes para novos hooks
2. Implementar WebSocket para tempo real
3. Adicionar testes unitários
4. Criar dashboard de auditoria
5. Implementar sincronização offline

---

**Versão**: 2.0  
**Data**: 2026-02-01  
**Status**: Pronto para uso
