local Player = require("player")  -- Import the Player module
local Network = require("network") -- Import the Network module

local otherPlayers = {}

function love.load()
    Network.connectToServer()
end

function love.update(dt)
    -- Receive other players' positions
    Network.receivePositions(otherPlayers)

    -- Handle player movement and send updated position to the server
    if love.keyboard.isDown("right") then
        Player.move("right")
        Network.sendPosition(Player.getPosition())
    end
    if love.keyboard.isDown("left") then
        Player.move("left")
        Network.sendPosition(Player.getPosition())
    end
    if love.keyboard.isDown("down") then
        Player.move("down")
        Network.sendPosition(Player.getPosition())
    end
    if love.keyboard.isDown("up") then
        Player.move("up")
        Network.sendPosition(Player.getPosition())
    end
end

function love.draw()
    -- -- Draw the local player's circle
    -- love.graphics.setColor(1, 0, 0) -- Red for local player
    -- love.graphics.circle("fill", Player.x, Player.y, 20)

    -- Draw other players' circles
    love.graphics.setColor(0, 0, 1) -- Blue for other players
    for _, p in pairs(otherPlayers) do
        love.graphics.circle("fill", p.x, p.y, 20)
    end
end
