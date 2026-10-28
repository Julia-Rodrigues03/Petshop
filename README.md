# 🐾 Sistema de Gestão de Pet Shop (`petshop_db`)

Projeto acadêmico de modelagem e implementação de banco de dados relacional para gestão clínica e estética de animais de estimação.

---

## 👥 Integrantes
* Nathan
* Julia Rodriguês
* Kevin
* Ester

---

## 📌 Arquitetura do Banco de Dados
O banco foi normalizado garantindo integridade referencial por chaves primárias (`PK`) e estrangeiras (`FK`).

### Tabelas Principais
1. **`CLIENTE`**: Tutores e dados de contacto.
2. **`PACIENTE_PET`**: Cadastro dos animais vinculados aos tutores.
3. **`ESPECIALIDADE`**: Áreas de atuação (Estética, Clínica Geral, Especialidades).
4. **`PROFISSIONAL`**: Médicos veterinários (com CRMV) e groomers/tosadores.
5. **`SERVICO`**: Catálogo de procedimentos e preços base.
6. **`AGENDAMENTO`**: Controlo de marcações e estados de atendimento.
7. **`ITEM_AGENDAMENTO`**: Associação de múltiplos procedimentos a um atendimento (`1:N`).
8. **`AVALIACAO`**: Métrica de satisfação (1 a 5 via `CHECK`) e feedback de tutores.

---

## 🚀 Como Executar no MySQL
1. Executar o script `sql/01_ddl_criacao_banco.sql`.
2. Executar o script `sql/02_dml_carga_dados.sql`.
3. Consultar os relatórios analíticos em `sql/03_consultas_relatorios.sql`.
4. Consultar o dashboard executivo em `sql/04_view_dashboard.sql`.

---

## 📊 Principais Tecnologias e Recursos SQL Explorados
* **Integridade de Domínio:** Restrições com `CHECK (nota BETWEEN 1 AND 5)`.
* **Tratamento de Nulos:** `COALESCE` para retorno amigável de somas financeiras.
* **Formatação Numérica:** `ROUND` e `CAST` para duas casas decimais.
* **Agregações Avançadas:** `GROUP BY` combinado com `HAVING` para regras de negócio pós-cálculo.
* **Painel Executivo:** View analítica (`VW_RELATORIO_EXECUTIVO_ATENDIMENTOS`).