--
-- Necessário instalação da biblioteca de socket
-- Comando para execução: lua server.lua
--

local socket = require("socket")

package.path = package.path .. ";../utils/socketUtils.lua"

require "socketUtils"

host = "*"
port = 9876

local defaultBlockSize = 64

read_file("client.lua", defaultBlockSize)

print("Iniciando host '" ..host.. "' na porta " ..port.. "...")
serverSocket = assert(socket.bind(host, port))
ip, openedPort   = serverSocket:getsockname()
assert(ip, openedPort)

while true do
	print("Arguardando conexões em " .. ip .. ":" .. openedPort .. "...")
	clientSocket = assert(serverSocket:accept())
	print("Conectado! Aguardando informações...")

	cmd = receive_until_new_line(clientSocket)
	if(cmd == "S") then
	    filePath = receive_until_new_line(clientSocket)
		print("Arquivo a ser recebido " .. filePath)

		print("Will receive " .. filePath .. " from client")
		if(file_exists(filePath)) then
			os.remove(filePath)
		end
		receive_file(clientSocket, filePath, filePath)

		os.execute("php httpServer.php ".. filePath);

	elseif(cmd == "R") then
	    filePath = receive_until_new_line(clientSocket)
		print("Will send " .. filePath .. " to client")
	    if file_exists(filePath) then
	        assert(clientSocket:send("Y\n"))
			send_file(filePath, clientSocket, defaultBlockSize)
        else
	        print("Arquivo nao existe")
	        assert(clientSocket:send("N\n"))
	    end
	end


	clientSocket:close()
end