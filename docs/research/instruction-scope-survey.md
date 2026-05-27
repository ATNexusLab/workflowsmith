# Instruction Scope Survey — RFC #14 Research

Pre-ADR research artifact. Feeds ADR-0008.

Status: Fase 1 completa, Fase 2 (síntese) completa, ADR-0008 aceita.
Observação: este documento registra a pesquisa e a síntese pré-decisão. A decisão
de produto final está em `docs/decisions/adr-0008-instruction-scope-model.md`.

---

## Tabela comparativa

| Harness | Arquivo principal | Escopo global/user | Escopo org | Escopo projeto (repo) | Escopo subdiretório | Escopo local (gitignored) | Formato |
|---|---|---|---|---|---|---|---|
| **Codex CLI** | `AGENTS.md` | `~/.codex/AGENTS.md` | — | `/AGENTS.md` (git root) | `<subdir>/AGENTS.md` | `AGENTS.override.md` (qualquer nível) | Markdown |
| **Claude Code** | `CLAUDE.md` | `~/.claude/CLAUDE.md` | managed-policy¹ | `./CLAUDE.md` ou `./.claude/CLAUDE.md` | `<subdir>/CLAUDE.md` (on-demand) | `./CLAUDE.local.md` | Markdown |
| **GitHub Copilot CLI** | `copilot-instructions.md` | `~/.copilot/copilot-instructions.md` | — (CLI; org-level apenas no GitHub.com) | `.github/copilot-instructions.md` | `.github/instructions/*.instructions.md`² | — | Markdown (+ YAML frontmatter) |
| **OpenCode** | `AGENTS.md` | `~/.config/opencode/AGENTS.md` | — | `./AGENTS.md` (project root) | — (não documentado) | — | Markdown |
| **Antigravity IDE** | `agents.md` | — (workspace-scoped) | — | `.agents/agents.md` | — | — | Markdown |

