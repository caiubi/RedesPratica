function receive_until_new_line(clientSocket)
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

function fsize (file)
        local current = file:seek()      
        local size = file:seek("end")    
        file:seek("set", current)
        return size
end

function read_file(path, blockSize)
    local file = io.open(path, "rb") 
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

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function receive_file(clientSocket, filePath, fileDestination)
    file = io.open(fileDestination, "wb")
    while not e do
        packet, e = clientSocket:receive(1)
        if not e then
            file:write(packet)
        end
    end
    print("Arquivo recebido com sucesso!\n")
    file:close()
end    


function send_file(filePath, clientSocket, defaultBlockSize)
    local fileContent = read_file(filePath, defaultBlockSize)
    print("Enviando arquivo... \n")

    for k,packet in pairs(fileContent) do
        assert(clientSocket:send(packet))
    end
    print("Arquivo enviado com sucesso!\n")
end