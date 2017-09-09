{-# LANGUAGE CPP #-}

module Main where

import Async
import           Criterion.Main (defaultMain, bench, nfIO)
import           Data.Semigroup              (Semigroup(..))

main :: IO ()
main = defaultMain [ bench "asyncly-serial" $ nfIO asyncly_basic]

asyncly_basic :: IO Int
asyncly_basic = do
    xs <- toList $ (foldr (<>) mempty $ Prelude.map return [1..100000 :: Int])
    return (Prelude.length xs)
