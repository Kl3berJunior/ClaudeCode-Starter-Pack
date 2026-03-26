# CLAUDE.md - Repo `__REPO_NAME__`

Este arquivo governa como o Claude Code deve atuar neste repositorio.

## Antes de alterar codigo

- ler este arquivo
- localizar os comandos de validacao abaixo
- confirmar branch atual e risco da mudanca

## Regras minimas

- nao reverter trabalho alheio
- nao commitar sem instrucao clara
- validar o que foi alterado
- registrar risco relevante no artefato final

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
