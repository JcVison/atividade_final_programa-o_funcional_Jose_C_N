# FuncDB — Mini SGBD em Haskell

Projeto final da disciplina **COMP914 — Programação Funcional**, desenvolvido em Haskell.

## Objetivo

O **FuncDB** é um mini sistema gerenciador de banco de dados relacional em memória.  
Ele permite criar tabelas, inserir registros, consultar dados, ordenar informações, realizar agregações e salvar/carregar o estado do banco em arquivo `.txt`.

## Tecnologias

- Haskell
- GHC / GHCi
- GitHub Codespaces

## Estrutura do Projeto

```text
FuncDB/
├── Main.hs
├── Types.hs
├── Database.hs
├── Sort.hs
├── ParserSQL.hs
├── Persistence.hs
├── banco.txt
├── README.md
└── Relatorio.txt
