[readme_vem_lanches.md](https://github.com/user-attachments/files/33765993/readme_vem_lanches.md)
# 🍔 Vem Lanches! — Cartão Pré-Pago Escolar

[![GitHub Pages](https://img.shields.io/badge/Demo-GitHub%20Pages-0284c7?style=for-the-badge&logo=github)](https://daviclementinonascimento123-arch.github.io/vem-lanches/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](./LICENSE)
[![Version](https://img.shields.io/badge/Version-v1.0.0-15803d?style=for-the-badge)](#-plano-de-versionamento-semver)

O **Vem Lanches!** é uma aplicação web voltada para a gestão de cantinas escolares e controle de consumo de alunos por meio de **cartões pré-pagos**. O sistema digitaliza o processo de vendas, recargas de saldo, controle de turmas, extratos de consumo e relatórios gerenciais em tempo real.

---

## 📌 Principais Objetivos

* **Segurança:** Eliminar a circulação de dinheiro em espécie dentro do ambiente escolar.
* **Controle Financeiro:** Permitir a gestão individualizada de saldos e extratos por aluno e turma.
* **Eficiência Operacional:** Agilizar o atendimento na cantina com um Frente de Caixa (PDV) rápido e intuitivo.
* **Gestão em Tempo Real:** Disponibilizar métricas gerenciais e relatórios consolidados de vendas e produtos mais comercializados.

---

## 🚀 Demonstração em Tempo Real

Acesse a aplicação em execução no GitHub Pages:
👉 **[https://daviclementinonascimento123-arch.github.io/vem-lanches/](https://daviclementinonascimento123-arch.github.io/vem-lanches/)**

---

## 💻 Módulos e Funcionalidades

### 🛒 1. Frente de Caixa (PDV)
* **Seleção do Aluno:** Leitura de QR Code / Código do cartão (`VEM-1001`) ou busca manual.
* **Carrinho de Compras:** Adição de produtos, cálculo automático de subtotal e total da venda.
* **Validação de Saldo:** Verificação automática com alerta de saldo insuficiente e trava de segurança.
* **Métrica Rápida:** Indicador instantâneo das vendas realizadas no dia.

### 💳 2. Gestão de Alunos, Cartões e Recargas
* **Cadastro:** Registro de estudantes vinculados às turmas (ex: *6º Ano A*, *1º Ano EM*).
* **Filtros por Turma:** Organização e busca facilitada de turmas escolares.
* **Consulta de Extrato:** Visualização do saldo atual e histórico completo de movimentações.
* **Recargas Instantâneas:** Injeção de créditos no cartão via PIX, dinheiro, cartão de crédito ou débito.

### 📊 3. Dashboard Gerencial & Histórico
* **Métricas Principais:** Vendas Totais (R$), Número de Vendas, Saldo Circulante e Alunos Ativos.
* **Gráficos e Rankings:** Produtos mais vendidos exibidos dinamicamente.
* **Feed em Tempo Real:** Registro unificado de transações de entrada (créditos) e saída (débitos).

---

## 🗄️ Modelagem do Banco de Dados

O banco de dados relacional foi projetado para garantir consistência financeira, auditabilidade completa e suporte a relatórios analíticos.

```
       +-----------------+             +-----------------+
       |     TURMAS      | 1         N |     ALUNOS      |
       +-----------------+-------------<+-----------------+
       | id (PK)         |             | id (PK)         |
       | nome            |             | turma_id (FK)   |
       +-----------------+             +-----------------+
                                                | 1
                                                |
                                                | 1
                                       +-----------------+
                                       |     CARTOES     |
                                       +-----------------+
                                       | id (PK)         |
                                       | aluno_id (FK)   |
                                       | codigo_cartao   |
                                       | saldo_atual     |
                                       +-----------------+
                                         | 1         | 1
                                         |           |
                                       N |         N |
+-----------------+            +-----------------+  +-----------------+
|    RECARGAS     |            |     VENDAS      |  | TRANSACOES_SALDO|
+-----------------+            +-----------------+  +-----------------+
| id (PK)         |            | id (PK)         |  | id (PK)         |
| cartao_id (FK)  |            | cartao_id (FK)  |  | cartao_id (FK)  |
| valor           |            | valor_total     |  | tipo (CR/DB)    |
| forma_pagamento |            +-----------------+  | saldo_anterior  |
+-----------------+                     | 1         | saldo_posterior |
                                        |           +-----------------+
                                      N |
                               +-----------------+  +-----------------+
                               |   ITENS_VENDA   |  |    PRODUTOS     |
                               +-----------------+  +-----------------+
                               | id (PK)         |N| id (PK)         |
                               | venda_id (FK)   |>-| categoria_id(FK)|
                               | produto_id (FK) |  | preco           |
                               | preco_unitario  |  | estoque_atual   |
                               +-----------------+  +-----------------+
```

### 🔑 Destaques da Arquitetura de Dados:
1. **Ledger / Transações de Saldo (`transacoes_saldo`):** Tabela do tipo *livro-razão* que registra todo histórico de débitos e créditos com `saldo_anterior` e `saldo_posterior`, garantindo auditoria e rápida renderização do extrato.
2. **Imutabilidade de Preço (`itens_venda.preco_unitario`):** Congela o valor do produto no momento exato da compra, prevenindo distorções em relatórios futuros caso o catálogo seja reajustado.
3. **Integridade e Restrições (`CONSTRAINTS`):** Validações via banco de dados (`CHECK`) impedem saldos negativos, estoques e quantidades inválidas.

> 📄 O script de criação das tabelas e índices está disponível no arquivo [`banco.sql`](./banco.sql).

---

## 🛠️ Tecnologias Utilizadas

| Camada | Tecnologia | Finalidade |
| :--- | :--- | :--- |
| **Frontend** | HTML5, CSS3, JavaScript (ES6+) | Single Page Application (SPA) responsiva |
| **Gráficos** | Chart.js / SVG Dinâmico | Visualização de dados gerenciais e vendas |
| **Armazenamento Local**| Web Storage (`localStorage`) | Persistência do estado local e prototipação |
| **Banco de Dados** | PostgreSQL / SQL Relacional | Modelagem e script SQL com DDL completo |
| **Hospedagem** | GitHub Pages | Deploy contínuo do frontend estático |

---

## 💻 Como Executar o Projeto Localmente

### Pré-requisitos
* Um navegador web moderno (Google Chrome, Firefox, Edge, Safari).
* [VS Code](https://code.visualstudio.com/) com a extensão **Live Server** *(opcional, mas recomendado)*.

### Passo a Passo

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/daviclementinonascimento123-arch/vem-lanches.git
   ```

2. **Acesse a pasta do projeto:**
   ```bash
   cd vem-lanches
   ```

3. **Execute a aplicação:**
   * Abra o arquivo `index.html` diretamente no navegador; OU
   * Clique com o botão direito no `index.html` no VS Code e escolha **"Open with Live Server"**.

---

## 🚀 Plano de Versionamento (SemVer)

O projeto adota o padrão **Semantic Versioning (MAJOR.MINOR.PATCH)**:

* `v1.0.0` — **MVP (Versão Atual):** Publicação do frontend estático no GitHub Pages com simulação de PDV, gerenciamento visual de turmas e painel com gráficos.
* `v1.1.0` — **Persistência Local (Planejada):** Implementação robusta do `localStorage` para salvar dados de alunos, cartões e histórico entre sessões.
* `v1.2.0` — **Relatórios & Leitura (Planejada):** Leitura via scanner de código de barras no PDV, alertas sonoros/visuais e exportação de extrato individual em PDF/CSV.
* `v2.0.0` — **Backend REST & Banco em Nuvem (Futura):** Integração com API Backend (Node.js/Python) conectada ao banco de dados PostgreSQL e portal de consulta para os pais.

---

## 👤 Autor

Desenvolvido por **Davi Clementino Nascimento**.

* **GitHub:** [@daviclementinonascimento123-arch](https://github.com/daviclementinonascimento123-arch)
* **Projeto:** [Vem Lanches!](https://github.com/daviclementinonascimento123-arch/vem-lanches)

---

## 📜 Licença

Este projeto está sob a licença [MIT](./LICENSE).
