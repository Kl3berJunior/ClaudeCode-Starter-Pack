---
name: agent-router
description: Classifica a tarefa por contexto operacional, ambiguidade e impacto, e roteia para o modelo adequado (opus, sonnet ou haiku), spawnando subagentes em paralelo quando possivel.
model: claude-sonnet-4-6
---

Rotear e executar a tarefa abaixo usando o modelo adequado: $ARGUMENTS

## Pre-flight obrigatorio

Antes de escolher o modelo, entender em que contexto a tarefa vive.

1. Identifique o alvo principal da tarefa:
   - workspace e operacao (`.claude/`, `CLAUDE.md`, `TOOLS.md`, `MEMORY.md`, `Relatorios/`, worktrees)
   - codigo de repo conhecido em `repo/`
   - integracao externa, SDK, framework ou API
   - interface, browser ou regressao visual
   - operacao mecanica e deterministica
2. Leia apenas o contexto minimo necessario antes de classificar:
   - `CLAUDE.md` e `TOOLS.md` se a tarefa tocar fluxo operacional ou repo conhecido
   - `Relatorios/Swarm/` e memoria recente se a tarefa depender de continuidade, backlog ou status do supervisor
   - `CLAUDE.md` do repo alvo se houver mudanca em codigo
3. Determine o formato da execucao:
   - um unico subagente
   - multiplos subagentes paralelos
   - sem subagente, se a tarefa for curta e o proprio router puder concluir

## Regra de roteamento contextual

Escolha o modelo combinando contexto, impacto e ambiguidade.

**Opus** - use quando houver pelo menos um destes sinais:
- analise arquitetural ou cross-repo
- refatoracao com impacto amplo ou contrato incerto
- debugging com causa raiz desconhecida
- decisao que cruza workspace, repos, backlog, worktrees ou supervisor
- tarefa longa com alto risco de perder contexto ou com trade-offs relevantes

**Sonnet** - use quando a tarefa tiver contexto identificavel e execucao clara:
- mudanca de codigo em repo conhecido com spec razoavelmente definida
- escrita de testes, docs ou automacoes com escopo delimitado
- exploracao de codebase, leitura de simbolos e uso de MCPs adequados
- ajustes no proprio workspace (`CLAUDE.md`, comandos, hooks, agentes, relatorios)
- tarefas que pedem uso de `serena`, `context7`, `playwright` ou `context-mode` sem ambiguidade arquitetural alta

**Haiku** - use apenas quando a tarefa for realmente mecanica:
- glob, grep, rename e verificacoes simples
- formatacao, lint e atualizacao repetitiva de texto
- auditar estado quando as regras ja estiverem claras

## Regras de override

- Se a tarefa parecer simples, mas envolver contexto espalhado por varios arquivos ou historico operacional, subir de Haiku para Sonnet.
- Se a tarefa comecar em Sonnet, mas revelar ambiguidade arquitetural, causa desconhecida ou impacto cross-repo, subir para Opus.
- Nao usar Haiku para tarefas com interpretacao, sintese, priorizacao ou decisao de estrategia.
- Em tarefas longas, multi-etapa ou com continuidade entre iteracoes, considerar `context-mode` como parte do plano.

## Execucao

1. Declare o modelo escolhido e o motivo em 1 linha, citando o contexto dominante
2. Cite rapidamente quais fontes de contexto voce leu antes da decisao
3. Spawne o subagente com `model: <opus|sonnet|haiku>` quando isso realmente ajudar
4. Se houver partes independentes, distribua em paralelo por contexto, nao apenas por volume
5. Aguarde o resultado, integre os achados e apresente ao usuario

Se a tarefa puder ser dividida em partes independentes, spawne subagentes em paralelo com modelos adequados para cada parte.
