# CLAUDE.md - Workspace `__WORKSPACE_ROOT__`

Este arquivo e a fonte de verdade operacional do workspace para o Claude Code.
Ele importa os arquivos auxiliares abaixo automaticamente em cada sessao.
A fonte canonica dos MCPs/plugins habilitados neste workspace e `.claude/settings.json`.

@SOUL.md
@USER.md
@TOOLS.md
@MEMORY.md

## Startup obrigatorio

No inicio de cada sessao principal:

1. Ler `memory/YYYY-MM-DD.md` de hoje e, se existir, o de ontem
2. Ler `.claude/settings.json` para confirmar MCPs/plugins habilitados
3. Executar `/heartbeat` para verificar o estado operacional
4. Nao assumir contexto de sessao anterior sem verificar memoria

## Objetivo

Aqui vivem:

- contexto e contrato operacional do workspace
- memoria diaria e duravel
- configuracao canonica do fluxo
- relatorios e espelhos operacionais
- repositorios principais de codigo dentro de `repo/`

## Arquivos principais

- `SOUL.md` — principios permanentes
- `USER.md` — contexto do time
- `TOOLS.md` — comandos e ferramentas
- `HEARTBEAT.md` — checklist de saude operacional
- `MEMORY.md` — memoria duravel
- `memory/YYYY-MM-DD.md` — memoria diaria
- `Relatorios/` — artefatos humanos por repo e por job
- `Swarm/` — espelhos curtos de status operacional
- `repo/` — repositorios de codigo governados por este workspace

## Uso de MCPs

MCPs/plugins ativos neste workspace devem ser tratados como ferramentas de primeira linha, nao como opcional tardio.

Fonte canonica:

- `.claude/settings.json` define o conjunto de MCPs/plugins habilitados nesta instalacao

Prioridade por tipo de tarefa:

- `serena` para entender estrutura de codigo, localizar simbolos, navegar entre arquivos e editar com contexto semantico
- `context7` para documentacao atualizada de bibliotecas, frameworks, SDKs e APIs externas
- `playwright` para fluxos de browser, reproduzir bugs visuais, tirar screenshot e validar comportamento de UI
- `context-mode` para organizar contexto longo, manter continuidade e reduzir perda de estado entre tarefas grandes
- `telegram` apenas quando houver pareamento configurado e a tarefa envolver mensagens, notificacoes ou triagem remota

Regras operacionais:

- em tarefa de codigo dentro de repo conhecido, preferir `serena` antes de busca manual por texto quando o objetivo for entender simbolos, referencias ou pontos de entrada
- em tarefa que depende de API externa, pacote ou framework, consultar `context7` antes de assumir contrato ou comportamento
- em tarefa de interface, navegacao ou regressao visual, validar com `playwright` sempre que o fluxo puder ser exercido localmente
- em tarefa longa, com multiplos arquivos, varias etapas ou historico extenso, usar `context-mode` para manter continuidade e reduzir perda de contexto entre iteracoes
- se um MCP relevante estiver indisponivel, registrar o fallback usado no artefato final ou na memoria do dia quando isso afetar a qualidade da execucao
- nao inventar uso de MCP: escolher a ferramenta pelo tipo de evidencia necessaria

## Memoria

Se vale lembrar, escreva.

Escreva em:

- `memory/YYYY-MM-DD.md` para fatos do dia
- `MEMORY.md` para conhecimento duravel
- `TOOLS.md` para comandos e caminhos atualizados
- `CLAUDE.md` para regras do workspace

## Seguranca

Sem perguntar:

- ler arquivos locais
- investigar estado local
- organizar documentacao
- ajustar configuracao interna

Perguntar antes:

- publicar conteudo externo
- enviar dados para fora da maquina
- apagar de forma destrutiva
- qualquer acao que exponha dado privado

## Roteamento de codigo

