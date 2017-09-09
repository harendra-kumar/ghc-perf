{-# LANGUAGE RankNTypes                #-}

module Async where

import           Data.Semigroup              (Semigroup(..))
import           Control.Monad               (ap, liftM)

newtype AsyncT m a =
    AsyncT {
        runAsyncT :: forall r.
               Maybe Int                          -- state
            -> m r                                          -- stop
            -> (a -> Maybe Int -> Maybe (AsyncT m a) -> m r)  -- yield
            -> m r
    }

------------------------------------------------------------------------------
-- Monad
------------------------------------------------------------------------------

-- | Appends the results of two AsyncT computations in order.
instance Semigroup (AsyncT m a) where
    (AsyncT m1) <> m2 = AsyncT $ \ctx stp yld ->
        let stop = (runAsyncT m2) ctx stp yld
            yield a c Nothing  = yld a c (Just m2)
            yield a c (Just r) = yld a c (Just (mappend r m2))
        in m1 ctx stop yield

-- | Appends the results of two AsyncT computations in order.
instance Monoid (AsyncT m a) where
    mempty = AsyncT $ \_ stp _ -> stp
    mappend = (<>)

instance Monad m => Monad (AsyncT m) where
    return a = AsyncT $ \ctx _ yld -> yld a ctx Nothing

    AsyncT m >>= f = AsyncT $ \_ stp yld ->
        let run x = (runAsyncT x) Nothing stp yld
            yield a _ Nothing  = run $ f a
            yield a _ (Just r) = run $ f a <> (r >>= f)
        in m Nothing stp yield

instance Monad m => Functor (AsyncT m) where
    fmap = liftM

instance Monad m => Applicative (AsyncT m) where
    pure  = return
    (<*>) = ap

toList :: Monad m => AsyncT m a -> m [a]
toList m = run Nothing m

    where

    stop = return []

    yield a _ Nothing  = return [a]
    yield a c (Just x) = liftM (a :) (run c x)

    run ctx mx = (runAsyncT mx) ctx stop yield
