# Arquitetura Imutável - Documentação Completa

## 📋 Visão Geral

O frontend foi completamente refatorado para seguir os princípios de **imutabilidade** alinhados com a lógica do banco de dados. Isso garante:

- ✅ **Consistência**: Estado nunca é mutado diretamente
- ✅ **Rastreabilidade**: Histórico completo de auditoria
- ✅ **Previsibilidade**: Fluxo de dados unidirecional
- ✅ **Performance**: Otimizações via memoização
- ✅ **Depuração**: Fácil identificação de mudanças

## 📁 Estrutura de Arquivos

```
src/
├── shared/
│   ├── store/
│   │   └── immutable.store.js          # Factories, Reducers, Validações
│   ├── hooks/
│   │   └── useImmutable.js             # Hooks customizados
├── context/
│   ├── ImmutableAtendimentoContext.jsx # Context com Reducer imutável
├── services/
│   ├── atendimento.immutable.service.js # Service refatorado
└── pages/
    └── operacao/
        └── PainelAtendimentoRefatorado.jsx # Exemplo de componente
```

## 🎯 Princípios Fundamentais

### 1. **Nunca mutar estado diretamente**

❌ **ERRADO:**
```javascript
ffa.status = 'EM_ATENDIMENTO'; // Mutação!
```

✅ **CORRETO:**
```javascript
const novaFFA = { ...ffa, status: 'EM_ATENDIMENTO' };
```

### 2. **Validações antes de transições**

```javascript
const isValid = StateValidator.validateFFATransition(
  'ABERTO',
  'EM_ATENDIMENTO'
); // true
```

### 3. **Histórico completo de auditoria**

Cada mudança é rastreada automaticamente:

```javascript
history.recordSnapshot(ffaId, 'FFA', novaFFA, 'UPDATE_STATUS');
history.recordEvent({
  tipo: 'STATUS_CHANGED',
  de: 'ABERTO',
  para: 'EM_ATENDIMENTO',
});
```

## 🏗️ Componentes Principais

### 1. **StateFactory** - Criação de Entidades Imutáveis

```javascript
import { StateFactory } from '@/shared/store/immutable.store';

// Criar FFA
const ffa = StateFactory.createFFA({
  id_paciente: 123,
  protocolo: 'ATD-2026-001',
});

// Criar item de fila
const queueItem = StateFactory.createQueueItem({
  id_ffa: ffa.id,
  tipo_evento: 'PROCESSAMENTO',
});
```

### 2. **StateReducers** - Modificadores Imutáveis

```javascript
import { StateReducers } from '@/shared/store/immutable.store';

// Atualizar status
const ffaAtualizada = StateReducers.updateFFAStatus(
  ffa,
  'EM_ATENDIMENTO',
  'TRIAGEM'
);

// Chamar na fila
const queueCalled = StateReducers.callQueueItem(queueItem, userId);
```

### 3. **ImmutableArray** e **ImmutableObject** - Operações em Coleções

```javascript
import { ImmutableArray, ImmutableObject } from '@/shared/store/immutable.store';

// Adicionar à array (immutável)
const novaFila = ImmutableArray.add(fila, novoItem);

// Remover da array
const filaAtualizada = ImmutableArray.remove(fila, itemId, 'id');

// Atualizar objeto em rota profunda
const novoObj = ImmutableObject.set(obj, 'usuario.nome', 'João');
```

### 4. **ImmutableHistory** - Rastreamento de Mudanças

```javascript
import { ImmutableHistory } from '@/shared/store/immutable.store';

const history = new ImmutableHistory();

// Registrar evento
history.recordEvent({
  tipo: 'STATUS_CHANGED',
  ffaId: 123,
});

// Registrar snapshot
history.recordSnapshot(ffaId, 'FFA', estado, 'UPDATE');

// Recuperar histórico
const historico = history.getHistory(ffaId);

// Reverter para versão anterior
const estadoAnterior = history.rollback(ffaId, 1); // 1 passo atrás
```

## 🪝 Hooks Customizados

### **useImmutableAtendimento()**

Acesso ao contexto com todas as ações:

