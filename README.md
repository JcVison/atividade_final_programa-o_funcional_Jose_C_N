FUNCDB - MINI SISTEMA GERENCIADOR DE BANCO DE DADOS EM HASKELL

Universidade Federal de Roraima (UFRR)
Departamento de Ciência da Computação (DCC)

Disciplina: COMP914 - Programação Funcional
Professor: Jean Bertrand

Projeto Final – Engenharia de Software Declarativa


1. APRESENTAÇÃO DO PROJETO
   =========================================================

O FuncDB é um Mini Sistema Gerenciador de Banco de Dados (Mini-SGBD) desenvolvido utilizando a linguagem Haskell. O objetivo do projeto é simular as principais operações de um banco de dados relacional por meio de uma interface baseada em comandos inspirados na linguagem SQL.

O sistema permite criar tabelas, inserir registros, realizar consultas, atualizar dados, excluir registros, ordenar informações, gerar estatísticas e persistir os dados em disco para utilização futura.

Além das funcionalidades de gerenciamento de dados, o projeto foi desenvolvido para demonstrar a aplicação prática dos principais conceitos do paradigma funcional exigidos pela disciplina, incluindo tipagem forte, imutabilidade, funções de alta ordem, tratamento seguro de erros, persistência de dados e algoritmos de divisão e conquista.

=========================================================
2. OBJETIVOS
============

Objetivo Geral

Desenvolver um Mini Sistema Gerenciador de Banco de Dados utilizando Haskell, aplicando os conceitos fundamentais da programação funcional e atendendo aos requisitos estabelecidos para o projeto final da disciplina.

Objetivos Específicos

* Criar estruturas de dados personalizadas utilizando tipos algébricos.
* Utilizar sintaxe de registros com campos nomeados.
* Implementar persistência em disco utilizando operações de entrada e saída (IO).
* Aplicar tratamento seguro de erros através dos tipos Maybe e Either.
* Utilizar funções de alta ordem como map, filter e foldl'.
* Implementar algoritmos de divisão e conquista para ordenação dos dados.
* Simular operações básicas de um banco de dados relacional.
* Organizar o projeto em módulos independentes e reutilizáveis.

=========================================================
3. ESTRUTURA DO PROJETO
=======================

O sistema foi dividido em módulos para facilitar manutenção, reutilização e organização do código.

Estrutura:

FuncDB/

├── Main.hs
├── Types.hs
├── Database.hs
├── Sort.hs
├── ParserSQL.hs
├── Persistence.hs
├── banco.txt
├── README.txt
└── Relatorio.txt

Descrição dos Arquivos:

Main.hs
Responsável pelo fluxo principal do programa, interação com o usuário e execução dos comandos.

Types.hs
Define todos os tipos de dados utilizados pelo sistema.

Database.hs
Contém as operações relacionadas ao gerenciamento das tabelas e registros.

Sort.hs
Implementa o algoritmo Merge Sort utilizado na ordenação dos dados.

ParserSQL.hs
Realiza a interpretação dos comandos digitados pelo usuário.

Persistence.hs
Responsável pelo salvamento e carregamento dos dados em disco.

banco.txt
Arquivo utilizado para armazenar permanentemente os dados do sistema.

=========================================================
4. REQUISITOS OBRIGATÓRIOS ATENDIDOS
====================================

4.1 Tipos Customizados Avançados

O projeto utiliza tipos customizados através da palavra-chave data.

Exemplos:

* Tipo
* Celula
* Tabela
* Banco

Também foi utilizada sintaxe de registros nomeados:

data Tabela = Tabela
{ nomeTabela :: String
, esquema :: [(String, Tipo)]
, linhas :: [Linha]
}

Além disso, são utilizadas derivações automáticas de instâncias através da cláusula deriving.

---

4.2 Persistência em Disco (IO)

O sistema realiza leitura e gravação de arquivos utilizando a mônada IO.

Ao iniciar:

* O arquivo banco.txt é carregado.

