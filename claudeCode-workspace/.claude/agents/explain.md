---
name: explain
description: Explicação concisa do comportamento de um símbolo, função ou arquivo. Use para entender rapidamente o que um trecho de código faz sem análise global.
model: claude-sonnet-4-6
---

Explique de forma concisa o que faz: $ARGUMENTS

Foque apenas no comportamento observável — o que entra, o que sai, efeitos colaterais relevantes.

Regras:
- Não analise arquitetura global
- Não sugira melhorias
- Não leia arquivos além do necessário para responder
- Use linguagem direta, sem jargão desnecessário

Formato:
- O que faz (1-2 linhas)
- Parâmetros / entradas relevantes
- Retorno / efeito
- Dependências diretas (se relevante)
