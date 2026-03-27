Buscar tarefas de um GitHub Project com filtros compostos e retornar output estruturado pronto para delegação.

## Uso

```
/gh-project [filtros...]
```

Filtros disponíveis (qualquer combinação, em qualquer ordem):

| Filtro | Exemplo | Descrição |
|--------|---------|-----------|
| `org=<nome>` | `org=tectrilha` | Organização GitHub |
| `project=<n>` | `project=7` | Número do projeto |
| `assignee=<login>` | `assignee=Kl3berJunior` | Login GitHub do responsável |
| `status=<valor>` | `status="In Progress"` | Status exato do item |
| `sistema=<valor>` | `sistema=Captacao` | Campo "sistema" do projeto |
| `cliente=<valor>` | `cliente=PMC` | Campo "cliente" do projeto |
| `prioridade=<valor>` | `prioridade=alto` | Campo "prioridade" do projeto |
| `repo=<repo>` | `repo=portalgestao` | Repositório associado (parcial) |

Se um filtro não for informado, não aplica restrição para aquele campo.
Se `org` não for informado e houver apenas uma org em `USER.md`, usá-la como padrão. Se houver mais de uma, perguntar qual usar.
Se `project` não for informado e a org tiver apenas um projeto, usá-lo como padrão. Se houver mais de um, listar os disponíveis e perguntar.
Se `assignee` não for informado, listar tarefas de todos (sem filtro de responsável).

## Passos

1. Ler `USER.md` para obter:
   - `gh-username`: login do usuário
   - A lista de orgs e seus projetos na seção `### Organizações e Projetos`

2. Parsear `$ARGUMENTS` extraindo pares `chave=valor`. Valores com espaços podem vir entre aspas.

3. Montar os parâmetros finais combinando defaults com o que foi passado.

4. Executar o comando para buscar os itens do projeto:
   ```bash
   gh project item-list <project> --owner <org> --format json --limit 500
   ```

5. Ler o JSON retornado e aplicar **todos** os filtros informados:
   - `assignee`: checar se o login está na lista `assignees` do item (case-insensitive)
   - `status`: comparar com o campo `status` (case-insensitive)
   - `sistema`: comparar com o campo `sistema` (case-insensitive)
   - `cliente`: comparar com o campo `cliente` (case-insensitive)
   - `prioridade`: comparar com o campo `prioridade` (case-insensitive)
   - `repo`: checar se o campo `repository` contém o valor informado (substring, case-insensitive)

6. Agrupar os itens resultantes por `status` e apresentar no formato:

```
## [STATUS] (N tarefas)
- [#numero] Título da tarefa
  repo: org/repo | sistema: X | prioridade: Y | cliente: Z
  assignees: login1, login2
  descricao: primeiros 120 chars do body da issue (se disponível)
```

7. Ao final, exibir o resumo:
```
---
Total filtrado: N tarefas
Filtros aplicados: assignee=X status=Y ...
Projeto: org/projects/N
```

## Output estruturado para delegação

Após apresentar o resultado, se o número de tarefas for > 0, adicionar a seção:

```
## Contexto para delegação

Cada tarefa acima contém:
- Identificador único: #numero no repositório org/repo
- Descrição completa disponível via: gh issue view <numero> --repo <org/repo>
- Campos de contexto: sistema, cliente, prioridade, tamanho
- Responsável atual: assignees

Para delegar, use: /delegate <numero> <org/repo>
```

## Erros comuns

- Se `totalCount: 0` retornar, verificar se org e project number estão corretos.
- Se o filtro de `assignee` retornar 0 itens mas deveria ter resultados, listar os primeiros 3 itens brutos para inspecionar o formato do campo `assignees`.
- Se o campo customizado não existir no item (ex: `sistema` ausente), ignorar esse filtro silenciosamente.
