module ParserSQL where

data Comando
    = Ajuda
    | MostrarTabelas
    | MostrarTabela String
    | CriarUsuarios
    | CriarProdutos
    | RemoverTabela String
    | InserirUsuario String Int Bool
    | InserirProduto String Int Bool
    | SelectTodos String
    | SelectMaior String String Int
    | SelectBooleano String String Bool
    | SelectTexto String String String
    | Somar String String
    | Media String String
    | Contar String
    | Listar String String
    | Ordenar String String
    | AtualizarIdade String Int
    | DeletarPorNome String String
    | Salvar
    | Carregar
    | Sair
    deriving Show

interpretar :: String -> Either String Comando
interpretar entrada =
    case words entrada of
        ["HELP"] ->
            Right Ajuda

        ["SHOW", "TABLES"] ->
            Right MostrarTabelas

        ["SHOW", tabela] ->
            Right (MostrarTabela tabela)

        ["CREATE", "TABLE", "Usuarios"] ->
            Right CriarUsuarios

        ["CREATE", "TABLE", "Produtos"] ->
            Right CriarProdutos

        ["DROP", "TABLE", tabela] ->
            Right (RemoverTabela tabela)

        ["INSERT", "Usuario", nome, idadeTxt, ativoTxt] ->
            case (reads idadeTxt, reads ativoTxt) of
                ([(idade, "")], [(ativo, "")]) ->
                    Right (InserirUsuario nome idade ativo)
                _ ->
                    Left "Erro: use INSERT Usuario nome idade True/False"

        ["INSERT", "Produto", nome, precoTxt, disponivelTxt] ->
            case (reads precoTxt, reads disponivelTxt) of
                ([(preco, "")], [(disponivel, "")]) ->
                    Right (InserirProduto nome preco disponivel)
                _ ->
                    Left "Erro: use INSERT Produto nome preco True/False"

        ["SELECT", "*", "FROM", tabela] ->
            Right (SelectTodos tabela)

        ["SELECT", "*", "FROM", tabela, "WHERE", coluna, ">", valorTxt] ->
            case reads valorTxt of
                [(valor, "")] -> Right (SelectMaior tabela coluna valor)
                _ -> Left "Erro: valor numérico inválido."

        ["SELECT", "*", "FROM", tabela, "WHERE", coluna, "=", "True"] ->
            Right (SelectBooleano tabela coluna True)

        ["SELECT", "*", "FROM", tabela, "WHERE", coluna, "=", "False"] ->
            Right (SelectBooleano tabela coluna False)

        ["SELECT", "*", "FROM", tabela, "WHERE", coluna, "=", valor] ->
            Right (SelectTexto tabela coluna valor)

        ["SUM", tabela, coluna] ->
            Right (Somar tabela coluna)

        ["AVG", tabela, coluna] ->
            Right (Media tabela coluna)

        ["COUNT", tabela] ->
            Right (Contar tabela)

        ["LIST", tabela, coluna] ->
            Right (Listar tabela coluna)

        ["ORDER", tabela, "BY", coluna] ->
            Right (Ordenar tabela coluna)

        ["UPDATE", "Usuario", nome, "idade", idadeTxt] ->
            case reads idadeTxt of
                [(idade, "")] -> Right (AtualizarIdade nome idade)
                _ -> Left "Erro: idade inválida."

        ["DELETE", "FROM", tabela, "WHERE", "nome", "=", nome] ->
            Right (DeletarPorNome tabela nome)

        ["SAVE"] ->
            Right Salvar

        ["LOAD"] ->
            Right Carregar

        ["EXIT"] ->
            Right Sair

        _ ->
            Left "Comando inválido. Digite HELP para ver os comandos."
