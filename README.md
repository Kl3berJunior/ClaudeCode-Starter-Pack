# ClaudeCode-Stater-Pack — Resumo Detalhado

## O que é

Um template de workspace profissional para o **Claude Code** (CLI da Anthropic). Fornece uma estrutura pronta com contratos operacionais, sistema de memória, monitoramento de saúde e gerenciamento de tarefas — tudo em português.

O pack tem duas partes independentes:

- `claude-code-workspace/` — o workspace principal onde Claude opera
- `claude-code-repo/` — o template que vai dentro de cada repositório de código

---

## Estrutura de arquivos

```
ClaudeCode-Stater-Pack/
├── claude-code-repo/
│   └── CLAUDE.md                        # Template por repositório
└── claude-code-workspace/
    ├── .claude/
    │   ├── settings.json                # Permissões do Claude Code
    │   └── commands/
    │       ├── backlog.md               # Slash command /backlog
    │       ├── daily-memory.md          # Slash command /daily-memory
    │       └── heartbeat.md             # Slash command /heartbeat
    ├── memory/
    │   └── README.md                    # Instruções de uso da memória diária
    ├── .gitignore
    ├── CLAUDE.md                        # Contrato operacional principal
    ├── HEARTBEAT.md                     # Checklist de saúde operacional
    ├── MEMORY.md                        # Memória durável curada
    ├── SOUL.md                          # Princípios permanentes do fluxo
    ├── TOOLS.md                         # Template de ferramentas e comandos
    └── USER.md                          # Contexto operacional do time
```

---

## Como funciona — visão geral

O Claude Code, ao iniciar uma sessão no workspace, lê o `CLAUDE.md` raiz. Esse arquivo é o **ponto de entrada** de tudo: ele importa os demais arquivos via diretivas `@` e define o que Claude deve fazer obrigatoriamente a cada sessão.

### Fluxo de startup obrigatório

```
1. Ler memory/YYYY-MM-DD.md de hoje
2. Ler memory/YYYY-MM-DD.md de ontem (se existir)
3. Executar /heartbeat
```

Nenhum contexto de sessão anterior é assumido sem verificação. Claude parte sempre do estado atual dos arquivos.

---

## Detalhamento de cada componente

### CLAUDE.md (workspace)

Fonte de verdade operacional. Faz quatro coisas:

1. **Importa** os arquivos auxiliares automaticamente via `@SOUL.md`, `@USER.md`, `@TOOLS.md`, `@MEMORY.md`
2. **Define o startup** obrigatório (leitura de memória + heartbeat)
3. **Estabelece regras de segurança** — o que Claude pode fazer sem perguntar vs. o que exige confirmação
4. **Define roteamento de código** — mudanças em repos conhecidos viram tasks do backlog ou sessões diretas, nunca improviso

**Regras de segurança:**

| Sem perguntar | Perguntar antes |
|---|---|
| Ler arquivos locais | Publicar conteúdo externo |
| Investigar estado local | Enviar dados para fora da máquina |
| Organizar documentação | Apagar de forma destrutiva |
| Ajustar configuração interna | Expor dados privados |

---

### SOUL.md

Princípios fixos que nunca mudam, independente do projeto:

- **Clareza antes de automação** — não executar sem entender
- **Validação real antes de conclusão** — não marcar como feito sem checar
- **Artefato antes de memória oral** — escrever antes de dizer
- **Backlog com fonte** — toda task tem origem rastreável
- **Segurança por padrão** — segredos fora do versionamento
- **Logs e relatórios rastreaveis** — tudo auditável
- **Autonomia com limites explícitos** — Claude age, mas respeita fronteiras

---

### USER.md

Template para o time preencher com contexto operacional:

- Linguagem principal dos repositórios
- Ambiente de deploy
- Horário de trabalho
- Restrições de produção
- Preferências de PR, squash, branch naming

Não armazena segredos, tokens ou senhas.

---

### TOOLS.md

Registro de ferramentas e comandos locais, por repositório:

```
## Repo nome-do-repo
- build: comando
- test: comando
- lint: comando
- publish: comando
```

Mantém caminhos concretos atualizados para que Claude execute corretamente sem precisar descobrir.

---

### Sistema de memória (dois níveis)

#### Memória diária — `memory/YYYY-MM-DD.md`

Um arquivo por dia. Registra:

- Fatos e eventos do dia
- Mudanças operacionais
- Riscos descobertos
- Links para artefatos gerados
- Decisões que podem ser promovidas

#### Memória durável — `MEMORY.md`

Conhecimento que sobrevive ao dia. Regras:

- Apenas decisões, contratos e fatos duráveis
- Sem duplicatas
- Com caminhos concretos sempre que possível

**Regra de promoção:** um fato da memória diária é promovido para `MEMORY.md` quando tem relevância além do dia atual (ex.: decisão arquitetural, contrato de time, convenção estabelecida).

---

### HEARTBEAT.md

Checklist operacional leve. Perguntas que o `/heartbeat` responde:

- Existe task bloqueada sem dono claro?
- Existe relatório crítico vencido?
- Existe erro novo no supervisor?
- A memória do dia foi atualizada?

Se nada precisar de atenção, responde `HEARTBEAT_OK`.

---

### Slash Commands (`.claude/commands/`)

São comandos customizados invocados com `/nome` dentro do Claude Code.

#### `/heartbeat`

**O que faz:**
1. Lê `HEARTBEAT.md`
2. Verifica tasks bloqueadas em `Relatorios/Swarm/task-backlog.md`
3. Verifica se a memória do dia foi atualizada
4. Reporta o estado ou lista o que precisa de atenção

