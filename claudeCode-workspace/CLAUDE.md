# CLAUDE.md - Workspace `__WORKSPACE_ROOT__`

Este arquivo e a fonte de verdade operacional do workspace para o Claude Code.
Ele importa os arquivos auxiliares abaixo automaticamente em cada sessao.

@SOUL.md
@USER.md
@TOOLS.md
@MEMORY.md

## Startup obrigatorio

No inicio de cada sessao principal:

1. Ler `memory/YYYY-MM-DD.md` de hoje e, se existir, o de ontem
2. Executar `/heartbeat` para verificar o estado operacional
3. Nao assumir contexto de sessao anterior sem verificar memoria

## Objetivo

Aqui vivem:

- contexto e contrato operacional do workspace
- memoria diaria e duravel
- configuracao canonica do fluxo
- relatorios e espelhos operacionais
- repositorios principais de codigo

## Arquivos principais

- `SOUL.md` — principios permanentes
- `USER.md` — contexto do time
- `TOOLS.md` — comandos e ferramentas
- `HEARTBEAT.md` — checklist de saude operacional
- `MEMORY.md` — memoria duravel
- `memory/YYYY-MM-DD.md` — memoria diaria
- `Relatorios/` — artefatos humanos por repo e por job
- `Swarm/` — espelhos curtos de status operacional

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

## Git

- nao commitar em branch protegida sem instrucao clara
- rodar validacao relevante antes de concluir
- nao reverter trabalho alheio

## Regra final

Este workspace e infraestrutura viva. Mantenha limpo, rastreavel e verificavel.