Ao encerrar:

* O estado final do banco é salvo automaticamente.

Funções utilizadas:

* salvarBanco
* carregarBanco

---

4.3 Tratamento Seguro de Erros

O projeto evita o uso de funções parciais que possam causar falhas inesperadas.

Operações arriscadas retornam:

Maybe

Exemplos:

* buscarTabela
* pegarCelula

Either

Exemplos:

* inserirLinha
* adicionarTabela
* ordenarPorColuna
* selectWhereTexto

Dessa forma o sistema continua funcionando mesmo diante de entradas inválidas.

---

4.4 Funções de Alta Ordem

Map

Utilizado para transformar coleções de dados.

Exemplos:

* atualizarTabela
* listarColunaTexto
* atualizarCelula

Filter

Utilizado para consultas e remoções.

Exemplos:

* selectWhereTexto
* selectWhereInteiroMaior
* selectWhereBooleano
* deletarWhereTexto

Foldl'

Utilizado para agregações.

Exemplo:

* somarColuna

---

4.5 Divisão e Conquista

O projeto implementa manualmente o algoritmo Merge Sort.

Funcionamento:

1. Divide a lista em duas metades.
2. Ordena cada metade recursivamente.
3. Combina os resultados ordenados.

Complexidade:

Melhor caso: O(n log n)
Caso médio: O(n log n)
Pior caso: O(n log n)

O algoritmo é utilizado para implementar o comando ORDER.

=========================================================
5. FUNCIONALIDADES DISPONÍVEIS
==============================

Gerenciamento de Tabelas

* CREATE TABLE
* DROP TABLE
* SHOW TABLES

Manipulação de Registros

* INSERT
* UPDATE
* DELETE

Consultas

* SELECT
* WHERE
* ORDER BY

Agregações

* SUM
* AVG
* COUNT

Persistência

* SAVE
* LOAD

=========================================================
6. COMANDOS SUPORTADOS
======================

HELP

SHOW TABLES

SHOW Usuarios

SHOW Produtos

CREATE TABLE Usuarios

CREATE TABLE Produtos

DROP TABLE Produtos

INSERT Usuario Pedro 22 True

INSERT Produto Teclado 150 True

SELECT * FROM Usuarios

SELECT * FROM Usuarios WHERE idade > 18

SELECT * FROM Usuarios WHERE ativo = True

SELECT * FROM Usuarios WHERE nome = Maria

SUM Usuarios idade

AVG Usuarios idade

COUNT Usuarios

LIST Usuarios nome

ORDER Usuarios BY idade

UPDATE Usuario Maria idade 30

DELETE FROM Usuarios WHERE nome = Carlos

SAVE

LOAD

EXIT

=========================================================
7. EXEMPLO DE EXECUÇÃO
======================

SHOW TABLES

INSERT Usuario Pedro 22 True

INSERT Usuario Laura 19 True

SELECT * FROM Usuarios

SELECT * FROM Usuarios WHERE idade > 18

SUM Usuarios idade

AVG Usuarios idade

COUNT Usuarios

ORDER Usuarios BY idade

UPDATE Usuario Maria idade 30

DELETE FROM Usuarios WHERE nome = Carlos

SAVE

EXIT

=========================================================
8. COMO EXECUTAR
================

1. Abrir o terminal na pasta do projeto.

2. Executar:

ghci Main.hs

3. Iniciar o sistema:

main

=========================================================
9. CONCLUSÃO
============

O FuncDB é um Mini Sistema Gerenciador de Banco de Dados desenvolvido em Haskell que demonstra a aplicação prática dos principais conceitos da Programação Funcional.

O projeto atende aos requisitos exigidos pela disciplina através do uso de tipos customizados, persistência em disco, tratamento seguro de erros, funções de alta ordem e algoritmos de divisão e conquista.

Além disso, oferece funcionalidades semelhantes às encontradas em sistemas de banco de dados reais, permitindo a manipulação eficiente de informações através de comandos inspirados em SQL.
