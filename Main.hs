module Main where

import List
import Criterion.Main (defaultMain, bench, nfIO)
import Data.Monoid

main :: IO ()
main = defaultMain [ bench "len" $ nfIO len]

len :: IO Int
len = do
    xs <- toList $ (foldr (<>) mempty $ map (\x -> Yield x Stop) [1..100000 :: Int])
    return (length xs)
