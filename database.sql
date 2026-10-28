-- ========================================================================
-- PROJETO PETSHOP - BANCO DE DADOS E SCRIPTS
-- ========================================================================
-- INTEGRANTES:
-- Nathan
-- Julia Rodriguês
-- Kevin
-- Ester

-- ========================================================================

-- ==========================================
-- 1. CRIAÇÃO DO BANCO DE DADOS
-- ==========================================
CREATE DATABASE IF NOT EXISTS petshop_db;
USE petshop_db;

-- Limpeza preventiva de tabelas existentes
DROP VIEW IF EXISTS VW_RELATORIO_EXECUTIVO_ATENDIMENTOS;
DROP TABLE IF EXISTS AVALIACAO;
DROP TABLE IF EXISTS ITEM_AGENDAMENTO;
DROP TABLE IF EXISTS AGENDAMENTO;
DROP TABLE IF EXISTS SERVICO;
DROP TABLE IF EXISTS PROFISSIONAL;
DROP TABLE IF EXISTS ESPECIALIDADE;
DROP TABLE IF EXISTS PACIENTE_PET;
DROP TABLE IF EXISTS CLIENTE;

--

-- ==========================================
-- 2. CRIAÇÃO DAS TABELAS (DDL)
-- ==========================================

-- Tabela CLIENTE
CREATE TABLE CLIENTE (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    telefone VARCHAR(15),
    email VARCHAR(100)
);

-- Tabela PACIENTE_PET
CREATE TABLE PACIENTE_PET (
    id_pet INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    especie VARCHAR(30) NOT NULL,
    raca VARCHAR(50),
    data_nascimento DATE,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente) ON DELETE CASCADE
);

-- Tabela ESPECIALIDADE
CREATE TABLE ESPECIALIDADE (
    id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome_especialidade VARCHAR(50) NOT NULL
);

-- Tabela PROFISSIONAL (Inclui CRMV)
CREATE TABLE PROFISSIONAL (
    id_profissional INT AUTO_INCREMENT PRIMARY KEY,
    id_especialidade INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    crmv VARCHAR(20) UNIQUE NULL,
    telefone VARCHAR(15),
    FOREIGN KEY (id_especialidade) REFERENCES ESPECIALIDADE(id_especialidade)
);

-- Tabela SERVICO
CREATE TABLE SERVICO (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    nome_servico VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    duracao_minutos INT NOT NULL
);

-- Tabela AGENDAMENTO
CREATE TABLE AGENDAMENTO (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_pet INT NOT NULL,
    id_profissional INT NOT NULL,
    data_hora DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'Agendado', -- 'Agendado', 'Concluído', 'Cancelado'
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente),
    FOREIGN KEY (id_pet) REFERENCES PACIENTE_PET(id_pet),
    FOREIGN KEY (id_profissional) REFERENCES PROFISSIONAL(id_profissional)
);

-- Tabela ITEM_AGENDAMENTO
CREATE TABLE ITEM_AGENDAMENTO (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_agendamento INT NOT NULL,
    id_servico INT NOT NULL,
    valor_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_agendamento) REFERENCES AGENDAMENTO(id_agendamento) ON DELETE CASCADE,
    FOREIGN KEY (id_servico) REFERENCES SERVICO(id_servico)
);

-- Tabela AVALIACAO
CREATE TABLE AVALIACAO (
    id_avaliacao INT AUTO_INCREMENT PRIMARY KEY,
    id_agendamento INT NOT NULL UNIQUE,
    nota INT CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    data_avaliacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_agendamento) REFERENCES AGENDAMENTO(id_agendamento)
);

-- ==========================================
-- 3. INSERÇÃO DE DADOS DE TESTE (DML)
-- ==========================================

-- Clientes
INSERT INTO CLIENTE (nome, cpf, telefone, email) VALUES 
('Alice Silva', '12345678901', '11999999999', 'alicesilva@gmail.com'),
('Bruno Fernandes', '23456789012', '11988887777', 'bruno.f@gmail.com'),
('Carla Mendes', '34567890123', '11977778888', 'carla.mendes@hotmail.com'),
('Diogo Ramos', '45678901234', '11966665555', 'diogo.ramos@yahoo.com'),
('Clarice Braga', '12345674357', '11989999999', 'bragaclarice@gmail.com'),
('Brian Fernandes', '23485389012', '11988887771', 'brian.f@gmail.com'),
('Camila Mendes', '34567890321', '11977778899', 'c.mendes@hotmail.com'),
('Sergio Ramos', '47658901234', '11966665444', 'sergio.ramos@gmail.com');

