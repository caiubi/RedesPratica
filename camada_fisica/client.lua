--
-- Necessário instalação da biblioteca de socket
-- Comando para execução: lua client.lua <arquivo_a_transferir.txt>
--


local socket = require("socket")
host = "localhost"
port = 9876

filePath = arg[1]
blockSize = 100


print("Se conectando ao host '" ..host.. "' e porta " ..port.. "...")

clientSocket = assert(socket.connect(host, port))

print("Conectado! Preparando para receber arquivo...")

assert(clientSocket:send(filePath .. "\n"))

print("Recebendo arquivo " .. filePath);

file = io.open("recebido.txt", "wb")

while not e do
    packet, e = clientSocket:receive(1)
    if not e then
        file:write(packet)
    end
end



print("Arquivo recebido com sucesso!")
file:close()
clientSocket:close()
