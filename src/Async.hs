{-# LANGUAGE RankNTypes                #-}

module Async where

import           Control.Monad               (liftM)

data AsyncT a = Stop | Yield a (AsyncT a)

instance Monoid (AsyncT a) where
    mempty = Stop
    mappend x y =
        case x of
            Stop -> y
            Yield a r -> Yield a (mappend r y)

-- {-# INLINE toList #-}
toList :: Monad m => AsyncT a -> m [a]
toList m =
    case m of
        Stop -> return []
        Yield a r -> liftM (a :) (toList r)
