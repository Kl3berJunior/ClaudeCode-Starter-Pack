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

1. Os hooks em `.claude/settings.json` devem auto-inicializar a sessao no evento `SessionStart`
2. A auto-inicializacao deve gravar o marcador local `memory/_session-state.json`
3. Antes de responder qualquer solicitacao operacional, considerar a sessao valida apenas se:
   - o marcador existir
   - `date` for a data de hoje
   - `startup_done` for `true`
   - `close_done` for `false`
4. Se o estado nao estiver valido, executar `/startup` antes de prosseguir
5. O `/startup` deve:
   - ler `memory/YYYY-MM-DD.md` de hoje e, se existir, o de ontem
   - ler o relatorio de sessao mais recente em `Relatorios/agent-sessions/`
   - ler `.claude/settings.json` para confirmar MCPs/plugins habilitados
   - executar `/heartbeat` para verificar o estado operacional
   - reparar ou recriar `memory/_session-state.json`
   - responder com contexto herdado, riscos e proximo passo recomendado
6. Se `/startup` nao puder ser usado, executar manualmente os passos acima
7. Nao assumir contexto de sessao anterior sem verificar memoria e relatorio

## Gate de sessao

Hooks e comandos de sessao devem trabalhar juntos:

- `SessionStart` auto-inicializa e injeta contexto minimo
- `UserPromptSubmit` bloqueia prompts quando o estado da sessao estiver invalido
- `SessionEnd` registra encerramento leve e detecta saida sem `/close-session`
- `/startup` e o fallback manual para auditoria completa e reabertura de contexto
- `/close-session` e o fechamento rico obrigatorio antes de sair do Claude CLI

Se o usuario enviar uma mensagem avulsa logo ao abrir o Claude CLI, o fluxo esperado e:

1. o hook validar ou criar o marcador
2. o hook injetar o contexto minimo da sessao
3. se houver falha ou estado invalido, bloquear o prompt e exigir `/startup`

## Uso de commands por fluxo

Commands do workspace devem seguir a sequencia operacional abaixo:

- abertura e reparo de contexto: `SessionStart` -> `/startup` -> `/heartbeat` quando necessario
- triagem de demanda local: `/backlog`
- triagem de demanda vinda do GitHub: `/gh-project` -> `/delegate` -> `/backlog`
- isolamento de execucao: `/worktree`
- finalizacao de entrega: `/commit-commands:commit` ou `/commit-commands:commit-push-pr`
- limpeza pos-merge: `/commit-commands:clean_gone` quando houver branches `[gone]`
- registro e fechamento: `/daily-memory` durante a sessao, `/close-session` como ultimo comando

Regras:

- nao usar `/delegate` como substituto de `/backlog`; ele serve para alimentar ou atualizar o backlog
- nao abrir worktree antes de a task ou objetivo estar claro e rastreavel
- usar `/heartbeat` como auditoria de saude, nao como substituto de `/startup`
- usar `commit-commands` apenas depois de validar a mudanca e preparar o stage
- commit e PR devem ter descricao rica, nao so titulo curto
- `commit-push-pr` nao substitui review nem autorizacao de merge
- usar `/close-session` sempre como fechamento rico, mesmo quando `/daily-memory` ja tiver sido executado

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
- padrao de caminho por tipo:
  - workspace: `.wt/workspace/<objetivo-ou-branch>` — para isolar trabalho no proprio workspace
  - repo interno: `.wt/<repo-em-kebab-case>/<objetivo-ou-branch>` — para repos em `repo/` (git repos separados)
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

Ao spawnar subagentes via ferramenta Agent, escolher o modelo por contexto operacional, impacto e ambiguidade - nao so por "tamanho" da tarefa.

Leituras minimas antes da escolha:

- identificar se a tarefa vive no workspace, em `repo/`, em integracao externa, em UI/browser ou em operacao mecanica
- ler `CLAUDE.md` e `TOOLS.md` quando a tarefa tocar fluxo operacional ou repo conhecido
- ler `Relatorios/Swarm/` e memoria recente quando a tarefa depender de continuidade, backlog, supervisor ou worktrees
- ler `CLAUDE.md` do repo alvo antes de mexer em codigo

| Modelo | Quando usar |
|---|---|
| `opus` | Arquitetura, refatoracao cross-repo, debugging com causa desconhecida, decisoes que cruzam workspace/repos/supervisor, tarefas de alto impacto |
| `sonnet` | Mudancas com contexto identificavel e escopo claro: codigo, testes, docs, agentes, hooks, relatorios, exploracao guiada por MCP |
| `haiku` | Operacoes mecanicas e deterministicas: glob, grep, rename, formatacao, verificacoes simples |

Regras:

- declarar o modelo escolhido e o motivo antes de spawnar o subagente
- citar o contexto dominante usado na decisao
- tarefas independentes podem rodar em subagentes paralelos com modelos diferentes
- nao usar Opus para tarefas simples: custo e latencia nao justificam
- nao usar Haiku para tarefas que exigem raciocinio encadeado, sintese ou leitura espalhada de contexto
- se a tarefa revelar ambiguidade maior do que parecia no inicio, subir o modelo em vez de insistir no roteamento inicial
- em tarefa longa, multi-etapa ou com historico extenso, considerar `context-mode` como parte do plano