-- Pets
INSERT INTO PACIENTE_PET (id_cliente, nome, especie, raca, data_nascimento) VALUES 
(1, 'Mel', 'Cão', 'Poodle', '2022-05-10'),
(1, 'Thor', 'Cão', 'Bulldog Francês', '2021-04-10'),
(2, 'Mingau', 'Gato', 'Siamês', '2022-08-15'),
(3, 'Bob', 'Cão', 'Golden Retriever', '2020-01-20'),
(4, 'Luna', 'Gato', 'Persa', '2023-02-01'),
(5, 'Marley', 'Cão', 'Labrador', '2019-11-19'),
(5, 'Max', 'Cão', 'Vira Lata', '2021-05-11'),
(6, 'Boda', 'Gato', 'Siamês', '2020-08-15'),
(7, 'Pigmeu', 'Cão', 'Golden Retriever', '2021-02-20'),
(8, 'Pepe', 'Gato', 'Sem raça', '2012-02-01');

-- Especialidades
INSERT INTO ESPECIALIDADE (nome_especialidade) VALUES 
('Groomer / Estética'),
('Medicina Veterinária Geral'),
('Dermatologia Veterinária');

-- Profissionais
INSERT INTO PROFISSIONAL (id_especialidade, nome, crmv, telefone) VALUES 
(1, 'Carlos Tosa', NULL, '11977776666'),
(2, 'Dra. Mariana Costa', 'SP-12345', '11955554444'),
(3, 'Dr. Roberto Lima', 'SP-67890', '11944443333'),
(1, 'Bianca Tosa', NULL, '11977776662'),
(2, 'Dr. Mariano Costa', 'SP-12675', '11955354444'),
(3, 'Dra. Roberta Lira', 'SP-67891', '11944443332');

-- Serviços
INSERT INTO SERVICO (nome_servico, preco, duracao_minutos) VALUES 
('Banho e Tosa Completo', 90.00, 60),
('Consulta Clínica', 150.00, 45),
('Vacinação Antirrábica', 75.00, 20),
('Hidratação e Tosa Higiênica', 120.00, 80),
('Exame Dermatológico', 180.00, 50);

-- Agendamentos
INSERT INTO AGENDAMENTO (id_cliente, id_pet, id_profissional, data_hora, status) VALUES 
(1, 1, 1, '2026-10-05 14:00:00', 'Concluído'),
(1, 2, 2, '2026-10-06 10:30:00', 'Concluído'),
(2, 3, 2, '2026-10-07 11:00:00', 'Concluído'),
(3, 4, 1, '2026-10-08 15:00:00', 'Concluído'),
(4, 5, 3, '2026-10-09 16:30:00', 'Agendado'),
(1, 1, 1, '2026-10-10 09:00:00', 'Cancelado'),
(5, 5, 5, '2026-10-24 14:00:00', 'Concluído'),
(5, 6, 5, '2026-10-24 14:30:00', 'Concluído'),
(6, 7, 6, '2026-10-25 11:00:00', 'Concluído'),
(7, 8, 4, '2026-10-24 15:00:00', 'Concluído'),
(8, 9, 6, '2026-10-25 12:30:00', 'Agendado'),
(8, 9, 4, '2026-10-25 15:00:00', 'Cancelado');

-- Itens do Agendamento
INSERT INTO ITEM_AGENDAMENTO (id_agendamento, id_servico, valor_unitario) VALUES 
(1, 1, 90.00),
(2, 2, 150.00),
(2, 3, 75.00),
(3, 2, 150.00),
(4, 1, 90.00),
(4, 4, 120.00),
(5, 5, 180.00),
(7, 2, 150.00),
(7, 3, 75.00),
(8, 2, 150.00),
(9, 2, 150.00),
(9, 5, 180.00),
(10, 1, 108.90),
(11, 2, 150.00),
(12, 4, 145.50);

