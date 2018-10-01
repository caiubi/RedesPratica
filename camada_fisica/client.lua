--
-- Necessário instalação da biblioteca de socket
-- Comando para execução: lua client.lua <arquivo_a_transferir.txt>
--


local socket = require("socket")
host = "localhost"
port = 9876

filePath = arg[1]
defaultBlockSize = 100

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

local fileContent = read_file(filePath, defaultBlockSize)

print("Se conectando ao host '" ..host.. "' e porta " ..port.. "...")

clientSocket = assert(socket.connect(host, port))

print("Conectado! Preparando para enviar arquivo...")

for k,packet in pairs(fileContent) do
	assert(clientSocket:send(packet))
end

print("Arquivo enviado com sucesso!")
clientSocket:close()
