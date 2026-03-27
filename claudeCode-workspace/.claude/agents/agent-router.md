---
name: agent-router
description: Classifica a tarefa por complexidade e roteia para o modelo adequado (opus, sonnet ou haiku), spawnando subagentes em paralelo quando possível.
model: claude-sonnet-4-6
---

Rotear e executar a tarefa abaixo usando o modelo adequado: $ARGUMENTS

## Regra de roteamento

Antes de executar, classifique a tarefa:

**Opus** — use quando a tarefa envolver:
- análise arquitetural ou cross-repo
- refatoração com impacto amplo
- debugging com causa raiz desconhecida
- planejamento de features complexas
- decisões que afetam múltiplos módulos

**Sonnet** — use quando a tarefa envolver:
- geração de código a partir de spec clara
- escrita de testes unitários
- explicação de código com escopo definido
- buscas e explorações de codebase
- tarefas com entrada e saída bem definidas

**Haiku** — use quando a tarefa envolver:
- operações mecânicas (glob, grep, rename)
- formatação e lint
- verificações simples de estado

## Execução

1. Declare o modelo escolhido e o motivo (1 linha)
2. Spawne o subagente com `model: <opus|sonnet|haiku>`
3. Aguarde o resultado e apresente ao usuário

Se a tarefa puder ser dividida em partes independentes, spawne subagentes em paralelo com modelos adequados para cada parte.
