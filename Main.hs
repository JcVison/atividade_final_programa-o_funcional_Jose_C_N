module Main where

import Types
import Database
import ParserSQL
import Persistence

arquivoBanco :: FilePath
arquivoBanco = "banco.txt"

usuariosPadrao :: Tabela
usuariosPadrao =
    Tabela
        { nomeTabela = "Usuarios"
        , esquema =
            [ ("nome", TTexto)
            , ("idade", TInteiro)
            , ("ativo", TBooleano)
            ]
        , linhas =
            [ [Texto "Joao", Inteiro 20, Booleano True]
            , [Texto "Maria", Inteiro 25, Booleano True]
            , [Texto "Carlos", Inteiro 17, Booleano False]
            , [Texto "Ana", Inteiro 30, Booleano True]
            ]
        }

produtosPadrao :: Tabela
produtosPadrao =
    Tabela
        { nomeTabela = "Produtos"
        , esquema =
            [ ("nome", TTexto)
            , ("preco", TInteiro)
            , ("disponivel", TBooleano)
            ]
        , linhas =
            [ [Texto "Notebook", Inteiro 3500, Booleano True]
            , [Texto "Mouse", Inteiro 80, Booleano True]
            , [Texto "Monitor", Inteiro 900, Booleano False]
            ]
        }

bancoPadrao :: Banco
bancoPadrao =
    [usuariosPadrao, produtosPadrao]

mostrarAjuda :: IO ()
mostrarAjuda = do
    putStrLn "\n=============================="
    putStrLn "FuncDB - Mini SGBD em Haskell"
    putStrLn "=============================="
    putStrLn "HELP"
    putStrLn "SHOW TABLES"
    putStrLn "SHOW Usuarios"
    putStrLn "SHOW Produtos"
    putStrLn "CREATE TABLE Usuarios"
    putStrLn "CREATE TABLE Produtos"
    putStrLn "DROP TABLE Produtos"
    putStrLn "INSERT Usuario Pedro 22 True"
    putStrLn "INSERT Produto Teclado 150 True"
    putStrLn "SELECT * FROM Usuarios"
    putStrLn "SELECT * FROM Usuarios WHERE idade > 18"
    putStrLn "SELECT * FROM Usuarios WHERE ativo = True"
    putStrLn "SELECT * FROM Usuarios WHERE nome = Maria"
    putStrLn "SELECT * FROM Produtos WHERE preco > 100"
    putStrLn "SELECT * FROM Produtos WHERE disponivel = True"
    putStrLn "SUM Usuarios idade"
    putStrLn "AVG Usuarios idade"
    putStrLn "COUNT Usuarios"
    putStrLn "LIST Usuarios nome"
    putStrLn "ORDER Usuarios BY idade"
    putStrLn "ORDER Produtos BY preco"
    putStrLn "UPDATE Usuario Maria idade 30"
    putStrLn "DELETE FROM Usuarios WHERE nome = Carlos"
    putStrLn "SAVE"
    putStrLn "LOAD"
    putStrLn "EXIT"

mostrarLinhas :: [Linha] -> IO ()
mostrarLinhas [] = putStrLn "Nenhum registro encontrado."
mostrarLinhas resultado =
    mapM_ print resultado

executarEmTabela :: String -> Banco -> (Tabela -> IO Banco) -> IO Banco
executarEmTabela nome banco acao =
    case buscarTabela nome banco of
        Nothing -> do
            putStrLn "Erro: tabela não encontrada."
            return banco

        Just tabela ->
            acao tabela

executar :: Comando -> Banco -> IO Banco
executar Ajuda banco = do
    mostrarAjuda
    return banco

executar MostrarTabelas banco = do
    putStrLn "Tabelas cadastradas:"
    mapM_ (putStrLn . nomeTabela) banco
    return banco

executar (MostrarTabela nome) banco =
    executarEmTabela nome banco $ \tabela -> do
        print tabela
        return banco

executar CriarUsuarios banco =
    case adicionarTabela (criarTabela "Usuarios" [("nome", TTexto), ("idade", TInteiro), ("ativo", TBooleano)]) banco of
        Right novoBanco -> do
            putStrLn "Tabela Usuarios criada."
            return novoBanco

        Left erro -> do
            putStrLn erro
            return banco

executar CriarProdutos banco =
    case adicionarTabela (criarTabela "Produtos" [("nome", TTexto), ("preco", TInteiro), ("disponivel", TBooleano)]) banco of
        Right novoBanco -> do
            putStrLn "Tabela Produtos criada."
            return novoBanco

        Left erro -> do
            putStrLn erro
            return banco

executar (RemoverTabela nome) banco = do
    putStrLn "Tabela removida, caso existisse."
    return (removerTabela nome banco)

executar (InserirUsuario nome idade ativo) banco =
    executarEmTabela "Usuarios" banco $ \tabela -> do
        case inserirLinha [Texto nome, Inteiro idade, Booleano ativo] tabela of
            Right novaTabela -> do
                putStrLn "Usuário inserido."
                return (atualizarTabela novaTabela banco)

            Left erro -> do
                putStrLn erro
                return banco