```javascript
import { useImmutableAtendimento } from '@/shared/hooks/useImmutable';

function MeuComponente() {
  const {
    ffa,
    filaOperacional,
    ordensAssistenciais,
    setFFA,
    updateFFAStatus,
    addQueueItem,
    addAuditEvent,
  } = useImmutableAtendimento();

  return <div>{ffa?.protocolo}</div>;
}
```

### **useFFAFlow()**

Gerenciar fluxo completo de FFA:

```javascript
import { useFFAFlow } from '@/shared/hooks/useImmutable';

function AtendimentoPage() {
  const {
    ffa,
    iniciarAtendimento,
    mudarStatus,
    alterarPrioridade,
    finalizarAtendimento,
  } = useFFAFlow();

  const handleAbrir = async () => {
    await iniciarAtendimento(pacienteId, especialidadeId);
  };

  const handleFinalizar = async () => {
    await finalizarAtendimento('ALTA');
  };

  return (
    <>
      <button onClick={handleAbrir}>Abrir Atendimento</button>
      {ffa && <button onClick={handleFinalizar}>Finalizar</button>}
    </>
  );
}
```

### **useQueueManagement()**

Gerenciar filas operacionais:

```javascript
import { useQueueManagement } from '@/shared/hooks/useImmutable';

function FilaPage() {
  const {
    filaOperacional,
    chamarSenha,
    iniciarFila,
    finalizarFila,
    naoCompareceu,
  } = useQueueManagement();

  return (
    <>
      {filaOperacional.map((item) => (
        <div key={item.id}>
          <button onClick={() => chamarSenha(item.id, userId)}>
            Chamar
          </button>
        </div>
      ))}
    </>
  );
}
```

### **useOrderManagement()**

Gerenciar ordens assistenciais:

```javascript
import { useOrderManagement } from '@/shared/hooks/useImmutable';

function OrdenPage() {
  const {
    ordensAssistenciais,
    criarOrdem,
    atualizarOrdem,
    concluirOrdem,
  } = useOrderManagement();

  const handleCriar = async () => {
    await criarOrdem(ffaId, 'MEDICACAO', {
      medicamento: 'Dipirona 500mg',
      dose: '1 comprimido',
    });
  };

  return <button onClick={handleCriar}>Criar Ordem</button>;
}
```

### **useAuditTrail()**

Acessar histórico de auditoria:

```javascript
import { useAuditTrail } from '@/shared/hooks/useImmutable';

function AuditoriaPage() {
  const { eventos, getFFAHistory, getAuditEvents } = useAuditTrail();

  const historico = getFFAHistory(ffaId);
  const eventos = getAuditEvents({ entidade: 'FFA' });

  return (
    <ul>
      {historico.map((evt) => (
        <li key={evt.id}>{evt.action} - {evt.timestamp}</li>
      ))}
    </ul>
  );
}
```

## 📊 Validações de Transição

### FFA Status Transitions

```
ABERTO → [EM_ATENDIMENTO, CANCELADO]
EM_ATENDIMENTO → [EM_OBSERVACAO, INTERNADO, FINALIZADO]
EM_OBSERVACAO → [INTERNADO, FINALIZADO]
INTERNADO → [FINALIZADO, ALTA]
FINALIZADO → []
```

### Queue Status Transitions

```
AGUARDANDO → [CHAMANDO, CANCELADO]
CHAMANDO → [EM_EXECUCAO, NAO_COMPARECEU]
EM_EXECUCAO → [FINALIZADO, EM_OBSERVACAO]
EM_OBSERVACAO → [FINALIZADO]
FINALIZADO → []
```

## 🔄 Fluxo de Operação

### 1. **Abrir Atendimento**

```javascript
// Hook captura os dados
const { iniciarAtendimento, ffa } = useFFAFlow();

// Usuário clica no botão
await iniciarAtendimento(pacienteId, especialidadeId);

// Internamente:
// 1. Faz chamada à API
// 2. Cria FFA imutável
// 3. Atualiza state via dispatch
// 4. Registra evento de auditoria
// 5. Atualiza componente
```

### 2. **Mudar Status**

