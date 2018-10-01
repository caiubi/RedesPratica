--
-- Necessário instalação da biblioteca de socket
-- Comando para execução: lua server.lua
--


local socket = require("socket")
host = "*"
port = 9876

local blockSize = 100

print("Iniciando host '" ..host.. "' na porta " ..port.. "...")
serverSocket = assert(socket.bind(host, port))
ip, openedPort   = serverSocket:getsockname()
assert(ip, openedPort)

print("Arguardando conexões em " .. ip .. ":" .. openedPort .. "...")
clientSocket = assert(serverSocket:accept())
print("Conectado! Recebendo informações...")

file = io.open("recebido.txt", "w")

packet, e = clientSocket:receive(blockSize)
while not e do
	file:write(packet)
	packet, e = clientSocket:receive(blockSize)
end

file:close()
clientSocket:close()
print("Arquivo recebido com sucesso!")