Agentes disponiveis em `.claude/agents/`:

- `/review-deep <arquivo>` — analise profunda via Opus
- `/explain <simbolo-ou-arquivo>` — explicacao concisa via Sonnet
- `/agent-router <tarefa>` â€” roteamento automatico contextual (o proprio router roda em Sonnet e delega para Opus, Sonnet ou Haiku conforme o contexto dominante da tarefa)

## Git

Fluxo obrigatorio ao fazer alteracoes em codigo:

1. Verificar se o branch atual esta limpo (sem mudancas nao commitadas). Se nao estiver, parar e confirmar com o usuario antes de continuar.
2. Criar um novo branch antes de editar qualquer arquivo usando prefixo convencional:
   ```
   git checkout -b feat/<objetivo>
   git checkout -b fix/<objetivo>
   git checkout -b chore/<objetivo>
   git checkout -b refactor/<objetivo>
   git checkout -b docs/<objetivo>
   ```
3. Nunca commitar diretamente em `main` ou `master`.
4. Usar mensagens de commit no formato convencional:
   - `feat: ...`
   - `fix: ...`
   - `refactor: ...`
   - `chore: ...`
   - `docs: ...`
   Alem do titulo, preferir corpo rico com:
   - contexto ou problema
   - principais mudancas
   - validacao executada ou motivo da ausencia
5. Antes de concluir: rodar testes, linters e garantir que o projeto compila.

Regras adicionais:

- nao reverter trabalho alheio
- nao usar `--no-verify` ou `--force-push` sem instrucao explicita

## Review obrigatorio antes do merge

Nenhum PR pode ser mergeado sem review explicita. Fluxo obrigatorio:

1. Abrir o PR com `gh pr create`
   - usar descricao rica com contexto, mudancas principais, validacao, risco e links relevantes
2. Aguardar o usuario revisar e aprovar — ou solicitar explicitamente ao agente que faca a review
3. Somente apos aprovacao explicita do usuario executar `gh pr merge`

Regras:
- o agente nao pode mergear um PR sem instrucao direta do usuario
- "pode mergear" ou "aprova" sao instrucoes validas de aprovacao
- nunca assumir aprovacao implicita por ausencia de objecao

## Testes

Testes vivem em `tests/<nome-do-repo>/<modulo>/`.

- `<nome-do-repo>`: nome do repositorio em kebab-case (ex: `meu-servico`, `portal-web`)
- `<modulo>`: area funcional coberta pelo teste (ex: `despesa`, `autenticacao`, `relatorio`)
- Diretorios sao criados sob demanda — nao criar estrutura vazia antecipadamente
- Nunca criar arquivos de teste na raiz do workspace ou dentro de `repo/`

Convencao de nomenclatura:

| Tipo | Tecnologia | Nomenclatura |
|------|-----------|--------------|
| API / backend | PowerShell | `test_<cenario>.ps1` |
| Frontend / UI | Playwright (TypeScript) | `<cenario>.spec.ts` |

Ao criar um novo teste:
1. Identificar o repositorio alvo e converter o nome para kebab-case
2. Criar `tests/<nome-do-repo>/<modulo>/` somente se ainda nao existir
3. Nomear o arquivo conforme o cenario testado, nao o endpoint ou componente
4. Se o fix tiver impacto visual, criar teste de API **e** teste Playwright correspondente

## Pos-merge obrigatorio

Apos um PR ser aprovado e mergeado:

1. Mergear via `gh pr merge <numero> --merge` (sem `--delete-branch` — o GitHub apaga o remoto automaticamente via `delete_branch_on_merge=true`).
2. Voltar para main e atualizar:
   ```
   git checkout main
   git pull origin main
   ```
3. Deletar o branch local (se ainda existir):
   ```
   git branch -d <branch>
   ```
4. Podar referencias remotas obsoletas:
   ```
   git remote prune origin
   ```

## Encerramento de sessao

Ao finalizar cada sessao ou execucao de agente:

1. Executar `/close-session` como ultimo comando antes de sair do Claude CLI.
2. O `/close-session` deve:
   - atualizar a memoria diaria com `/daily-memory`
   - salvar ou atualizar o resumo da sessao em `Relatorios/agent-sessions/YYYY-MM-DD-session.md`
   - avaliar se alguma decisao duravel deve subir para `MEMORY.md`
   - verificar worktrees elegiveis para limpeza
   - atualizar `memory/_session-state.json` com `close_done=true`
   - responder com checklist final e pendencias remanescentes
3. O hook `SessionEnd` nao substitui `/close-session`; ele serve apenas para registrar a saida e detectar encerramento sem fechamento completo.
4. Se `/close-session` nao puder ser usado, executar manualmente os passos acima.

## Regra final

Este workspace e infraestrutura viva. Mantenha limpo, rastreavel e verificavel.
