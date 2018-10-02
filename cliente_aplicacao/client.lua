--
-- Necessário instalação da biblioteca de socket
-- Comando para execução: lua client.lua <arquivo_a_transferir.txt>
--

local socket = require("socket")

package.path = package.path .. ";../utils/socketUtils.lua"

require "socketUtils"

host = "localhost"
port = 9876

mode = arg[1]
filePath = arg[2]
fileDestination = arg[3]
blockSize = 100


print("Se conectando ao host '" ..host.. "' e porta " ..port.. "...")

clientSocket = assert(socket.connect(host, port))
print("Conectado! Preparando para ler comandos...")

if(mode == "R") then
    print("Will receive " .. filePath .. " from server")

    assert(clientSocket:send("R\n"))
    assert(clientSocket:send(filePath .. "\n"))

    print("Recebendo arquivo " .. filePath);
    fileExists = receive_until_new_line(clientSocket)

    if(fileExists == "Y") then
        receive_file(clientSocket, filePath, fileDestination);
    else
        print("Arquivo nao existe!")
    end

elseif(mode == "S") then
    print("Will send " .. filePath .. " to server")
    assert(clientSocket:send("S\n"))
    assert(clientSocket:send(fileDestination .. "\n"))
    if file_exists(filePath) then
        send_file(filePath, clientSocket, blockSize)
    end
end


clientSocket:close()
