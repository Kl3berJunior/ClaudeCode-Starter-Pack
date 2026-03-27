Trabalhar com GitHub Projects via `gh project`, com foco em analise, listagem e operacao segura.

Uso:
`/gh-project <acao> [argumentos]`

Acoes disponiveis:
- `analisar [org=<login>] [project=<numero>]`
- `projetos [org=<login>]`
- `itens [org=<login>] [project=<numero>] [query="<filtro>"] [limit=<n>]`
- `adicionar [org=<login>] [project=<numero>] url=<issue-ou-pr-url>`
- `campos [org=<login>] [project=<numero>]`

Passos obrigatorios:
1. Ler `USER.md` para obter:
   - `gh-username`
   - orgs conhecidas
   - projetos conhecidos por org
2. Validar autenticacao com `gh auth status`.
3. Se o token estiver invalido ou sem escopo `project`, parar e orientar:
   - `gh auth login -h github.com`
   - `gh auth refresh -s project`
4. Resolver defaults:
   - Se `org` nao for informada e existir apenas uma org em `USER.md`, usar essa org
   - Se `project` nao for informado e a org tiver apenas um projeto em `USER.md`, usar esse projeto
   - Se houver ambiguidade, listar as opcoes e pedir confirmacao
5. Executar o comando `gh project` correspondente, preferindo `--format json` quando houver saida estruturada
6. Responder com output curto, verificavel e pronto para uso na proxima acao

## analisar
Objetivo: inspecionar o contexto de GitHub Projects disponivel para o usuario.

Passos:
1. Se `org` nao vier informada:
   - listar as orgs encontradas em `USER.md`
   - se necessario, listar tambem os projetos mapeados em cada org
2. Executar:
   - `gh project list --owner <org> --format json`
3. Se `project=<numero>` for informado, executar tambem:
   - `gh project view <numero> --owner <org> --format json`
   - `gh project field-list <numero> --owner <org> --format json`
   - `gh project item-list <numero> --owner <org> --limit 100 --format json`
4. Apresentar:
   - org analisada
   - projetos encontrados
   - se houver projeto especifico: titulo, url, visibilidade, campos e quantidade de itens

Formato de resposta sugerido:
```md
## GitHub Project
- owner: <org>
- projetos encontrados: <N>

### Projeto <numero>
- titulo: <title>
- url: <url>
- campos: <N>
- itens analisados: <N>
```

## projetos
Objetivo: listar os projetos disponiveis para um owner.

Comando:
`gh project list --owner <org> --limit 100 --format json`

Retornar:
- `number`
- `title`
- `closed`
- `url`
- `shortDescription`

Formato de resposta sugerido:
```md
## Projetos de <org>
- #<numero> | <titulo> | <aberto-ou-fechado> | <url>
- #<numero> | <titulo> | <aberto-ou-fechado> | <url>
```

## itens
Objetivo: listar itens de um projeto.

Comando base:
`gh project item-list <project> --owner <org> --limit <n> --format json`

Se `query` vier informada, usar:
`gh project item-list <project> --owner <org> --limit <n> --query "<filtro>" --format json`

Regras:
- usar `limit=100` por padrao quando nao informado
- se a consulta vier vazia, listar tudo
- agrupar por `status` quando esse campo estiver disponivel
- destacar issue/PR, repositorio e assignees quando existirem

Formato de resposta sugerido:
```md
## Itens do projeto <org>/<project>

### <STATUS> (<N>)
- [<tipo> #<numero>] <titulo>
  repo: <org/repo>
  assignees: <login1, login2>
```

## adicionar
Objetivo: adicionar uma issue ou PR existente ao projeto.

Validacoes:
- `url` e obrigatoria
- confirmar `org` e `project` antes de executar se nao vierem explicitos e houver mais de uma opcao

Comando:
`gh project item-add <project> --owner <org> --url <url> --format json`

Retornar:
- confirmacao de owner e projeto
- URL adicionada
- id do item, se presente na resposta

Formato de resposta sugerido:
```md
Item adicionado ao projeto com sucesso.
- owner: <org>
- projeto: <numero>
- url: <url>
- itemId: <id>
```

## campos
Objetivo: listar os campos configurados em um projeto.

Comando:
`gh project field-list <project> --owner <org> --limit 100 --format json`

Retornar:
- nome do campo
- tipo
- opcoes, quando existirem

Formato de resposta sugerido:
```md
## Campos do projeto <org>/<project>
- <nome-do-campo> | <tipo-do-campo>
- <nome-do-campo> | <tipo-do-campo>
- <nome-do-campo> | <tipo-do-campo>
```

## Regras operacionais
- Este comando nao deve criar, editar, fechar ou deletar projetos sem pedido explicito do usuario
- Este comando nao deve mergear PRs
- Se a tarefa evoluir para fluxo de PR, seguir `CLAUDE.md`: sem merge sem aprovacao explicita do usuario
- Quando houver merge autorizado pelo usuario, usar `gh pr merge <numero> --merge` sem `--delete-branch`
- Em erros de permissao, autenticar primeiro e so depois repetir o comando
- Sempre preferir owner e numero de projeto vindos de `USER.md` quando houver contexto suficiente

## Erros comuns
- `Failed to log in` ou token invalido: executar `gh auth login -h github.com`
- falta de escopo `project`: executar `gh auth refresh -s project`
- owner incorreto: conferir a secao de GitHub em `USER.md`
- projeto nao encontrado: rodar `gh project list --owner <org>`
