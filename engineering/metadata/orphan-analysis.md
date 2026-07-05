# ORPHAN ANALYSIS

## 📊 Status

| Status | Count | % |
|--------|-------|-----|
| Com FK | 283 | 59% |
| Órfãos | 195 | 41% |
| Total | 478 | 100% |

## 🔗 Principais Relacionamentos

| De → Para | Count | Criticidade |
|-----------|-------|-------------|
| HIS → HIS | 68 | Crítica |
| Unknown → Unknown | 53 | Alta |
| Runtime → HIS | 12 | Alta |
| Runtime → Core | 16 | Alta |
| Unknown → Core | 38 | Média |

## 🚨 Órfãos por Domínio

| Domínio | Órfãos | Ação |
|---------|--------|------|
| Unknown | ~120 | Reclassificar |
| HIS/Farmacia | ~10 | Verificar FKs faltantes |
| SAC | ~2 | Verificar FKs faltantes |

## 📋 Próximo

1. Reclassificar Unknown
2. Validar FKs manualmente
3. Gerar workflow-graph