local socket = require("socket")
local Network = {}

Network.serverAddress = "127.0.0.1"  -- Change to your server's IP
Network.serverPort = 8080
Network.tcpClient = nil

-- Connect to the server
function Network.connectToServer()
    Network.tcpClient = socket.tcp()
    Network.tcpClient:settimeout(0) -- Non-blocking mode
    local success, err = Network.tcpClient:connect(Network.serverAddress, Network.serverPort)
    if not success then
        print("Failed to connect to server:", err)
    else
        print("Connected to server.")
    end
end

-- Send player position to server
function Network.sendPosition(positionData)
    if Network.tcpClient then
        Network.tcpClient:send(positionData)
    end
end

-- Receive other players' positions from server
function Network.receivePositions(otherPlayers)
    if Network.tcpClient then
        local data, err = Network.tcpClient:receive("*l")
        if data then
            -- Parse incoming data assuming format "id:x,y"
            local id, x, y = data:match("(%d+):(%d+),(%d+)")
            if id and x and y then
                otherPlayers[tonumber(id)] = { x = tonumber(x), y = tonumber(y) }
            end
        elseif err ~= "timeout" then
            print("Error receiving data:", err)
        end
    end
end

return Network
