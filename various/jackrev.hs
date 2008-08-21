import Data.ByteString.Lazy as B
import Control.Monad
main = (liftM B.reverse) B.getContents >>= B.putStr
