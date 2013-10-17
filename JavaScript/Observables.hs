module Observables where
  
  import Data.Maybe
  import GHC.IO
  import GHCJS.Types
  import GHCJS.Foreign
  import GHCJS.Marshal
  
  data Observable_
  data Disposable_
  
  type Observable a = JSRef Observable_
  type Disposable = JSRef ()
  
  foreign import javascript safe "Rx.Observable.returnValue($1)"
        rx_returnValue :: JSRef a -> Observable a
                          
  foreign import javascript safe "$1.subscribe($2)"
        rx_subscribe :: Observable a -> JSFun (a -> IO()) -> IO Disposable
                                
  foreign import javascript safe "Rx.Observable.range($1,$2)"
        rx_range :: Int -> Int -> Observable Int
                                      
  unit :: ToJSRef a => a -> Observable a
  unit = rx_returnValue . unsafePerformIO . toJSRef

  subscribe :: FromJSRef a => (a -> IO()) -> Observable a -> IO Disposable
  subscribe f xs = syncCallback1 True True f' >>= rx_subscribe xs
                   where f' x = fromJSRef x >>= f . fromJust
                       
  range :: Int -> Int -> Observable a
  range start count = rx_range start count