-- Avaliações
INSERT INTO AVALIACAO (id_agendamento, nota, comentario) VALUES 
(1, 5, 'Excelente atendimento na tosa da Mel!'),
(2, 4, 'Consulta pontual e esclarecedora.'),
(3, 5, 'A Dra. Mariana cuidou muito bem do Mingau.'),
(4, 5, 'Bob saiu cheiroso e muito bem tosado.'),
(7, 5, 'Dr. Mariano super educado!'),
(8, 4, 'Consulta pontual e esclarecedora.'),
(9, 5, 'A Dra. Roberta cuidou muito bem da Boda, otimo atendimento felino.'),
(10, 5, 'O Pigmeu saiu super cheiroso e com a tosa perfeita pela Bianca.');

-- ========================================================================
-- 4. BATERIA DE 10 SCRIPTS SQL AVULSOS
-- ========================================================================

-- ------------------------------------------------------------------------
-- BLOCO A: CONSULTAS COM JOINS (Junção de 2, 3 ou mais tabelas)
-- ------------------------------------------------------------------------

-- Script 01: Relatório de Pets e seus Tutores (2 Tabelas)
SELECT
    p.id_pet,
    p.nome AS nome_pet,
    p.especie,
    p.raca,
    c.nome AS nome_tutor,
    c.telefone,
    c.email
FROM PACIENTE_PET p
INNER JOIN CLIENTE c ON p.id_cliente = c.id_cliente
ORDER BY c.nome, p.nome;

-- Script 02: Detalhes Completos do Agendamento Clínico (5 Tabelas)
SELECT
    a.id_agendamento,
    a.data_hora,
    a.status,
    c.nome AS tutor,
    p.nome AS pet,
    pr.nome AS profissional,
    pr.crmv,
    e.nome_especialidade AS especialidade
FROM AGENDAMENTO a
INNER JOIN CLIENTE c ON a.id_cliente = c.id_cliente
INNER JOIN PACIENTE_PET p ON a.id_pet = p.id_pet
INNER JOIN PROFISSIONAL pr ON a.id_profissional = pr.id_profissional
INNER JOIN ESPECIALIDADE e ON pr.id_especialidade = e.id_especialidade
ORDER BY a.data_hora DESC;

-- Script 03: Relatório de Satisfação e Avaliações por Serviço (4 Tabelas)
SELECT
    a.id_agendamento,
    c.nome AS tutor,
    s.nome_servico,
    av.nota,
    av.comentario,
    av.data_avaliacao
FROM AVALIACAO av
INNER JOIN AGENDAMENTO a ON av.id_agendamento = a.id_agendamento
INNER JOIN CLIENTE c ON a.id_cliente = c.id_cliente
INNER JOIN ITEM_AGENDAMENTO ia ON a.id_agendamento = ia.id_agendamento
INNER JOIN SERVICO s ON ia.id_servico = s.id_servico
ORDER BY av.nota DESC;

-- ------------------------------------------------------------------------
-- BLOCO B: CONSULTAS DE AGREGAÇÃO (COUNT, SUM, AVG, GROUP BY, HAVING)
-- ------------------------------------------------------------------------

-- Script 04: Clientes com múltiplos pets cadastrados (COUNT, GROUP BY, HAVING)
SELECT
    c.id_cliente,
    c.nome AS cliente,
    COUNT(p.id_pet) AS total_pets
FROM CLIENTE c
INNER JOIN PACIENTE_PET p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nome
HAVING COUNT(p.id_pet) > 1
ORDER BY total_pets DESC;

-- Script 05: Faturamento e Volume de Vendas por Serviço (COUNT, SUM, AVG, GROUP BY)
SELECT
    s.nome_servico,
    COUNT(ia.id_item) AS total_realizacoes,
    SUM(ia.valor_unitario) AS receita_total,
    CAST(AVG(ia.valor_unitario) AS DECIMAL(10, 2)) AS ticket_medio
FROM SERVICO s
INNER JOIN ITEM_AGENDAMENTO ia ON s.id_servico = ia.id_servico
GROUP BY s.id_servico, s.nome_servico
ORDER BY receita_total DESC;

