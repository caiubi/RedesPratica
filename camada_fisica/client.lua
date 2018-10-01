--
-- Necessário instalação da biblioteca de socket
-- Comando para execução: lua client.lua <arquivo_a_transferir.txt>
--


local socket = require("socket")
host = "localhost"
port = 9876

filePath = arg[1]
fileDestination = arg[2]
blockSize = 100

local function receive_until_new_line(clientSocket)
    local data = "";
    local flag = false
    while not flag do
        packet, e = clientSocket:receive(1)
        if not (packet == "\n") then
            data = data .. packet
        else
          flag = true
        end
    end
    return data
end 


print("Se conectando ao host '" ..host.. "' e porta " ..port.. "...")

clientSocket = assert(socket.connect(host, port))

print("Conectado! Preparando para receber arquivo...")

assert(clientSocket:send(filePath .. "\n"))

print("Recebendo arquivo " .. filePath);


fileExists = receive_until_new_line(clientSocket)

if(fileExists == "Y") then
    file = io.open(fileDestination, "wb")
    while not e do
        packet, e = clientSocket:receive(1)
        if not e then
            file:write(packet)
        end
    end
    print("Arquivo recebido com sucesso!")
    file:close()
else
    print("Arquivo nao existe!")
end

clientSocket:close()
