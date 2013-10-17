module Main where

import Observables

(|>) :: a -> (a -> b) -> b
x |> f = f x

sample :: IO Disposable
sample = (unit (45::Int)) |> subscribe (\x -> print (x::Int))

sample2 :: IO Disposable
sample2 = (range 0 10) |> subscribe (\x -> print (x::Int))

main = do sample ; sample2
          