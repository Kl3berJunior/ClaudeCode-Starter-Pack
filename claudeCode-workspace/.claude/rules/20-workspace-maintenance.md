---
paths:
  - ".claude/**/*"
  - "CLAUDE.md"
  - "HEARTBEAT.md"
  - "MEMORY.md"
  - "README.md"
  - "SOUL.md"
  - "TOOLS.md"
  - "USER.md"
---

# Manutencao do starter pack

- Preserve a natureza de template: exemplos devem ser neutros e artefatos reais
  devem ficar fora do versionamento.
- Quando o contrato crescer, prefira mover regras para `.claude/rules/` em vez
  de inflar o `CLAUDE.md` principal.
- `TOOLS.md` e `README.md` servem como referencia humana; evite duplicar neles
  regras normativas que ja existam em `.claude/rules/`.
- Se alterar hooks, commands, `.serena/` ou a estrutura de regras, atualize
  tambem `scripts/sync-starter-pack-to-workspace.ps1`.
- Ao testar melhorias do starter pack, prefira um workspace descartavel em
  `.tmp/` em vez de gerar runtime dentro do proprio template.
- Preferencias privadas e ajustes locais devem ir para `CLAUDE.local.md`,
  `.claude/settings.local.json` e `.serena/project.local.yml`, nunca para os
  arquivos versionados do template.