-- Script 06: Média de Satisfação por Profissional (AVG, COUNT, GROUP BY, HAVING)
SELECT
    pr.nome AS profissional,
    COUNT(av.id_avaliacao) AS total_avaliacoes,
    ROUND(AVG(av.nota), 2) AS media_satisfacao
FROM PROFISSIONAL pr
INNER JOIN AGENDAMENTO a ON pr.id_profissional = a.id_profissional
INNER JOIN AVALIACAO av ON a.id_agendamento = av.id_agendamento
GROUP BY pr.id_profissional, pr.nome
HAVING AVG(av.nota) >= 4.0
ORDER BY media_satisfacao DESC;

-- ------------------------------------------------------------------------
-- BLOCO C: FILTROS E ORDENAÇÃO (WHERE, LIKE, BETWEEN, ORDER BY)
-- ------------------------------------------------------------------------

-- Script 07: Busca de Clientes por domínio de email e ordenação (WHERE, LIKE, ORDER BY)
SELECT
    id_cliente,
    nome,
    cpf,
    telefone,
    email
FROM CLIENTE
WHERE email LIKE '%@gmail.com'
ORDER BY nome ASC;

-- Script 08: Agendamentos ativos em um intervalo de datas (WHERE, BETWEEN, ORDER BY)
SELECT
    id_agendamento,
    data_hora,
    status,
    id_cliente,
    id_pet,
    id_profissional
FROM AGENDAMENTO
WHERE data_hora BETWEEN '2026-10-01 00:00:00' AND '2026-10-25 23:59:59'
  AND status <> 'Cancelado'
ORDER BY data_hora ASC;

-- ------------------------------------------------------------------------
-- BLOCO D: MANIPULAÇÃO DE DADOS (DML: UPDATE e DELETE)
-- ------------------------------------------------------------------------

-- Script 09: Reajuste de 10% no preço de serviços longos (UPDATE)
UPDATE SERVICO
SET preco = preco * 1.10
WHERE  id_servico > 0
AND duracao_minutos >= 60;

-- Script 10: Limpeza de agendamentos com status cancelado (DELETE)

DELETE FROM AGENDAMENTO
WHERE  status = 'Cancelado';

SET SQL_SAFE_UPDATES = 0;

DELETE FROM AGENDAMENTO WHERE status = 'Cancelado';

SET SQL_SAFE_UPDATES = 1;

-- ========================================================================
-- 5. VIEW ESTRATÉGICA OBRIGATÓRIA (DASHBOARD EXECUTIVO)
-- ========================================================================

-- Criação da View Executiva
CREATE OR REPLACE VIEW VW_RELATORIO_EXECUTIVO_ATENDIMENTOS AS
SELECT
    a.id_agendamento,
    a.data_hora AS data_atendimento,
    a.status AS status_agendamento,
    c.nome AS nome_cliente,
    c.telefone AS contacto_cliente,
    p.nome AS nome_pet,
    p.especie,
    pr.nome AS profissional_responsavel,
    pr.crmv,
    e.nome_especialidade,
    COALESCE(SUM(ia.valor_unitario), 0.00) AS valor_total_agendamento,
    COUNT(ia.id_item) AS total_itens_servicos
FROM AGENDAMENTO a
INNER JOIN CLIENTE c ON a.id_cliente = c.id_cliente
INNER JOIN PACIENTE_PET p ON a.id_pet = p.id_pet
INNER JOIN PROFISSIONAL pr ON a.id_profissional = pr.id_profissional
INNER JOIN ESPECIALIDADE e ON pr.id_especialidade = e.id_especialidade
LEFT JOIN ITEM_AGENDAMENTO ia ON a.id_agendamento = ia.id_agendamento
GROUP BY
    a.id_agendamento,
    a.data_hora,
    a.status,
    c.nome,
    c.telefone,
    p.nome,
    p.especie,
    pr.nome,
    pr.crmv,
    e.nome_especialidade;

-- Consulta da View
SELECT *
FROM VW_RELATORIO_EXECUTIVO_ATENDIMENTOS
ORDER BY data_atendimento DESC;
