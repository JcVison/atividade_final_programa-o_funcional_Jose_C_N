module Database where

import Types
import Sort
import Data.List (foldl')

indiceColuna :: String -> Tabela -> Maybe Int
indiceColuna nome tabela =
    procurar 0 (esquema tabela)
  where
    procurar _ [] = Nothing
    procurar i ((coluna, _):resto)
        | coluna == nome = Just i
        | otherwise = procurar (i + 1) resto

pegarCelula :: Int -> Linha -> Maybe Celula
pegarCelula _ [] = Nothing
pegarCelula n _
    | n < 0 = Nothing
pegarCelula 0 (x:_) = Just x
pegarCelula n (_:xs) = pegarCelula (n - 1) xs

criarTabela :: String -> [(String, Tipo)] -> Tabela
criarTabela nome campos =
    Tabela
        { nomeTabela = nome
        , esquema = campos
        , linhas = []
        }

buscarTabela :: String -> Banco -> Maybe Tabela
buscarTabela _ [] = Nothing
buscarTabela nome (t:ts)
    | nomeTabela t == nome = Just t
    | otherwise = buscarTabela nome ts

adicionarTabela :: Tabela -> Banco -> Either String Banco
adicionarTabela tabela banco =
    case buscarTabela (nomeTabela tabela) banco of
        Just _ -> Left "Erro: tabela já existe."
        Nothing -> Right (banco ++ [tabela])

atualizarTabela :: Tabela -> Banco -> Banco
atualizarTabela novaTabela banco =
    map substituir banco
  where
    substituir tabela
        | nomeTabela tabela == nomeTabela novaTabela = novaTabela
        | otherwise = tabela

removerTabela :: String -> Banco -> Banco
removerTabela nome banco =
    filter (\tabela -> nomeTabela tabela /= nome) banco

tipoCelula :: Celula -> Tipo
tipoCelula (Texto _) = TTexto
tipoCelula (Inteiro _) = TInteiro
tipoCelula (Booleano _) = TBooleano

validarLinha :: Linha -> Tabela -> Bool
validarLinha linha tabela =
    length linha == length (esquema tabela)
    && and (zipWith validar linha (esquema tabela))
  where
    validar celula (_, tipoEsperado) =
        tipoCelula celula == tipoEsperado

inserirLinha :: Linha -> Tabela -> Either String Tabela
inserirLinha linha tabela
    | validarLinha linha tabela =
        Right tabela { linhas = linhas tabela ++ [linha] }
    | otherwise =
        Left "Erro: linha inválida. Verifique quantidade e tipos das colunas."

selectTodos :: Tabela -> [Linha]
selectTodos tabela =
    linhas tabela

selectWhereTexto :: String -> String -> Tabela -> Either String [Linha]
selectWhereTexto coluna valor tabela =
    case indiceColuna coluna tabela of
        Nothing -> Left "Erro: coluna não encontrada."
        Just indice ->
            Right (filter (comparar indice) (linhas tabela))
  where
    comparar indice linha =
        case pegarCelula indice linha of
            Just (Texto texto) -> texto == valor
            _ -> False

selectWhereInteiroMaior :: String -> Int -> Tabela -> Either String [Linha]
selectWhereInteiroMaior coluna valor tabela =
    case indiceColuna coluna tabela of
        Nothing -> Left "Erro: coluna não encontrada."
        Just indice ->
            Right (filter (comparar indice) (linhas tabela))
  where
    comparar indice linha =
        case pegarCelula indice linha of
            Just (Inteiro numero) -> numero > valor
            _ -> False

selectWhereBooleano :: String -> Bool -> Tabela -> Either String [Linha]
selectWhereBooleano coluna valor tabela =
    case indiceColuna coluna tabela of
        Nothing -> Left "Erro: coluna não encontrada."
        Just indice ->
            Right (filter (comparar indice) (linhas tabela))
  where
    comparar indice linha =
        case pegarCelula indice linha of
            Just (Booleano b) -> b == valor
            _ -> False

somarColuna :: String -> Tabela -> Either String Int
somarColuna coluna tabela =
    case indiceColuna coluna tabela of
        Nothing -> Left "Erro: coluna não encontrada."
        Just indice ->
            Right (foldl' (somar indice) 0 (linhas tabela))
  where
    somar indice acc linha =
        case pegarCelula indice linha of
            Just (Inteiro n) -> acc + n
            _ -> acc

mediaColuna :: String -> Tabela -> Either String Double
mediaColuna coluna tabela =
    case somarColuna coluna tabela of
        Left erro -> Left erro
        Right soma ->
            if null (linhas tabela)
                then Left "Erro: tabela vazia."
                else Right (fromIntegral soma / fromIntegral (length (linhas tabela)))

contarLinhas :: Tabela -> Int
contarLinhas tabela =
    length (linhas tabela)

listarColunaTexto :: String -> Tabela -> Either String [String]
listarColunaTexto coluna tabela =
    case indiceColuna coluna tabela of
        Nothing -> Left "Erro: coluna não encontrada."
        Just indice ->
            Right (map (extrair indice) (linhas tabela))
  where
    extrair indice linha =
        case pegarCelula indice linha of
            Just (Texto texto) -> texto
            _ -> ""

ordenarPorColuna :: String -> Tabela -> Either String Tabela
ordenarPorColuna coluna tabela =
    case indiceColuna coluna tabela of
        Nothing -> Left "Erro: coluna não encontrada."
        Just indice ->
            Right tabela { linhas = mergeSortBy (comparar indice) (linhas tabela) }
  where
    comparar indice l1 l2 =
        case (pegarCelula indice l1, pegarCelula indice l2) of
            (Just a, Just b) -> a <= b
            _ -> True

trocarCelula :: Int -> Celula -> Linha -> Linha
trocarCelula _ _ [] = []
trocarCelula n novo linha
    | n < 0 = linha
trocarCelula 0 novo (_:xs) = novo : xs
trocarCelula n novo (x:xs) =
    x : trocarCelula (n - 1) novo xs

atualizarCelula :: String -> String -> String -> Celula -> Tabela -> Either String Tabela
atualizarCelula colunaBusca valorBusca colunaAlvo novoValor tabela =
    case (indiceColuna colunaBusca tabela, indiceColuna colunaAlvo tabela) of
        (Just iBusca, Just iAlvo) ->
            Right tabela { linhas = map (atualizarLinha iBusca iAlvo) (linhas tabela) }

        _ ->
            Left "Erro: coluna não encontrada."
  where
    atualizarLinha iBusca iAlvo linha =
        case pegarCelula iBusca linha of
            Just (Texto texto)
                | texto == valorBusca -> trocarCelula iAlvo novoValor linha
            _ -> linha

deletarWhereTexto :: String -> String -> Tabela -> Either String Tabela
deletarWhereTexto coluna valor tabela =
    case indiceColuna coluna tabela of
        Nothing -> Left "Erro: coluna não encontrada."
        Just indice ->
            Right tabela { linhas = filter (manter indice) (linhas tabela) }
  where
    manter indice linha =
        case pegarCelula indice linha of
            Just (Texto texto) -> texto /= valor
            _ -> True
