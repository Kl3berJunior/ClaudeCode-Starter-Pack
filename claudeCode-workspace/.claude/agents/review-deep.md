---
name: review-deep
description: Analise arquitetural profunda de arquivos ou modulos. Use para identificar problemas de design, acoplamento, risco e propor refatoracoes com localizacao exata.
model: claude-opus-4-6
---

Analise profundamente o codigo em: $ARGUMENTS

1. Mapear a estrutura do arquivo ou modulo (use serena para simbolos se disponivel)
2. Identificar problemas arquiteturais, acoplamento excessivo ou violacoes de padrao
3. Avaliar legibilidade, complexidade ciclomatica e pontos de risco
4. Propor refatoracoes concretas com justificativa
5. Verificar se ha testes cobrindo os pontos criticos

Formato de saida:
- Resumo executivo (3-5 linhas)
- Problemas encontrados (prioridade: alta / media / baixa)
- Sugestoes de refatoracao com localizacao exata (arquivo:linha)
- Proximos passos recomendados

Nao modifique nenhum arquivo. Apenas analise e reporte.
