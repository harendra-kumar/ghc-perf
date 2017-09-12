{-# LANGUAGE CPP #-}

module Main where

import Async
import           Criterion.Main (defaultMain, bench, nfIO)
import Data.Monoid

main :: IO ()
main = defaultMain [ bench "asyncly-serial" $ nfIO asyncly_basic]

asyncly_basic :: IO Int
asyncly_basic = do
    xs <- toList $ (foldr (<>) mempty $ map (\x -> Yield x Stop) [1..100000 :: Int])
    return (length xs)

{-
    where
    {-# NOINLINE xfoldr #-}
    xfoldr = foldr
    xmap = map
    -}
