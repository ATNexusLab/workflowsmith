# Next Steps — WorkflowSmith 0.1.0

Ordem de execução das RFCs para o milestone 0.1.0.

Cada item segue o fluxo:
`RFC → decisão → ADR (se necessário) → issues de implementação → branch → implement → validate → PR → merge`

---

## 1. Schema Finalization

**RFC #11 — Canonical Workflow Schema: Finalização**

Resolve os `kind` values ambíguos em `workflow/schema/workflow-unit.md` (herança do
0.0.0 versus os tipos estabelecidos no ADR-0005). Requer ADR. **Desbloqueante para
todos os passos seguintes.**

---

## 2. Canonical Instructions

**RFC #14 — split de #8**

Cria `workflow/source/instructions/` com as `instruction` units sempre ativas:
guidance de alto nível e alta precedência que os harnesses surfaceiam em seus arquivos
raiz (ex: `CLAUDE.md`, `copilot-instructions.md`). Cobre obrigações como
planejamento antes da execução, preservação de escopo e rastreabilidade.

---

## 3. Canonical Skills

**RFC #10**

Cria `workflow/source/skills/` com skills reutilizáveis: PR review, escrita de ADR,
validação de workspace, preparação de closeout, release notes. Cada skill define
trigger, inputs, procedimento, output e validação.

---

## 4. Canonical Agents

**RFC #9**

Cria `workflow/source/agents/` com os papéis canônicos de execução: Planner,
Implementer, Reviewer, Validator, Releaser. Cada agent referencia as instructions
aplicáveis e pode invocar skills.

---

## 5. Canonical Rules & Rigor Levels

**RFC #15 — split de #8**

Cria `workflow/source/rules/` com as `instruction` units escopadas que definem os
níveis de rigor (`draft`, `standard`, `strict`) e regras específicas de enforcement.
Distinto de instructions (sempre ativas e amplas): rules são scoped e específicas.

---

## 6. Canonical Hooks

**RFC #12**

Cria `workflow/source/hooks/` com hooks de lifecycle: pre-execution (verificar plano),
pre-closeout (verificar validação), etc. Open question: `hook` como novo `kind`?
Se sim, requer ADR.

---

## 7. Canonical Commands

**RFC #13**

Cria `workflow/source/commands/` com os comandos invocáveis pelo usuário: `/plan`,
`/implement`, `/review`, `/validate`, `/closeout`. Open question: `command` como
novo `kind`? Se sim, requer ADR.

---

## 8. Canonical MCPs

**RFC #16**

Define como o canonical workflow representa conectores MCP (Model Context Protocol)
como recursos canônicos em `workflow/source/`. Mapeado na canonical resource model
em `harness-resources.md` como "Tooling & Connectors". Sem RFC aberta ainda.

---

## Issues pendentes

Todas as RFCs abertas. Próximo passo: processar RFC #11 (Schema Finalization).
