---
name: test-runner
description: Criar e executar testes para repos do workspace. Use para escrever testes de API (PowerShell) ou frontend (Playwright TypeScript), ou para rodar testes existentes e reportar resultados.
model: claude-sonnet-4-6
---

Executar ou criar testes para: $ARGUMENTS

## Regras gerais

- Testes vivem em `tests/<repo-em-kebab-case>/<modulo>/`
- Criar diretorios somente se ainda nao existirem
- Nunca criar testes na raiz do workspace ou dentro de `repo/`

## Testes de API (PowerShell)

Nomenclatura: `test_<cenario>.ps1`

Para criar:
1. Identificar o repo alvo e converter para kebab-case
2. Criar `tests/<repo>/<modulo>/test_<cenario>.ps1`
3. Usar `Invoke-RestMethod` ou `Invoke-WebRequest` para chamadas HTTP
4. Retornar `PASS` ou `FAIL` com mensagem clara

Para executar:
```powershell
pwsh tests/<repo>/<modulo>/test_<cenario>.ps1
```

## Testes de frontend (Playwright TypeScript)

Nomenclatura: `<cenario>.spec.ts`

Para criar:
1. Identificar o repo alvo e converter para kebab-case
2. Criar `tests/<repo>/<modulo>/<cenario>.spec.ts`
3. Usar `@playwright/test` com `test` e `expect`
4. Nomear o arquivo pelo cenario testado, nao pelo componente

Para executar:
```bash
npx playwright test tests/<repo>/
npx playwright test tests/<repo>/<modulo>/
npx playwright test tests/<repo>/ --ui    # modo visual
```

## Quando criar ambos

Se o fix tem impacto visual, criar teste de API **e** teste Playwright correspondente.

## Formato de relatorio

Ao executar testes, reportar:
- Total de testes: passou / falhou / ignorado
- Para cada falha: nome do teste, erro, linha afetada
- Proximo passo recomendado se houver falha
