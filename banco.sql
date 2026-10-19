-- ============================================================
-- SCRIPT DE CRIAÇÃO DO BANCO DE DADOS - VEM LANCHE!
-- ============================================================

-- 1. Tabela de Turmas
CREATE TABLE turmas (
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL, -- Ex: '1º Ano EM', '6º Ano A'
    ano_letivo VARCHAR(10) DEFAULT '2026',
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabela de Alunos
CREATE TABLE alunos (
    id BIGSERIAL PRIMARY KEY,
    turma_id BIGINT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    matricula VARCHAR(30) UNIQUE,
    cpf_responsavel VARCHAR(14),
    telefone_responsavel VARCHAR(20),
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_aluno_turma FOREIGN KEY (turma_id) REFERENCES turmas(id) ON DELETE RESTRICT
);

-- 3. Tabela de Cartões Pré-Pagos
CREATE TABLE cartoes (
    id BIGSERIAL PRIMARY KEY,
    aluno_id BIGINT NOT NULL UNIQUE, -- Relacionamento 1 para 1 com Aluno
    codigo_cartao VARCHAR(20) NOT NULL UNIQUE, -- Ex: 'VEM-1001'
    saldo_atual DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (saldo_atual >= 0),
    status VARCHAR(20) DEFAULT 'ATIVO' CHECK (status IN ('ATIVO', 'BLOQUEADO', 'CANCELADO')),
    emitido_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cartao_aluno FOREIGN KEY (aluno_id) REFERENCES alunos(id) ON DELETE CASCADE
);

-- 4. Tabela de Categorias de Produtos
CREATE TABLE categorias (
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    ativo BOOLEAN DEFAULT TRUE
);

-- 5. Tabela de Produtos
CREATE TABLE produtos (
    id BIGSERIAL PRIMARY KEY,
    categoria_id BIGINT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL CHECK (preco >= 0),
    estoque_atual INT NOT NULL DEFAULT 0 CHECK (estoque_atual >= 0),
    imagem_url VARCHAR(255),
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_produto_categoria FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE RESTRICT
);

-- 6. Tabela de Vendas (Cabeçalho da Compras)
CREATE TABLE vendas (
    id BIGSERIAL PRIMARY KEY,
    cartao_id BIGINT NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL CHECK (valor_total >= 0),
    status VARCHAR(20) DEFAULT 'CONCLUIDA' CHECK (status IN ('CONCLUIDA', 'CANCELADA')),
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_venda_cartao FOREIGN KEY (cartao_id) REFERENCES cartoes(id) ON DELETE RESTRICT
);

-- 7. Tabela de Itens da Venda (Detalhe)
CREATE TABLE itens_venda (
    id BIGSERIAL PRIMARY KEY,
    venda_id BIGINT NOT NULL,
    produto_id BIGINT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10, 2) NOT NULL CHECK (preco_unitario >= 0),
    subtotal DECIMAL(10, 2) NOT NULL CHECK (subtotal >= 0),
    CONSTRAINT fk_item_venda FOREIGN KEY (venda_id) REFERENCES vendas(id) ON DELETE CASCADE,
    CONSTRAINT fk_item_produto FOREIGN KEY (produto_id) REFERENCES produtos(id) ON DELETE RESTRICT
);

-- 8. Tabela de Recargas
CREATE TABLE recargas (
    id BIGSERIAL PRIMARY KEY,
    cartao_id BIGINT NOT NULL,
    valor DECIMAL(10, 2) NOT NULL CHECK (valor > 0),
    forma_pagamento VARCHAR(30) NOT NULL CHECK (forma_pagamento IN ('PIX', 'DINHEIRO', 'CARTAO_CREDITO', 'CARTAO_DEBITO')),
    data_recarga TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_recarga_cartao FOREIGN KEY (cartao_id) REFERENCES cartoes(id) ON DELETE RESTRICT
);

-- 9. Tabela de Transações / Extrato (Histórico Unificado de Entradas e Saídas)
CREATE TABLE transacoes_saldo (
    id BIGSERIAL PRIMARY KEY,
    cartao_id BIGINT NOT NULL,
    tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('CREDITO', 'DEBITO')),
    valor DECIMAL(10, 2) NOT NULL CHECK (valor > 0),
    saldo_anterior DECIMAL(10, 2) NOT NULL,
    saldo_posterior DECIMAL(10, 2) NOT NULL,
    venda_id BIGINT,
    recarga_id BIGINT,
    descricao VARCHAR(255),
    data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transacao_cartao FOREIGN KEY (cartao_id) REFERENCES cartoes(id) ON DELETE CASCADE,
    CONSTRAINT fk_transacao_venda FOREIGN KEY (venda_id) REFERENCES vendas(id) ON DELETE SET NULL,
    CONSTRAINT fk_transacao_recarga FOREIGN KEY (recarga_id) REFERENCES recargas(id) ON DELETE SET NULL
);

-- ============================================================
-- ÍNDICES PARA OTIMIZAÇÃO DE BUSCAS
-- ============================================================
CREATE INDEX idx_cartoes_codigo ON cartoes(codigo_cartao);
CREATE INDEX idx_vendas_data ON vendas(data_venda);
CREATE INDEX idx_recargas_cartao ON recargas(cartao_id);
CREATE INDEX idx_transacoes_cartao ON transacoes_saldo(cartao_id);