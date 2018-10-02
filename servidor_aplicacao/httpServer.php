<?php

	include '../utils/httpUtils.php';

	$requestFile = $argv[1];
	$responseFile = "response.txt";

    if(file_exists($responseFile)){
        unlink($responseFile);
    }

	$request = file_get_contents($requestFile);

    $result = parseRequestFile($request);

    if($result == "/"){
        $result = "./index.html";
    }else{
        $result = ".".$result;
    }
    echo "GET ".$result."\n";

    $filePath = $result;

    if(file_exists($filePath)){
        $file = file_get_contents($filePath);
        $tam = strlen($file);
        $fileDesc = new stdClass();
        $fileDesc->contents = $file;
        $fileDesc->size = $tam;

        echo "File exists!\n";
        $responseMsg = httpResponseSuccess($fileDesc->size, $fileDesc->contents);

    }else{
        echo "File not found!\n";
        $responseMsg = httpResponseNotFound();
    }

    file_put_contents($responseFile, $responseMsg);

?>