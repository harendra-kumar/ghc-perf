module List where

import Control.Monad  (liftM)

data List a = Stop | Yield a (List a)

instance Monoid (List a) where
    mempty = Stop
    mappend x y =
        case x of
            Stop -> y
            Yield a r -> Yield a (mappend r y)

-- {-# INLINE toList #-}
toList :: Monad m => List a -> m [a]
toList m =
    case m of
        Stop -> return []
        Yield a r -> liftM (a :) (toList r)
