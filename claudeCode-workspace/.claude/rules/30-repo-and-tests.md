---
paths:
  - "repo/**/*"
  - "tests/**/*"
---

# Regras para repos e testes

- Sempre respeite o `CLAUDE.md` local do repo alvo antes de alterar codigo.
- Em tarefa de codigo dentro de repo conhecido, prefira `serena` para mapear
  simbolos, referencias e pontos de entrada antes de navegar de forma cega.
- Quando houver dependencia externa, SDK ou framework, consulte `context7`
  antes de assumir contratos.
- Quando a mudanca tocar interface, navegacao ou regressao visual, valide com
  `playwright` sempre que o fluxo puder ser exercido localmente.
- Testes do workspace vivem em `tests/<repo>/<modulo>/`, nunca dentro de
  `repo/`.
- Testes de API usam PowerShell com nome `test_<cenario>.ps1`.
- Testes de UI usam Playwright com nome `<cenario>.spec.ts`.
- Se o fix tiver impacto visual, criar teste de API e teste Playwright
  correspondente.
