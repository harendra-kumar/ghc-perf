module Async where

newtype AsyncT m a = AsyncT { runAsyncT :: m a }

(AsyncT m1) `append` (AsyncT m2) = AsyncT $ do
    x <- m1
    y <- m2
    return (x + y)
