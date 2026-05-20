# Catálogo de Padrões Arquiteturais

> Referência rápida para a sessão principal e para `@principal`. Para cada padrão: quando usar, quando NÃO usar, e impacto no time.

---

## Padrões de Organização de Código

### Layered Architecture (N-Tiers)
**Quando usar:** A maioria dos sistemas CRUD, APIs simples, times pequenos.
**Quando NÃO usar:** Quando a lógica de domínio é complexa e se mistura nas camadas.
**Camadas típicas:** Controller → Service → Repository → Database
**Custo:** Baixo. Familiar para a maioria dos devs.

---

### Clean Architecture / Hexagonal (Ports & Adapters)
**Quando usar:** Domínio rico, múltiplas integrações externas, alta testabilidade necessária.
**Quando NÃO usar:** CRUD simples, times inexperientes com o padrão, prazo curto.
**Princípio chave:** O domínio não depende de nada externo — frameworks, DBs, APIs são adaptadores.
**Custo:** Alto. Requer disciplina e onboarding.

---

### Modular Monolith
**Quando usar:** Times médios, domínio moderado, preparação para eventual decomposição em serviços.
**Quando NÃO usar:** Sistema já pequeno que não crescerá, ou quando escala de times já exige separação.
**Princípio chave:** Módulos com fronteiras claras, mas implantação única.
**Custo:** Médio. Bom equilíbrio entre organização e simplicidade operacional.

---

## Padrões de Dados

### CQRS (Command Query Responsibility Segregation)
**Quando usar:** Leitura e escrita têm requisitos muito diferentes, domínio complexo, alta escala de leitura.
**Quando NÃO usar:** CRUD simples, times pequenos, sem necessidade de otimizar leitura separadamente.
**Custo:** Alto. Introduz complexidade de sincronização e dois modelos de dados.

---

### Event Sourcing
**Quando usar:** Auditoria completa obrigatória, reconstrução de estado histórico, domínio orientado a eventos.
**Quando NÃO usar:** A maioria dos sistemas. É uma solução especializada para problemas específicos.
**Custo:** Muito alto. Requer maturidade de time e infraestrutura.

---

### Repository Pattern
**Quando usar:** Sempre que houver acesso a dados que precisam ser testáveis e intercambiáveis.
**Quando NÃO usar:** Scripts simples, sem necessidade de teste ou abstração de DB.
**Custo:** Baixo. Altamente recomendado por padrão.

---

## Padrões de Comunicação

### REST
**Quando usar:** APIs públicas, integrações simples, interoperabilidade ampla.
**Quando NÃO usar:** Quando contratos fortemente tipados são necessários (preferir GraphQL ou gRPC).
**Custo:** Baixo.

---

### GraphQL
**Quando usar:** Frontend com necessidades variadas de dados, múltiplos clientes com queries diferentes.
**Quando NÃO usar:** APIs simples e previsíveis, times sem experiência com o paradigma.
**Custo:** Médio. Complexidade de resolver, N+1, caching.

---

### gRPC / Protobuf
**Quando usar:** Comunicação interna entre serviços, alta performance, contratos fortemente tipados.
**Quando NÃO usar:** APIs públicas, clientes browser sem proxy.
**Custo:** Médio. Exige tooling e disciplina de versionamento de schema.

---

### Message Queue / Event Bus
**Quando usar:** Desacoplamento de serviços, processamento assíncrono, resiliência a picos.
**Quando NÃO usar:** Quando consistência síncrona é obrigatória, times sem experiência em sistemas distribuídos.
**Custo:** Alto. Introduz complexidade de entrega, ordenação e idempotência.

---

## Padrões de Deployment

### Monolito
**Quando usar:** Times pequenos, produto no início, velocidade de desenvolvimento prioritária.
**Custo:** Baixo. Simples de operar.

### Microserviços
**Quando usar:** Times grandes e independentes, escalabilidade granular necessária, produto maduro.
**Quando NÃO usar:** Times pequenos, produto early-stage, falta de maturidade em DevOps.
**Custo:** Muito alto. Rede, observabilidade, deploys, contratos — tudo fica mais complexo.

### BFF (Backend for Frontend)
**Quando usar:** Múltiplos clientes (mobile, web, third-party) com necessidades diferentes de API.
**Custo:** Médio. Introduz uma camada extra mas simplifica os clientes.

---

## Como Usar Este Catálogo

1. Identifique o problema arquitetural
2. Consulte os padrões candidatos
3. Avalie o custo vs. benefício para o contexto específico do projeto
4. Documente a escolha em um ADR se for uma decisão cross-cutting