executar (InserirProduto nome preco disponivel) banco =
    executarEmTabela "Produtos" banco $ \tabela -> do
        case inserirLinha [Texto nome, Inteiro preco, Booleano disponivel] tabela of
            Right novaTabela -> do
                putStrLn "Produto inserido."
                return (atualizarTabela novaTabela banco)

            Left erro -> do
                putStrLn erro
                return banco

executar (SelectTodos nome) banco =
    executarEmTabela nome banco $ \tabela -> do
        mostrarLinhas (selectTodos tabela)
        return banco

executar (SelectMaior tabelaNome coluna valor) banco =
    executarEmTabela tabelaNome banco $ \tabela -> do
        case selectWhereInteiroMaior coluna valor tabela of
            Right resultado -> mostrarLinhas resultado
            Left erro -> putStrLn erro
        return banco

executar (SelectBooleano tabelaNome coluna valor) banco =
    executarEmTabela tabelaNome banco $ \tabela -> do
        case selectWhereBooleano coluna valor tabela of
            Right resultado -> mostrarLinhas resultado
            Left erro -> putStrLn erro
        return banco

executar (SelectTexto tabelaNome coluna valor) banco =
    executarEmTabela tabelaNome banco $ \tabela -> do
        case selectWhereTexto coluna valor tabela of
            Right resultado -> mostrarLinhas resultado
            Left erro -> putStrLn erro
        return banco

executar (Somar tabelaNome coluna) banco =
    executarEmTabela tabelaNome banco $ \tabela -> do
        case somarColuna coluna tabela of
            Right soma -> print soma
            Left erro -> putStrLn erro
        return banco

executar (Media tabelaNome coluna) banco =
    executarEmTabela tabelaNome banco $ \tabela -> do
        case mediaColuna coluna tabela of
            Right media -> print media
            Left erro -> putStrLn erro
        return banco

executar (Contar tabelaNome) banco =
    executarEmTabela tabelaNome banco $ \tabela -> do
        print (contarLinhas tabela)
        return banco

executar (Listar tabelaNome coluna) banco =
    executarEmTabela tabelaNome banco $ \tabela -> do
        case listarColunaTexto coluna tabela of
            Right lista -> mapM_ putStrLn lista
            Left erro -> putStrLn erro
        return banco

executar (Ordenar tabelaNome coluna) banco =
    executarEmTabela tabelaNome banco $ \tabela -> do
        case ordenarPorColuna coluna tabela of
            Right ordenada -> do
                print ordenada
                return (atualizarTabela ordenada banco)

            Left erro -> do
                putStrLn erro
                return banco

executar (AtualizarIdade nome idade) banco =
    executarEmTabela "Usuarios" banco $ \tabela -> do
        case atualizarCelula "nome" nome "idade" (Inteiro idade) tabela of
            Right atualizada -> do
                putStrLn "Registro atualizado."
                return (atualizarTabela atualizada banco)

            Left erro -> do
                putStrLn erro
                return banco

executar (DeletarPorNome tabelaNome nome) banco =
    executarEmTabela tabelaNome banco $ \tabela -> do
        case deletarWhereTexto "nome" nome tabela of
            Right atualizada -> do
                putStrLn "Registro removido."
                return (atualizarTabela atualizada banco)

            Left erro -> do
                putStrLn erro
                return banco

executar Salvar banco = do
    salvarBanco arquivoBanco banco
    putStrLn "Banco salvo em banco.txt."
    return banco

executar Carregar _ = do
    resultado <- carregarBanco arquivoBanco

    case resultado of
        Right [] -> do
            putStrLn "Arquivo vazio. Usando banco padrão."
            return bancoPadrao

        Right banco -> do
            putStrLn "Banco carregado."
            return banco

        Left erro -> do
            putStrLn erro
            putStrLn "Usando banco padrão."
            return bancoPadrao

executar Sair banco = do
    salvarBanco arquivoBanco banco
    putStrLn "Estado final salvo em banco.txt."
    return banco

loop :: Banco -> IO ()
loop banco = do
    putStr "\nFuncDB> "
    entrada <- getLine

    case interpretar entrada of
        Left erro -> do
            putStrLn erro
            loop banco

        Right Sair -> do
            _ <- executar Sair banco
            return ()

        Right comando -> do
            novoBanco <- executar comando banco
            loop novoBanco

main :: IO ()
main = do
    putStrLn "Iniciando FuncDB..."

    resultado <- carregarBanco arquivoBanco

    bancoInicial <-
        case resultado of
            Right [] -> do
                putStrLn "Nenhum banco encontrado. Usando banco padrão."
                return bancoPadrao

            Right banco -> do
                putStrLn "Banco carregado de banco.txt."
                return banco

            Left erro -> do
                putStrLn erro
                putStrLn "Usando banco padrão."
                return bancoPadrao

    mostrarAjuda
    loop bancoInicial
