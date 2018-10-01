--
-- Necessário instalação da biblioteca de socket
-- Comando para execução: lua server.lua
--


local socket = require("socket")
host = "*"
port = 9876

local defaultBlockSize = 64

local open = io.open

function fsize (file)
        local current = file:seek()      
        local size = file:seek("end")    
        file:seek("set", current)
        return size
end

local function read_file(path, blockSize)
    local file = open(path, "rb") 
    if not file then return nil end
    local fileSize = fsize(file)
    lines = {}
	for i=0,fileSize,blockSize do 
	    block = file:read(blockSize)
		lines[#lines + 1] = block
	end
    file:close()
	return lines
end

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

print("Iniciando host '" ..host.. "' na porta " ..port.. "...")
serverSocket = assert(socket.bind(host, port))
ip, openedPort   = serverSocket:getsockname()
assert(ip, openedPort)

print("Arguardando conexões em " .. ip .. ":" .. openedPort .. "...")
clientSocket = assert(serverSocket:accept())
print("Conectado! Aguardando informações...")

filePath = receive_until_new_line(clientSocket)
print("Arquivo requisitado " .. filePath)

local fileContent = read_file(filePath, defaultBlockSize)
print("Enviando arquivo... ")

for k,packet in pairs(fileContent) do
	assert(clientSocket:send(packet))
end


clientSocket:close()
print("Arquivo recebido com sucesso!")
