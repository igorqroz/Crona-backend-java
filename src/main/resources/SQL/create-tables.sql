-- Criação das tabelas de domínio/referência (sem chaves estrangeiras)
CREATE TABLE TB_EMPRESA
(
    CD_EMPRESA   INT PRIMARY KEY,
    RAZAO_SOCIAL VARCHAR(255)       NOT NULL,
    CNPJ         VARCHAR(18) UNIQUE NOT NULL,
    CONTATO      VARCHAR(100),
    RAMO         VARCHAR(100),
    EMAIL        VARCHAR(150)
);

CREATE TABLE TB_TIPO_USUARIO
(
    CD_TIPO_USUARIO   INT PRIMARY KEY,
    DESCRICAO_USUARIO VARCHAR(100) NOT NULL
);

CREATE TABLE TB_TIPO_CONTRATO
(
    CD_TIPO_CONTRATO   INT PRIMARY KEY,
    DESCRICAO_CONTRATO VARCHAR(100) NOT NULL
);

CREATE TABLE TB_TIPO_SOLICITACAO
(
    CD_TIPO_SOLICITACAO INT PRIMARY KEY,
    DESCRICAO           VARCHAR(100) NOT NULL
);

-- Criação da tabela de departamento (depende de Empresa)
CREATE TABLE TB_DEPARTAMENTO
(
    CD_DEPARTAMENTO     INT PRIMARY KEY,
    CD_EMPRESA          INT NOT NULL,
    GESTOR              VARCHAR(150),
    NUM_COLABORADORES   INT,
    MAX_SIMULTANEOS     INT,
    PERIODO_CRITICO_INI DATE,
    PERIODO_CRITICO_FIM DATE,
    CONSTRAINT FK_DEPTO_EMPRESA FOREIGN KEY (CD_EMPRESA) REFERENCES TB_EMPRESA (CD_EMPRESA)
);

-- Criação da tabela de usuário (depende de Empresa, Departamento, Tipo de Contrato e Tipo de Usuário)
CREATE TABLE TB_USUARIO
(
    CD_USUARIO       INT PRIMARY KEY,
    CD_EMPRESA       INT                NOT NULL,
    CD_DEPARTAMENTO  INT                NOT NULL,
    CD_TIPO_CONTRATO INT                NOT NULL,
    CD_TIPO_USUARIO  INT, -- Adicionado para satisfazer o relacionamento "Um para Muitos" do diagrama
    NOME             VARCHAR(255)       NOT NULL,
    DATA_ADMISSAO    DATE,
    CPF              VARCHAR(14) UNIQUE NOT NULL,
    TELEFONE         VARCHAR(20),
    CARGO            VARCHAR(100),
    ATIVO            BOOLEAN DEFAULT TRUE,
    CONSTRAINT FK_USUARIO_EMPRESA FOREIGN KEY (CD_EMPRESA) REFERENCES TB_EMPRESA (CD_EMPRESA),
    CONSTRAINT FK_USUARIO_DEPTO FOREIGN KEY (CD_DEPARTAMENTO) REFERENCES TB_DEPARTAMENTO (CD_DEPARTAMENTO),
    CONSTRAINT FK_USUARIO_CONTRATO FOREIGN KEY (CD_TIPO_CONTRATO) REFERENCES TB_TIPO_CONTRATO (CD_TIPO_CONTRATO),
    CONSTRAINT FK_USUARIO_TIPO FOREIGN KEY (CD_TIPO_USUARIO) REFERENCES TB_TIPO_USUARIO (CD_TIPO_USUARIO)
);

-- Criação da tabela de férias (depende de Usuário e Tipo de Solicitação)
CREATE TABLE TB_FERIAS
(
    CD_FERIAS           INT PRIMARY KEY,
    CD_USUARIO          INT  NOT NULL,
    CD_TIPO_SOLICITACAO INT  NOT NULL,
    DATA_INI_FERIAS     DATE NOT NULL,
    DATA_FIM_FERIAS     DATE NOT NULL,
    OBSERVACAO          TEXT,
    CONSTRAINT FK_FERIAS_USUARIO FOREIGN KEY (CD_USUARIO) REFERENCES TB_USUARIO (CD_USUARIO),
    CONSTRAINT FK_FERIAS_SOLICITACAO FOREIGN KEY (CD_TIPO_SOLICITACAO) REFERENCES TB_TIPO_SOLICITACAO (CD_TIPO_SOLICITACAO)
);