- mudanca de codigo em repo conhecido deve virar task do backlog ou sessao direta, conforme politica do time
- nao improvisar fora do contrato operacional
- sempre respeitar `CLAUDE.md` local de cada repositorio
- quando houver MCP compativel com a tarefa, preferir o MCP adequado antes de depender so de shell e leitura linear

## Worktrees

Worktrees sao o mecanismo padrao para paralelo limpo, auditoria rastreavel e isolamento de contexto.

Regras:

- worktrees operacionais devem viver em `.wt/`
- usar o padrao `.wt/<repo>/<objetivo-ou-branch>` para manter auditoria simples
- cada worktree deve ter um objetivo claro, uma branch associada e um dono ou task rastreavel
- antes de criar nova worktree, auditar o estado atual com `git worktree list --porcelain`
- ao iniciar ou retomar uma task, verificar se ja existe worktree adequada antes de abrir outra
- ao encerrar uma task, avaliar se a worktree deve ser mantida, arquivada em artefato ou removida

Auto-gestao:

- Claude pode auditar worktrees sem perguntar: listar, inspecionar status, conferir branch e identificar worktrees orfas, sujas ou sem objetivo claro
- Claude deve registrar risco operacional quando encontrar worktree abandonada, branch inexistente, metadata inconsistente ou mudanca sem task associada
- Claude deve propor limpeza quando houver worktree limpa, mesclada ou sem uso, mas deve pedir confirmacao antes de remover
- Claude deve preferir `git worktree prune` para limpar metadata orfa e `git worktree remove` apenas para worktrees elegiveis e confirmadas

## Roteamento de modelo (agentes e subagentes)

Ao spawnar subagentes via ferramenta Agent, escolher o modelo pelo tipo de tarefa:

| Modelo | Quando usar |
|---|---|
| `opus` | Arquitetura, refatoracao cross-repo, debugging com causa desconhecida, decisoes de alto impacto |
| `sonnet` | Geracao de codigo, testes, explicacoes, buscas, tarefas com spec clara |
| `haiku` | Operacoes mecanicas: glob, grep, rename, verificacoes simples |

Regras:

- declarar o modelo escolhido e o motivo antes de spawnar o subagente
- tarefas independentes podem rodar em subagentes paralelos com modelos diferentes
- nao usar Opus para tarefas simples: custo e latencia nao justificam
- nao usar Haiku para tarefas que exigem raciocinio encadeado

Agentes disponiveis em `.claude/agents/`:

- `/review-deep <arquivo>` — analise profunda via Opus
- `/explain <simbolo-ou-arquivo>` — explicacao concisa via Sonnet
- `/agent-router <tarefa>` — roteamento automatico por complexidade

## Git

Fluxo obrigatorio ao fazer alteracoes em codigo:

1. Verificar se o branch atual esta limpo (sem mudancas nao commitadas). Se nao estiver, parar e confirmar com o usuario antes de continuar.
2. Criar um novo branch antes de editar qualquer arquivo:
   ```
   git checkout -b agent/<nome-curto-da-tarefa>
   ```
3. Nunca commitar diretamente em `main` ou `master`.
4. Usar mensagens de commit no formato convencional:
   - `feat: ...`
   - `fix: ...`
   - `refactor: ...`
   - `chore: ...`
5. Antes de concluir: rodar testes, linters e garantir que o projeto compila.

Regras adicionais:

- nao reverter trabalho alheio
- nao usar `--no-verify` ou `--force-push` sem instrucao explicita

## Encerramento de sessao

Ao finalizar cada sessao ou execucao de agente:

1. Atualizar a memoria diaria com `/daily-memory`.
2. Salvar resumo da sessao em `Relatorios/agent-sessions/YYYY-MM-DD-session.md` com:
   - objetivo
   - arquivos alterados
   - comandos executados
3. Avaliar se alguma decisao duravel deve subir para `MEMORY.md`.
4. Verificar worktrees elegiveis para limpeza.

## Regra final

Este workspace e infraestrutura viva. Mantenha limpo, rastreavel e verificavel.
