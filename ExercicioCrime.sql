---- BANCO CRIME

CREATE DATABASE crime;

---- Criando

CREATE SCHEMA dp;

---- Tabelas

CREATE TABLE dp.pessoa (
  id_pessoa SERIAL,
  tx_nome VARCHAR(104),
  tx_cpf VARCHAR(11),
  dt_nascimento DATE,
  tx_endereco VARCHAR(256),
  dt_criado_em TIMESTAMP,
  dt_modificado_em TIMESTAMP,
  cs_ativo BOOLEAN,
  CONSTRAINT PK_pessoa PRIMARY KEY (id_pessoa),
  CONSTRAINT ak_tx_pessoa_cpf unique (tx_cpf)
);

CREATE TABLE dp.crime_pessoa (
  id_crime_pessoa SERIAL,
  tipo VARCHAR(1),
  dt_criado_em TIMESTAMP,
  dt_modificado_em TIMESTAMP,
  cs_ativo BOOLEAN,
  id_pessoa INTEGER NOT NULL,
  id_crime INTEGER NOT NULL,
  CONSTRAINT PK_crime_pessoa PRIMARY KEY (id_crime_pessoa),
  CONSTRAINT ak_pessoa_crime unique (id_pessoa, id_crime)
);

CREATE TABLE dp.crime (
  id_crime SERIAL,
  dt_crime TIMESTAMP,
  tx_local VARCHAR(256),
  tx_observacao TEXT,
  dt_criado_em TIMESTAMP,
  dt_modificado_em TIMESTAMP,
  cs_ativo BOOLEAN,
  id_tipo_crime INTEGER NOT NULL,
  CONSTRAINT PK_crime PRIMARY KEY (id_crime)
);

CREATE TABLE dp.tipo_crime (
  id_tipo_crime SERIAL,
  tx_nome VARCHAR(104),
  tempo_minimo_prisao SMALLINT,
  tempo_maximo_prisao SMALLINT,
  tempo_prescricao SMALLINT,
  dt_criado_em TIMESTAMP,
  dt_modificado_em TIMESTAMP,
  cs_ativo BOOLEAN,
  CONSTRAINT PK_tipo_crime PRIMARY KEY (id_tipo_crime),
  CONSTRAINT ak_tx_tipo_crime_nome unique (tx_nome)
);

CREATE TABLE dp.crime_arma (
  id_crime_arma SERIAL,
  dt_criado_em TIMESTAMP,
  dt_modificado_em TIMESTAMP,
  cs_ativo BOOLEAN,
  id_arma INTEGER NOT NULL,
  id_crime INTEGER NOT NULL,
  CONSTRAINT PK_crime_arma PRIMARY KEY (id_crime_arma)
  CONSTRAINT Ak_crime_arma unique (id_arma, id_crime),
);

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
SELECT uuid_generate_v4();

CREATE TABLE dp.arma (
  id_arma SERIAL,
  numero_serie uuid DEFAULT uuid_generate_v4 (),
  nb_tipo INTEGER NOT NULL,
  tx_descriminacao VARCHAR(256),
  dt_criado_em TIMESTAMP,
  dt_modificado_em TIMESTAMP,
  CONSTRAINT PK_arma PRIMARY KEY (id_arma)
);

---- Chaves FK

ALTER TABLE dp.crime_pessoa
  ADD CONSTRAINT FK_crime_pessoa_pessoa
  FOREIGN KEY (id_pessoa) REFERENCES dp.pessoa (id_pessoa);
  
ALTER TABLE dp.crime_pessoa
  ADD CONSTRAINT FK_crime_pessoa_crime
  FOREIGN KEY (id_crime) REFERENCES dp.crime (id_crime);

ALTER TABLE dp.crime
  ADD CONSTRAINT FK_crime_tipo_crime
  FOREIGN KEY (id_tipo_crime) REFERENCES dp.tipo_crime (id_tipo_crime);

ALTER TABLE dp.crime_arma
  ADD CONSTRAINT FK_crime_arma_arma
  FOREIGN KEY (id_arma) REFERENCES dp.arma (id_arma);

ALTER TABLE dp.crime_arma
  ADD CONSTRAINT FK_crime_arma_crime
  FOREIGN KEY (id_crime) REFERENCES dp.crime (id_crime);

--0 - Arma de fogo, 1 - Arma branca, 2 - Outros.
ALTER TABLE dp.arma add constraint check_tipo_arma check (nb_tipo in ('0','1','2'));


