<?php
error_reporting(E_ALL);

/* Allow the script to hang around waiting for connections. */
set_time_limit(0);

include 'httpServer.php';

$address = '127.0.0.1';
$port = 8080;


$serverSock = startServer($address, $port);


do {

    if($serverSock != null){

        $clientSock = acceptConnections($serverSock);

        if($clientSock != null){
            $request = readHTTPRequest($clientSock);

            $result = parseRequestFile($request);

            if($result == "/"){
                $result = "./index.html";
            }else{
                $result = ".".$result;
            }
            echo "GET ".$result."\n";
            $fileDesc = transferRemoteFile($result);

            if($fileDesc == null){
                httpResponseNotFound($clientSock);
            }else{
                httpResponseSuccess($clientSock, $fileDesc->size, $fileDesc->contents);
            }

            socket_close($clientSock);

        }
    }else{
        break;
    }

} while (true);


if($serverSock != null){
    socket_close($serverSock);    
}

?>