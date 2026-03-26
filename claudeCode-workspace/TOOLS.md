# TOOLS

Registre aqui:

- caminhos locais importantes
- comandos de build e teste por repo
- ferramentas instaladas
- wrappers internos do time
- observacoes sobre runtime local

Formato sugerido:

## Repo `__REPO_NAME__`

- build: `__COMMAND__`
- test: `__COMMAND__`
- lint: `__COMMAND__`
- publish: `__COMMAND__`

---

## Repo `RepassesWebExterno`

- caminho: `C:/Sistema/RepassesWebExterno`
- dev: `npm run dev`
- build (padrao): `npm run build`
- build PMS: `npm run build_pms`
- build PMV: `npm run build_pmv`
- build PMColatina: `npm run build_pmcolatina`
- lint: nao configurado
- test: nao configurado
- stack: Vue 3 + TypeScript + Vite + PrimeVue
- deploy: Azure DevOps (azure-pipelines.yml), trigger na branch master