**Quando usar:** sempre ao iniciar uma sessão (é obrigatório pelo CLAUDE.md).

---

#### `/backlog`

**O que faz:**
1. Lê `Relatorios/Swarm/task-backlog.md` (cria se não existir)
2. Mostra tasks abertas com status, prioridade e repo
3. Pergunta o que o usuário quer fazer: adicionar, atualizar status ou listar
4. Aplica a mudança mantendo o formato de tabela Markdown
5. Atualiza `Relatorios/Swarm/supervisor-status.md` com total de tasks abertas e data

**Formato da tabela:**
```
| Id | Repo | Titulo | Status | Prioridade | Origem |
```

**Status válidos:** `open`, `in-progress`, `blocked`, `done`, `cancelled`

**Prioridades válidas:** `high`, `medium`, `low`

---

#### `/daily-memory`

**O que faz:**
1. Verifica se `memory/YYYY-MM-DD.md` de hoje existe
2. Se não existir, cria com cabeçalho `# YYYY-MM-DD`
3. Pergunta o que deve ser registrado (ou usa o contexto da sessão)
4. Registra fatos, decisões, riscos e links para artefatos
5. Avalia se algum item merece promoção para `MEMORY.md`

**Quando usar:** ao final de uma sessão ou quando houver eventos relevantes a registrar.

---

### .claude/settings.json

Define as permissões automáticas do Claude Code no workspace:

```json
{
  "permissions": {
    "allow": [
      "Bash(git:*)",   // qualquer comando git
      "Bash(ls:*)",    // listar diretórios
      "Bash(cat:*)",   // ler arquivos via shell
      "Read(*)",       // ler qualquer arquivo
      "Write(*)",      // escrever qualquer arquivo
      "Edit(*)",       // editar qualquer arquivo
      "Glob(*)",       // busca por padrões de arquivo
      "Grep(*)"        // busca por conteúdo
    ],
    "deny": []
  }
}
```

Essas permissões são aprovadas automaticamente — o usuário não precisa confirmar cada operação de leitura/escrita local.

---

### .gitignore

Exclui do versionamento:

```
.claude/settings.local.json   # configurações locais pessoais
secrets.local.json            # segredos locais
Relatorios/                   # relatórios gerados
Swarm/                        # status operacional gerado
.wt/                          # worktrees temporários
.DS_Store, Thumbs.db          # arquivos de sistema
```

---

### claude-code-repo/CLAUDE.md

Template para governar o comportamento do Claude **dentro de cada repositório individual**. É diferente do CLAUDE.md do workspace — ele é copiado para dentro de cada repo.

**O que define:**

- O que Claude deve fazer antes de alterar código (ler o arquivo, localizar comandos de validação, confirmar branch)
- Regras mínimas de Git (não commitar sem instrução clara, não reverter trabalho alheio)
- Placeholders para comandos de build/test/lint do repo específico
- Onde ficam os relatórios: `__WORKSPACE_ROOT__/Relatorios/__REPO_NAME__/`

**Placeholders a substituir ao usar:**

| Placeholder | O que colocar |
|---|---|
| `__REPO_NAME__` | Nome do repositório |
| `__BUILD_COMMAND__` | Comando de build |
| `__TEST_COMMAND__` | Comando de testes |
| `__LINT_COMMAND__` | Comando de lint |
| `__WORKSPACE_ROOT__` | Caminho absoluto do workspace |

---

## Fluxo completo de uma sessão

```
Sessão inicia
    │
    ▼
Claude lê CLAUDE.md
    │ importa automaticamente
    ├── SOUL.md
    ├── USER.md
    ├── TOOLS.md
    └── MEMORY.md
    │
    ▼
Startup obrigatório
    ├── Lê memory/hoje.md
    ├── Lê memory/ontem.md (se existir)
    └── Executa /heartbeat
            ├── Verifica tasks bloqueadas
            ├── Verifica relatórios vencidos
            └── Responde HEARTBEAT_OK ou lista atenções
    │
    ▼
Trabalho da sessão
    ├── Código → task no /backlog ou sessão direta
    ├── Decisões → /daily-memory
    └── Respeita CLAUDE.md de cada repo
    │
    ▼
Fim da sessão
    └── /daily-memory → registra fatos e avalia promoções para MEMORY.md
```

---

## Onde os dados ficam

| Dado | Localização |
|---|---|
| Memória do dia | `memory/YYYY-MM-DD.md` |
| Memória durável | `MEMORY.md` |
| Ferramentas e comandos | `TOOLS.md` |
| Backlog de tasks | `Relatorios/Swarm/task-backlog.md` |
| Status do supervisor | `Relatorios/Swarm/supervisor-status.md` |
| Relatórios por repo | `Relatorios/__REPO_NAME__/` |
| Configurações pessoais | `.claude/settings.local.json` (não versionado) |

---

## Como usar o pack

1. Copiar `claude-code-workspace/` para o diretório raiz do seu workspace
2. Preencher `USER.md` com o contexto do time
3. Preencher `TOOLS.md` com os comandos de cada repo
4. Para cada repositório de código: copiar `claude-code-repo/CLAUDE.md` para dentro do repo e substituir os placeholders
5. Substituir `__WORKSPACE_ROOT__` no `CLAUDE.md` do workspace pelo caminho real
6. Abrir o Claude Code no workspace — ele já encontra o `CLAUDE.md` e inicia o fluxo automaticamente
