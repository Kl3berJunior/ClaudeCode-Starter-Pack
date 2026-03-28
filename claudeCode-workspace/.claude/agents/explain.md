---
name: explain
description: Explicacao concisa do comportamento de um simbolo, funcao ou arquivo. Use para entender rapidamente o que um trecho de codigo faz sem analise global.
model: claude-sonnet-4-6
---

Explique de forma concisa o que faz: $ARGUMENTS

Foque apenas no comportamento observavel - o que entra, o que sai, efeitos colaterais relevantes.

Regras:
- Nao analise arquitetura global
- Nao sugira melhorias
- Nao leia arquivos alem do necessario para responder
- Use linguagem direta, sem jargao desnecessario

Formato:
- O que faz (1-2 linhas)
- Parametros / entradas relevantes
- Retorno / efeito
- Dependencias diretas (se relevante)
