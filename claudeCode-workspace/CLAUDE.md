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
- `/agent-router <tarefa>` — roteamento automatico por complexidade (o proprio router roda em Sonnet e delega para Opus, Sonnet ou Haiku conforme a tarefa)

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
5. Antes de concluir: rodar testes, linters e garantir que o projeto compila.

Regras adicionais:

- nao reverter trabalho alheio
- nao usar `--no-verify` ou `--force-push` sem instrucao explicita

## Review obrigatorio antes do merge

Nenhum PR pode ser mergeado sem review explicita. Fluxo obrigatorio:

1. Abrir o PR com `gh pr create`
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

1. Atualizar a memoria diaria com `/daily-memory`.
2. Salvar resumo da sessao em `Relatorios/agent-sessions/YYYY-MM-DD-session.md` com:
   - objetivo
   - arquivos alterados
   - comandos executados
3. Avaliar se alguma decisao duravel deve subir para `MEMORY.md`.
4. Verificar worktrees elegiveis para limpeza.

## Regra final

Este workspace e infraestrutura viva. Mantenha limpo, rastreavel e verificavel.
