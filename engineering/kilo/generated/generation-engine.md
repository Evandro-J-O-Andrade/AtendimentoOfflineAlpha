# GENERATION ENGINE — KILO v7

## 🎯 OBJETIVO

Gerar automaticamente artefatos de implementação a partir do Knowledge Graph.

---

## 🧩 TEMPLATES DISPONÍVEIS

### SQL PATCH TEMPLATE

```sql
-- {{SP_NAME}}.sql
CREATE PROCEDURE {{sp_name}}(
  {{params}}
)
SQL SECURITY INVOKER
BEGIN
  -- Validation
  CALL sp_sessao_assert(p_id_sessao_usuario);
  
  -- Business Logic
  {{logic}}
  
  -- Event Emission
  CALL sp_kernel_ledger_write(
    UUID(),
    'APP',
    '{{event_action}}',
    '{{entity_type}}',
    p_id_{{entity}},
    JSON_OBJECT(...)
  );
END;
```

### BACKEND CONTROLLER TEMPLATE

```typescript
// {{entity}}.controller.ts
import { Controller, Post, Body, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';

@Controller('{{entity}}')
@ApiTags('{{domain}}')
export class {{Entity}}Controller {
  constructor(private readonly {{entity}}Service: {{Entity}}Service) {}

  @Post()
  @ApiOperation({ summary: 'Create {{entity}}' })
  async create(@Body() dto: Create{{Entity}}DTO) {
    return this.{{entity}}Service.create(dto);
  }
}
```

### REACT HOOK TEMPLATE

```typescript
// use{{Entity}}.ts
export function use{{Entity}}(params: {{Entity}}Params) {
  const query = useQuery(['{{entity}}', params], () => 
    api.get{{Entity}}(params)
  );
  
  const mutate = useMutation((data) => 
    api.create{{Entity}}(data)
  );
  
  return { ...query, mutate };
}
```

### OPENAPI SPEC TEMPLATE

```yaml
paths:
  /api/{{entity}}:
    post:
      summary: Create {{entity}}
      requestBody:
        content:
          application/json:
            schema:
              {{schema_ref}}
      responses:
        '201':
          description: Created
```

---

## 📁 OUTPUT ESTRUTURA

```
generator/
├── sql/
│   ├── sp_senha_emitir.sql
│   ├── sp_sessao_assert.sql
│   └── sp_kernel_ledger_write.sql
├── backend/
│   ├── agenda/
│   │   ├── agenda.controller.ts
│   │   ├── agenda.service.ts
│   │   ├── dto/
│   │   └── entities/
├── frontend/
│   ├── hooks/
│   ├── components/
│   ├── pages/
│   └── stores/
├── openapi/
│   └── agenda.yaml
└── diagrams/
    └── agenda-flow.mmd
```

---

## 🚀 COMANDOS

```bash
# Gerar SP missing
kilo-gen --type sp --name sp_senha_emitir --template canonical

# Gerar backend stub
kilo-gen --type backend --domain agenda --framework nestjs

# Gerar frontend contract
kilo-gen --type frontend --domain agenda --framework react

# Gerar openapi spec
kilo-gen --type openapi --domain agenda
```