¹ Managed policy (Claude Code): `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS),
  `/etc/claude-code/CLAUDE.md` (Linux), `C:\Program Files\ClaudeCode\CLAUDE.md` (Windows).
  Gerenciado por IT/DevOps. Escopo: todos os usuários na máquina.

² GitHub Copilot CLI path-scoped: `.github/instructions/<name>.instructions.md` com frontmatter
  `applyTo: "glob"` para aplicar a arquivos/diretórios específicos.
  Também lê `AGENTS.md` na raiz do repositório e nos diretórios definidos por `COPILOT_CUSTOM_INSTRUCTIONS_DIRS`.

---

## Comportamento de merge por harness

### Codex CLI
- Concatena global → repo-root → (subdirs down to cwd), arquivos mais próximos aparecem por último (higher precedence)
- `AGENTS.override.md` substitui `AGENTS.md` no mesmo diretório (local-only)
- Limite: 32–64 KiB combinado (configurável em `~/.codex/config.toml`)
- Fallback filename configurável: `project_doc_fallback_filenames`

### Claude Code
- Walk up from cwd até filesystem root; todos os arquivos encontrados são concatenados
- Ordem: mais distante (root) primeiro, mais próximo (cwd) por último
- Subdirs: carregam on-demand quando Claude acessa arquivos naquele diretório
- Imports: `@path/to/file` inclui outros arquivos no contexto
- Path-scoped rules: `.claude/rules/*.md` com frontmatter `paths:` ou `description:`
- Recomendado: < 200 linhas por arquivo

### GitHub Copilot CLI
- Global/user e repo são automaticamente combinados
- Path-scoped: instruções com glob `applyTo:` são aplicadas apenas a arquivos correspondentes
- `AGENTS.md` na raiz do repo é tratado como instrução primária; mesclado com `.github/copilot-instructions.md` se ambos existirem
- `COPILOT_CUSTOM_INSTRUCTIONS_DIRS`: variável de ambiente para diretórios adicionais com `AGENTS.md` ou `.github/instructions/`

### OpenCode
- Global + project são carregados juntos no início da sessão
- Subdirectory: não documentado na pesquisa atual

### Antigravity IDE
- Modelo diferente: `agents.md` define **personas de agente**, não instruções gerais
- Skills em `.agents/skills/*.md`, workflows em `.agents/workflows/*.md`
- Workspace-scoped: sem escopo global/user

---

## AGENTS.md como padrão cross-tool emergente

`AGENTS.md` está se tornando um padrão aberto (Linux Foundation) com adoção em 60.000+
projetos open-source. Ferramentas que leem `AGENTS.md`:
- Codex CLI (primário)
- Claude Code (fallback quando não há `CLAUDE.md`)
- GitHub Copilot CLI (lê na raiz do repo e via `COPILOT_CUSTOM_INSTRUCTIONS_DIRS`)
- OpenCode (primário)
- Continue.dev, Aider, OpenHands

Isso tem implicação direta para WorkflowSmith: usar AGENTS.md como base no
`workflow/source/instructions/` maximiza portabilidade entre harnesses.

---

## Avaliação do AGENTS.md atual no repo

O `/AGENTS.md` atual do WorkflowSmith é um **guia de desenvolvimento para Codex**
(tooling guidance), não um produto canônico. Ele cobre:

### O que cobre bem
- Separação produto vs. tooling: deixa claro que não é produto
- Obrigação de planejamento: "Plan before execution"
- Rastreabilidade: issues, branches, PRs, ADRs
- Escopo de edição: mudanças focadas, preservação do produto
- Validação: `sh scripts/validate.sh`

### O que está fora do escopo WorkflowSmith canônico
- É harness-específico (Codex only) — válido para `dist/codex/`, não para `workflow/source/`
- Não define escopos de instrução (global vs. repo)
- Não referencia o modelo canônico (agents, skills, instructions)
- Não tem os metadados do schema (`id`, `kind`, `status`, `version`, `owner`)

### Conclusão sobre o AGENTS.md atual
Permanece como guia de desenvolvimento em `/AGENTS.md` (tooling). O `dist/codex/` receberá
um arquivo novo derivado das canonical instructions na Fase 4 — não derivado do `/AGENTS.md`,
que tem finalidade e conteúdo distintos (tooling vs. produto canônico).

---

## Decisões em aberto — respostas definitivas do produto

### 1. WorkflowSmith vai distribuir instruções globais (user-level)?

**Decisão**: Sim. O escopo global **faz parte do produto**. Quando o usuário instalar
WorkflowSmith para um harness específico, o sistema identifica automaticamente a pasta
global correspondente daquele harness e deposita lá o **workflow completo** (não só
instructions).

Implicações para o ADR:
- A instalação é sempre harness-specific; o alvo global é resolvido pelo compiler contract
  de cada harness (ex: `~/.codex/` para Codex, `~/.copilot/` para GitHub Copilot CLI)
- O conteúdo global = workflow completo do WorkflowSmith
- O escopo local (project/repo) será provavelmente para **skills**: unidades que permitem
  que o workflow geral saiba como criar skills, agents, etc. no contexto específico do projeto

### 2. Subdiretório é canônico ou detalhe de harness?

**Decisão**: **Canônico.** O subdirectory scope é um nível reconhecido pelo modelo canônico.
O mecanismo de resolução (como cada harness implementa) é detalhe do compiler contract.

### 3. O `/AGENTS.md` atual entra em `dist/codex/` ou é só referência de desenvolvimento?

**Esclarecimento**: O `/AGENTS.md` atual foi criado pelo autor do projeto como guia de
desenvolvimento (tooling guidance), não é um produto canônico nem referência externa.

**Decisão**: Permanece como tooling em `/AGENTS.md`. O `dist/codex/` receberá um arquivo
novo derivado das canonical instructions quando a Fase 4 executar. O `/AGENTS.md` atual
não é base para esse derivado — são contextos distintos (tooling vs. produto).

---

## Padrão canônico emergente para WorkflowSmith

Observação pós-ADR: a pesquisa identificou `org` como surface existente em alguns
harnesses, mas ADR-0008 definiu que `org` não será um escopo canônico de source em
`0.1.0`. Ele permanece como detalhe de distribuição/contrato quando aplicável.

Com base na pesquisa, os **níveis de escopo canônicos** que WorkflowSmith deve reconhecer:

| Escopo | Descrição | Presente em harnesses |
|---|---|---|
| **global** | Instrução de usuário, independente de projeto | Codex, Claude Code, GitHub Copilot CLI, OpenCode |
| **org** | Instrução de organização, compartilhada entre projetos | GitHub Copilot (GitHub.com apenas) |
| **project** | Instrução de projeto, compartilhada via git | Todos |
| **subdir** | Instrução de subdiretório, escopo restrito | Codex, Claude Code, GitHub Copilot CLI (glob) |
| **local** | Override pessoal gitignored | Codex (AGENTS.override.md), Claude Code (CLAUDE.local.md) |

Cada nível tem implicações diferentes para o que deve conter:
- **global**: workflow completo do WorkflowSmith — instalado automaticamente na pasta global do harness
- **project**: contexto do projeto, convenções, decisões de arquitetura, processo; provavelmente skills locais
- **subdir**: regras específicas de área (frontend, billing, etc.)

---

## Fontes

- Codex: https://developers.openai.com/codex/guides/agents-md
- Claude Code: https://docs.anthropic.com/en/docs/claude-code/memory
- GitHub Copilot CLI (custom instructions): https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions
- GitHub Copilot CLI (config dir): https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference
- OpenCode: https://opencode.ai/docs + https://deepwiki.com/tencent-source/opencode/5.2-agents.md-and-project-context
- Antigravity: https://codelabs.developers.google.com/autonomous-ai-developer-pipelines-antigravity
- Survey: https://www.deployhq.com/blog/ai-coding-config-files-guide
- AGENTS.md open standard: https://agents.md
