module Types where

data Tipo
    = TTexto
    | TInteiro
    | TBooleano
    deriving (Show, Read, Eq)

data Celula
    = Texto String
    | Inteiro Int
    | Booleano Bool
    deriving (Show, Read, Eq, Ord)

type Linha = [Celula]

data Tabela = Tabela
    { nomeTabela :: String
    , esquema :: [(String, Tipo)]
    , linhas :: [Linha]
    } deriving (Show, Read, Eq)

type Banco = [Tabela]