```javascript
await mudarStatus('EM_ATENDIMENTO', 'TRIAGEM');

// Internamente:
// 1. Valida transição
// 2. Faz chamada à API
// 3. Cria novo estado (não muta o antigo)
// 4. Registra snapshot no histórico
// 5. Dispara evento de auditoria
// 6. Atualiza componente reactivamente
```

### 3. **Finalizar Atendimento**

```javascript
await finalizarAtendimento('ALTA');

// Internamente:
// 1. Valida estado
// 2. Faz chamada à API
// 3. Atualiza status para FINALIZADO
// 4. Arquiva FFA (ativo = false)
// 5. Registra conclusão na auditoria
// 6. Limpa estado local
```

## 🎯 Padrões de Uso

### Exemplo 1: Listar FFAs com Filtro

```javascript
import { useImmutableAtendimento } from '@/shared/hooks/useImmutable';

function ListaAtendimentos() {
  const { filaOperacional } = useImmutableAtendimento();
  
  // Filtrar de forma imutável
  const atendimentosAltos = filaOperacional.filter(
    (item) => item.prioridade === 'ALTA'
  );

  return (
    <ul>
      {atendimentosAltos.map((item) => (
        <li key={item.id}>{item.paciente}</li>
      ))}
    </ul>
  );
}
```

### Exemplo 2: Atualizar com Validação

```javascript
async function handleAlterarPrioridade(novaPrioridade) {
  try {
    await alterarPrioridade(novaPrioridade);
    // Se chegou aqui, foi com sucesso (imutavelmente)
  } catch (err) {
    // Tratamento de erro
    console.error('Não foi possível alterar prioridade', err);
  }
}
```

### Exemplo 3: Acompanhar Mudanças em Tempo Real

```javascript
useEffect(() => {
  // Sempre que FFA muda, atualiza histórico
  if (ffa?.id) {
    const history = getFFAHistory(ffa.id);
    console.log('Histórico de mudanças:', history);
  }
}, [ffa, getFFAHistory]);
```

## 🚀 Performance

A arquitetura imutável oferece benefícios de performance:

### Memoização Automática

```javascript
// Componentes que recebem mesmos props não re-renderizam
const ListaFilas = React.memo(({ filaOperacional }) => {
  return <div>{filaOperacional.map(...)}</div>;
});
```

### Recomputação Eficiente

```javascript
// useMemo garante que só recomputa se dependência muda
const atendimentosOrdenados = useMemo(
  () => [...filaOperacional].sort((a, b) => a.prioridade - b.prioridade),
  [filaOperacional] // Só se filaOperacional for um novo array
);
```

## 📋 Checklist de Migração

- [ ] Substituir contextos antigos pelo `ImmutableAtendimentoContext`
- [ ] Atualizar services para usar `immutable.service.js`
- [ ] Refatorar componentes para usar novos hooks
- [ ] Remover manipulações diretas de estado
- [ ] Adicionar testes para transições de estado
- [ ] Validar auditoria em pontos críticos
- [ ] Treinar equipe em novo padrão

## 🔧 Troubleshooting

### Erro: "State não pode ser modificado"

**Causa**: Tentativa de mutar estado imutável

**Solução**:
```javascript
// ❌ Errado
ffa.status = 'EM_ATENDIMENTO';

// ✅ Correto
const novaFFA = { ...ffa, status: 'EM_ATENDIMENTO' };
```

### Erro: "Transição inválida"

**Causa**: Tentativa de transição não permitida

**Solução**: Verificar diagrama de transições e usar o status correto

### Performance Ruim

**Causa**: Re-renders desnecessários

**Solução**: Envolver componentes com `React.memo` e usar `useMemo`

## 📚 Recursos Adicionais

- [Immutable.js](https://immutable-js.github.io/immutable-js/)
- [Redux Architecture](https://redux.js.org/)
- [React Hooks](https://react.dev/reference/react/hooks)

## ✅ Próximos Passos

1. Refatorar todos os componentes seguindo padrão
2. Implementar testes unitários para reducers
3. Adicionar WebSocket para atualizações em tempo real
4. Criar dashboard de auditoria
5. Implementar backup/restore de estado

---

**Versão**: 1.0  
**Data**: 2026-02-01  
**Autor**: Equipe de Desenvolvimento
