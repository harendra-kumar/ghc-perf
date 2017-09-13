{-# LANGUAGE CPP #-}

module Main where

import Criterion.Main (defaultMain, bench, nfIO)

-- Uncomment this to have all the code in one module
-- #define SINGLE_MODULE
#ifndef SINGLE_MODULE
import List
#else
import Control.Monad  (liftM)

data List a = Stop | Yield a (List a)

instance Monoid (List a) where
    -- {-# INLINE mempty #-}
    mempty = Stop
    -- {-# INLINE mappend #-}
    mappend x y =
        case x of
            Stop -> y
            Yield a r -> Yield a (mappend r y)

-- {-# NOINLINE toList #-}
toList :: Monad m => List a -> m [a]
toList m =
    case m of
        Stop -> return []
        Yield a r -> liftM (a :) (toList r)

#endif

len :: IO Int
len = do
    xs <- toList $ (foldr mappend mempty $ map (\x -> Yield x Stop) [1..100000 :: Int])
    return (length xs)

main :: IO ()
main = defaultMain [ bench "len" $ nfIO len]
