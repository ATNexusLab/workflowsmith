# TODO — Etapa 2: Canonical Instructions (RFC #14)

## Contexto

Antes de criar qualquer conteúdo em `workflow/source/instructions/`, precisamos
de pesquisa comparativa nos harnesses alvo e de uma definição clara de escopo
(global × repo). Sem isso, qualquer ADR ou unit criada será retrabalho.

---

## Fase 1 — Pesquisa ✅

Pesquisar cada harness alvo respondendo: nome do arquivo de instrução, escopos
suportados (global/user × repo × subdir), estrutura recomendada, o que vai em
cada nível segundo a doc oficial.

- [x] **Codex** — `AGENTS.md`: global `~/.codex/AGENTS.md`, repo root, subdir (walk down),
  override `AGENTS.override.md` (gitignored). Merge: concatenação root→cwd, mais próximo por último.
  Limite 32-64 KiB. Fallback configurável em `~/.codex/config.toml`.
  Fonte: https://developers.openai.com/codex/guides/agents-md

- [x] **Claude Code** — `CLAUDE.md`: managed-policy (IT/DevOps), user `~/.claude/CLAUDE.md`,
  project `./CLAUDE.md` ou `./.claude/CLAUDE.md`, local `./CLAUDE.local.md` (gitignored),
  subdir on-demand. Imports via `@path`. Path-scoped rules em `.claude/rules/`. Fallback: lê `AGENTS.md`.
  Recomendado < 200 linhas. Fonte: https://docs.anthropic.com/en/docs/claude-code/memory

- [x] **GitHub Copilot CLI** — `copilot-instructions.md`: global `~/.copilot/copilot-instructions.md`,
  repo-level `.github/copilot-instructions.md`, path-scoped `.github/instructions/*.instructions.md`
  (glob `applyTo:`). Também lê `AGENTS.md` na raiz (primário). Org-level apenas no GitHub.com, não no CLI.
  Env var `COPILOT_CUSTOM_INSTRUCTIONS_DIRS` para diretórios adicionais.
  Fonte: https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions

- [x] **OpenCode** — `AGENTS.md`: global `~/.config/opencode/AGENTS.md`, project root `./AGENTS.md`.
  Subdir não documentado. `/init` gera AGENTS.md automaticamente.
  Fonte: https://opencode.ai/docs

- [x] **Antigravity IDE** — `.agents/agents.md`: modelo diferente — define *personas de agente*.
  Skills em `.agents/skills/*.md`, workflows em `.agents/workflows/*.md`. Workspace-scoped.
  Fonte: https://codelabs.developers.google.com/autonomous-ai-developer-pipelines-antigravity

- [x] **AGENTS.md atual no repo** — Guia de desenvolvimento Codex (tooling), não produto canônico.
  Cobre bem: separação produto/tooling, planejamento, rastreabilidade, validação.
  Falta: metadados de schema, escopos, referência ao modelo canônico.
  Conclusão: permanece como tooling em `/AGENTS.md`; dist/codex precisará de novo arquivo
  derivado das canonical instructions.

- [x] **Comunidade** — AGENTS.md tornou-se padrão aberto (Linux Foundation, 60k+ projetos OSS).
  Lido por: Codex CLI, Cursor, Claude Code (fallback), OpenCode, Continue.dev, Aider, OpenHands.
  Boas práticas: < 200-300 linhas, específico, commitar no git (exceto overrides).
  Fonte: https://www.deployhq.com/blog/ai-coding-config-files-guide

---

## Fase 2 — Síntese e definição de escopo ✅

Depende: todas as pesquisas da Fase 1. **Completa.** Ver `docs/research/instruction-scope-survey.md`.

- [x] Tabela comparativa: harness × escopos suportados × nome do arquivo × estrutura recomendada
  → Tabela completa em `docs/research/instruction-scope-survey.md`

- [x] Definir canonicamente para WorkflowSmith:
  - **global** (user-level): comportamento do agente independente de projeto — princípios de
    engenharia, estilo de trabalho, segurança. Presente em: Codex (`~/.codex/`), Claude Code
    (`~/.claude/`), GitHub Copilot CLI (`~/.copilot/`), OpenCode (`~/.config/opencode/`).
  - **project** (repo-level): contexto e regras do projeto — arquitetura, decisões, processo,
    convenções, autoridade do produto. Presente em: todos os harnesses.
  - **subdir**: regras de área específica. Presente em: Codex, Claude Code, GitHub Copilot CLI (glob).
  - **local**: override pessoal gitignored. Presente em: Codex (`AGENTS.override.md`), Claude Code (`CLAUDE.local.md`).

  Decisão resolvida em ADR-0008: WorkflowSmith distribui o workflow completo no escopo
  **global**; **project** permanece como autoridade local do repositório.

---

## Fase 3 — ADR: Instruction Scope Model

Depende: Fase 2.

- [x] Redigir ADR-0008 definindo:
  - Níveis de escopo que WorkflowSmith reconhece canonicamente
  - Mapping de cada escopo para os arquivos nativos de cada harness
  - O que é responsabilidade do usuário (global) vs. do projeto (repo)
  - Implicações para `workflow/source/` e `compiler/contracts/`
  → `docs/decisions/adr-0008-instruction-scope-model.md`

---

## Fase 4 — Execução RFC #14

Depende: ADR aprovado.

- [ ] Criar `workflow/source/instructions/` com as instruction units canônicas sempre ativas
  - Cobrir: planejamento antes da execução, preservação de escopo, rastreabilidade, precedência de autoridade do projeto
- [ ] Atualizar `compiler/contracts/` com o mapping instruction → harness surfaces
- [ ] Atualizar stubs em `dist/` para os harnesses alvo

---

## Decisões resolvidas

Respondidas com base nas clarificações do produto:

1. **WorkflowSmith distribui instruções globais (user-level)?**
   ✅ Sim. Global faz parte do produto. A instalação (sempre harness-specific) identifica
   automaticamente a pasta global do harness e deposita o **workflow completo** lá.
   Local (project/repo) será provavelmente para **skills** que ensinam o workflow a criar
   skills, agents, etc. no contexto do projeto.

2. **O escopo de subdiretório é canônico ou detalhe de implementação?**
   ✅ Canônico. Reconhecido no modelo canonical; mecanismo de resolução = detalhe do compiler contract.

3. **O `/AGENTS.md` atual entra no `dist/codex/` como base?**
   ✅ Não. O `/AGENTS.md` é tooling guidance criado pelo autor do projeto, não produto canônico.
   Permanece em `/AGENTS.md`. O `dist/codex/` receberá arquivo novo derivado das canonical
   instructions na Fase 4 — não derivado do `/AGENTS.md`.