-- 1. População das tabelas de domínio/referência
INSERT INTO TB_EMPRESA (CD_EMPRESA, RAZAO_SOCIAL, CNPJ, CONTATO, RAMO, EMAIL)
VALUES (1, 'Tech Solutions S.A.', '12.345.678/0001-90', 'Carlos Mendes', 'Tecnologia da Informação',
        'contato@techsolutions.com.br'),
       (2, 'Global Varejo Ltda', '98.765.432/0001-10', 'Fernanda Souza', 'Comércio Varejista',
        'rh@globalvarejo.com.br');

INSERT INTO TB_TIPO_USUARIO (CD_TIPO_USUARIO, DESCRICAO_USUARIO)
VALUES (1, 'Administrador'),
       (2, 'Usuario');

INSERT INTO TB_TIPO_CONTRATO (CD_TIPO_CONTRATO, DESCRICAO_CONTRATO)
VALUES (1, 'CLT - Tempo Indeterminado'),
       (2, 'PJ - Prestador de Serviços'),
       (3, 'Estágio');

INSERT INTO TB_TIPO_SOLICITACAO (CD_TIPO_SOLICITACAO, DESCRICAO)
VALUES (1, 'Férias Regulamentares (30 dias)'),
       (2, 'Férias Fracionadas'),
       (3, 'Abono Pecuniário (Venda de 1/3)');

-- 2. População da tabela de departamento (Requer Empresa)
INSERT INTO TB_DEPARTAMENTO (CD_DEPARTAMENTO, CD_EMPRESA, GESTOR, NUM_COLABORADORES, MAX_SIMULTANEOS,
                             PERIODO_CRITICO_INI, PERIODO_CRITICO_FIM)
VALUES (1, 1, 'Roberto Alves', 15, 2, '2026-11-01',
        '2026-12-31'),                                             -- Departamento de TI da Tech Solutions (Não pode sair muita gente no fim do ano)
       (2, 1, 'Juliana Castro', 5, 1, '2026-03-01', '2026-04-30'), -- RH da Tech Solutions
       (3, 2, 'Marcos Paulo', 30, 4, '2026-11-15', '2026-12-25');
-- Vendas da Global Varejo (Período de Black Friday/Natal)

-- 3. População da tabela de usuário (Requer Empresa, Departamento, Contrato e Tipo de Usuário)
INSERT INTO TB_USUARIO (CD_USUARIO, CD_EMPRESA, CD_DEPARTAMENTO, CD_TIPO_CONTRATO, CD_TIPO_USUARIO, NOME, DATA_ADMISSAO,
                        CPF, TELEFONE, CARGO, ATIVO)
VALUES (1, 1, 1, 1, 2, 'Roberto Alves', '2020-05-10', '111.222.333-44', '(11) 98888-7777', 'Gerente de TI', TRUE),
       (3, 1, 2, 1, 1, 'Juliana Castro', '2019-02-01', '999.888.777-66', '(11) 96666-5555', 'Diretora de RH', TRUE),
       (4, 2, 3, 1, 2, 'Marcos Paulo', '2021-11-20', '333.444.555-22', '(21) 95555-4444', 'Coordenador de Vendas',
        TRUE);

-- 4. População da tabela de férias (Requer Usuário e Tipo de Solicitação)
INSERT INTO TB_FERIAS (CD_FERIAS, CD_USUARIO, CD_TIPO_SOLICITACAO, DATA_INI_FERIAS, DATA_FIM_FERIAS, OBSERVACAO)
VALUES (2, 4, 2, '2026-05-10', '2026-05-24', 'Primeira parcela de férias fracionadas (15 dias).'),
       (3, 3, 3, '2026-09-01', '2026-09-20', 'Gozo de 20 dias, abono de 10 dias solicitado.');
