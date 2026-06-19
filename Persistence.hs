module Persistence where

import Types
import System.Directory (doesFileExist)

salvarBanco :: FilePath -> Banco -> IO ()
salvarBanco arquivo banco =
    writeFile arquivo (show banco)

carregarBanco :: FilePath -> IO (Either String Banco)
carregarBanco arquivo = do
    existe <- doesFileExist arquivo

    if not existe
        then return (Right [])
        else do
            conteudo <- readFile arquivo

            if null conteudo
                then return (Right [])
                else return $
                    case reads conteudo of
                        [(banco, "")] -> Right banco
                        _ -> Left "Erro: arquivo banco.txt corrompido."
