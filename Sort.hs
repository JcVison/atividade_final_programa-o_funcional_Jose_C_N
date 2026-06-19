module Sort where

mergeSortBy :: (a -> a -> Bool) -> [a] -> [a]
mergeSortBy _ [] = []
mergeSortBy _ [x] = [x]
mergeSortBy comp xs =
    merge comp (mergeSortBy comp esquerda) (mergeSortBy comp direita)
  where
    meio = length xs `div` 2
    esquerda = take meio xs
    direita = drop meio xs

merge :: (a -> a -> Bool) -> [a] -> [a] -> [a]
merge _ xs [] = xs
merge _ [] ys = ys
merge comp (x:xs) (y:ys)
    | comp x y  = x : merge comp xs (y:ys)
    | otherwise = y : merge comp (x:xs) ys
