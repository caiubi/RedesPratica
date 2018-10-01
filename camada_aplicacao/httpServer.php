<?php
function parseRequestFile($request){
    $pos = strpos($request, "GET ");
    if($pos === false){
        return "";
    }else{
        $endPos = strpos($request, "\r\n", $pos);
        $getLine = substr ( $request, $pos, $endPos);        
        return explode(" ", $getLine)[1];
    }
}

function startServer($address, $port){
    if (($sock = socket_create(AF_INET, SOCK_STREAM, SOL_TCP)) === false) {
        echo "socket_create() failed: reason: " . socket_strerror(socket_last_error()) . "\n";
        return null;
    }

    if (socket_bind($sock, $address, $port) === false) {
        echo "socket_bind() failed: reason: " . socket_strerror(socket_last_error($sock)) . "\n";
        return null;
    }

    if (socket_listen($sock, 5) === false) {
        echo "socket_listen() failed: reason: " . socket_strerror(socket_last_error($sock)) . "\n";
        return null;
    }
    return $sock;    
}

function acceptConnections($serverSock){
    if (($msgsock = socket_accept($serverSock)) === false) {
        echo "socket_accept() failed: reason: " . socket_strerror(socket_last_error($serverSock)) . "\n";
        return null;
    }else{
        return $msgsock;
    }
}

function readHTTPRequest($clientSock){
    while ($out = socket_read($clientSock, 1000)) {
        if(substr ( $out, strlen($out)-4, 4) == "\r\n\r\n"){
            break;
        }
    }

    return $out;
}


function transferRemoteFile($filePath){
/*
        TODO: Fazer transferencia do arquivo via lua
*/
    //Mock
    if(file_exists($filePath)){
        $file = file_get_contents($filePath);
        $tam = strlen($file);

        $fileDesc = new stdClass();
        $fileDesc->contents = $file;
        $fileDesc->size = $tam;

        return $fileDesc;
    }

    return null;  //Se arquivo não existe
}


function httpResponseSuccess($clientSock, $fileSize, $fileContent){
        $msg = "HTTP/1.1 200 OK\r\n";
        $msg .= "Date: Mon, 01 Oct 2018 00:19:50 GMT\r\n";
        $msg .= "Server: Apache/2.4.34 (Unix)\r\n";
        $msg .= "Content-Location: index.html.en\r\n";
        $msg .= "Vary: negotiate\r\n";
        $msg .= "TCN: choice\r\n";
        $msg .= "Last-Modified: Mon, 11 Jun 2007 18:53:14 GMT\r\n";
        $msg .= "Accept-Ranges: bytes\r\n";
        $msg .= "Content-Length: $fileSize\r\n";
        $msg .= "Keep-Alive: timeout=5, max=99\r\n";
        $msg .= "Connection: Keep-Alive\r\n";
        $msg .= "Content-Type: text/html\r\n\r\n".$fileContent;

        socket_write($clientSock, $msg, strlen($msg));

}

function httpResponseNotFound($clientSock){
        $msg = "HTTP/1.1 404 Not Found\r\n";
        $msg .= "Date: Mon, 01 Oct 2018 00:40:14 GMT\r\n";
        $msg .= "Server: Apache/2.4.34 (Unix)\r\n";
        $msg .= "Content-Length: 9\r\n";
        $msg .= "Keep-Alive: timeout=5, max=98\r\n";
        $msg .= "Connection: Keep-Alive\r\n";
        $msg .= "Content-Type: text/html; charset=iso-8859-1\r\n\r\n";

        socket_write($clientSock, $msg, strlen($msg));
        $msg = "NOT FOUND";
        socket_write($clientSock, $msg, strlen($msg));

}

?>