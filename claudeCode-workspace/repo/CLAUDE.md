# CLAUDE.md - Repo `__REPO_NAME__`

Este arquivo governa como o Claude Code deve atuar neste repositorio.

## Antes de alterar codigo

- ler este arquivo
- localizar os comandos de validacao abaixo
- confirmar branch atual e risco da mudanca
- usar `serena` para mapear simbolos, referencias e pontos de entrada quando isso acelerar entendimento do repo
- usar `context7` antes de assumir comportamento de dependencia, SDK ou framework externo
- usar `playwright` para validar fluxo web e regressao visual quando a mudanca tocar interface ou navegacao

## Regras minimas

- nao reverter trabalho alheio
- nao commitar sem instrucao clara
- validar o que foi alterado
- registrar risco relevante no artefato final

## Prioridade de ferramentas

- primeiro a estrutura real do repo
- depois o MCP mais aderente ao problema
- depois shell e busca textual como apoio

Objetivo: reduzir leitura cega, aumentar validacao e usar a ferramenta certa para cada tipo de evidencia.

## Validacao local

- build: `__BUILD_COMMAND__`
- test: `__TEST_COMMAND__`
- lint: `__LINT_COMMAND__`

## Limites

- pedir confirmacao antes de publicar, fazer push ou mexer em ambiente externo
- nao alterar segredo, pipeline ou deploy sem explicitar impacto

## Relatorios

Artefatos deste repo vivem em:

- `__WORKSPACE_ROOT__/Relatorios/__REPO_NAME__/`
