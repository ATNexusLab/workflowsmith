# Claude — melhorias pendentes

Este arquivo registra o que ainda falta no workflow do Claude para atingir paridade operacional com os outros workflows ativos (`copilot`, `antigravity-cli`).  
Nenhuma mudança é feita aqui em `workflows/` — toda implementação acontece no repositório-fonte do Claude antes do próximo rsync.

---

## Baseline de paridade (já atingida)

Estes componentes existem nos três workflows e o Claude já os tem:

- Agents: `creative`, `engine`, `principal`
- Commands: `bootstrap-project`, `closeout`, `run-audit`, `start-spec`
- Skills: 21 genéricas + `claude-instructions` (skill nativa)
- Config entry point: `CLAUDE.md` e `settings.json.template`
- MCP config template: `mcp.json.template`
- Hook scripts funcionais: 4 hooks (`auto-approve-permissions.js`, `block-git-write.ps1`, `plan-first.js`, `worktree-cleanup.js`)
- Regras operacionais standalone: `rules/` com `closeout.md`, `routing.md`, `task-completion.md`, `test-contract.md`

---

## Falta para paridade

### ADRs / documentação de decisões arquiteturais

- **Antigravity CLI tem:** `docs/decisions/` com 5 ADRs numerados cobrindo hierarquia de contexto, skills vs. agents, convenção de nomes MCP, contrato I/O de hooks e migração de documentação.
- **Claude não tem:** nenhuma pasta equivalente de decisões arquiteturais registradas.
- **Ação:** criar `docs/decisions/` no source repo do Claude e documentar as principais decisões de design do workflow (pelo menos: hierarquia de contexto/scope layers, relação rules vs. skills, modelo de hooks, convenção de memória por projeto).

### Seção de features avançadas (`docs/advanced/`)

- **Antigravity CLI tem:** `docs/advanced/` cobrindo autenticação, checkpointing, headless mode, plan mode, sandbox, telemetria, temas.
- **Claude não tem:** nenhuma seção equivalente de features avançadas ou operação não-padrão.
- **Ação:** criar `docs/advanced/` no source repo do Claude cobrindo pelo menos: uso headless/automação, controles de permissão avançados, e integração com IDEs além do básico já em `docs/reference/ide-integrations.md`.

### Documentação de `projects/` no índice de docs

- **Situação:** `projects/` contém memória per-projeto usada ativamente (`MEMORY.md` e arquivos de feedback por projeto), mas não aparece em `docs/index.md` nem em nenhuma seção da documentação navegável.
- **Ação:** adicionar referência a `projects/` no índice de docs — ou em `docs/memory/memory-system.md` explicando a relação entre memória global e memória per-projeto, ou como entrada separada no `docs/index.md`.

---

## Assimetria aceitável (não precisa mudar)

| Item | Motivo |
|---|---|
| `projects/` como memória per-projeto | Exclusivo do Claude — o sistema de `projects/` com MEMORY.md por projeto não existe nos outros workflows e é específico do mecanismo de memória do Claude. Não precisa ser pareado. |
| 4 hook scripts funcionais vs. 2 do Copilot | Claude já está acima da linha de paridade aqui — é referência, não gap. |
| `statusline-command.sh` | Script de integração com terminal/statusline é tool-specific. |

---

> **Lembrete de escopo:** toda implementação acontece no repositório-fonte do Claude na máquina local, antes do próximo rsync para este repositório.
