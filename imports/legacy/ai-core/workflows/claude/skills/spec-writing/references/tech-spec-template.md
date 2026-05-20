# Tech Spec: [Nome do Componente / Feature]

**Status:** Rascunho | Em Revisão | Aprovado | Implementado
**Data:** YYYY-MM-DD
**Autores:** [Nome / Agente]
**ADR Relacionado:** ADR-[X] (se aplicável)

---

## Resumo

<!-- Uma frase descrevendo o que está sendo especificado e por quê. -->

## Problema

<!-- O que está sendo resolvido? Qual é a dor ou necessidade? -->

## Escopo

**Está dentro do escopo:**
- ...

**Está fora do escopo:**
- ...

## Design

### Visão Geral

<!-- Diagrama textual ou descrição da arquitetura do componente. -->

```
[Exemplo de diagrama ASCII se aplicável]
```

### Componentes

| Componente | Responsabilidade | Localização |
|------------|-----------------|-------------|
| ... | ... | ... |

### Contratos de Interface

<!-- APIs, eventos, contratos de dados que este componente expõe ou consome. -->

#### Endpoint / Evento: [Nome]
- **Input:** ...
- **Output:** ...
- **Erros:** ...

### Modelo de Dados

<!-- Estrutura de dados relevante. -->

```
[Schema ou estrutura de exemplo]
```

### Fluxo Principal

1. ...
2. ...
3. ...

### Fluxos Alternativos / Erros

- **Caso [X]:** ...

## Requisitos Não-Funcionais

| Requisito | Target | Observações |
|-----------|--------|-------------|
| Latência p99 | < Xms | ... |
| Disponibilidade | 99.X% | ... |
| Segurança | ... | ... |

## Alternativas Consideradas

<!-- Obrigatório: por que esse design foi escolhido sobre outros. -->

### Alternativa: [Nome]
- Rejeitada porque: ...

## Plano de Implementação

1. ...
2. ...

## Critérios de Aceite

- [ ] ...
- [ ] ...

## Referências

- ADR relacionado: ...
- Docs externos: ...
