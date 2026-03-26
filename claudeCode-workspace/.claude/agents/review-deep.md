---
name: review-deep
description: Analise arquitetural profunda de arquivos ou módulos. Use para identificar problemas de design, acoplamento, risco e propor refatorações com localização exata.
model: claude-opus-4-6
tools:
  - Read
  - Grep
  - Glob
---

Analise profundamente o código em: $ARGUMENTS

1. Mapear a estrutura do arquivo ou módulo (use serena para símbolos se disponível)
2. Identificar problemas arquiteturais, acoplamento excessivo ou violações de padrão
3. Avaliar legibilidade, complexidade ciclomática e pontos de risco
4. Propor refatorações concretas com justificativa
5. Verificar se há testes cobrindo os pontos críticos

Formato de saída:
- Resumo executivo (3-5 linhas)
- Problemas encontrados (prioridade: alta / média / baixa)
- Sugestões de refatoração com localização exata (arquivo:linha)
- Próximos passos recomendados

Não modifique nenhum arquivo. Apenas analise e reporte.
