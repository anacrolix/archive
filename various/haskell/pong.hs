import Network.Socket
import Network.Socket.ByteString
import Data.ByteString.Char8
import Control.Monad
import Control.Concurrent

pong sock = do
    sendAll sock $ pack "HTTP/1.0 200 OK\r\nContent-Length: 5\r\n\r\nPong!\r\n"
    sClose sock

main = do
    sock <- socket AF_INET Stream 0
    setSocketOption sock ReuseAddr 1
    bindSocket sock (SockAddrInet 3000 iNADDR_ANY)
    listen sock sOMAXCONN
    forever $ do
        (sock1, addr) <- accept sock
        Prelude.putStrLn $ "Accepted connection from " ++ show addr
        forkIO $ pong sock1
