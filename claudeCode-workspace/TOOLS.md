# TOOLS

Fonte pratica de comandos, caminhos e MCPs do workspace.

Registre aqui:

- caminhos locais importantes
- comandos de build e teste por repo
- ferramentas instaladas
- wrappers internos do time
- observacoes sobre runtime local

## MCPs habilitados neste workspace

Fonte canonica: `.claude/settings.json`

- `serena`: leitura e edicao semantica de codigo, busca por simbolos, referencias e pontos de entrada
- `context7`: consulta de documentacao atualizada de bibliotecas, frameworks, SDKs e APIs
- `playwright`: automacao de browser para validacao funcional e visual
- `context-mode`: organizacao de contexto para tarefas longas, multi-etapa ou com historico grande
- `telegram`: notificacoes e interacao remota quando o pareamento do bot estiver configurado

## Heuristica de uso

- codigo com dependencia entre funcoes, classes e arquivos: começar por `serena`
- duvida sobre contrato externo ou API de biblioteca: consultar `context7`
- fluxo de UI, navegador, captura ou regressao visual: usar `playwright`
- sessao longa ou problema com muita troca de contexto: usar `context-mode`
- mensagens externas ou alerta operacional: usar `telegram` se estiver configurado

## Caminhos importantes

- workspace root: `__WORKSPACE_ROOT__`
- configuracao Claude Code: `.claude/settings.json`
- comandos customizados: `.claude/commands/`
- memoria diaria: `memory/`
- memoria duravel: `MEMORY.md`
- contrato operacional: `CLAUDE.md`

Formato sugerido:

## Repo `__REPO_NAME__`

- path: `__ABSOLUTE_OR_RELATIVE_PATH__`
- build: `__COMMAND__`
- test: `__COMMAND__`
- lint: `__COMMAND__`
- publish: `__COMMAND__`
- run: `__COMMAND__`
- notes: `__NOTES__`

---
