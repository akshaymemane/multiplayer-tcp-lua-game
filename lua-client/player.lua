local Player = {}

-- Player properties
Player.x = 400
Player.y = 200
Player.speed = 10

-- Function to move the player based on input
function Player.move(direction)
    if direction == "right" then
        Player.x = Player.x + Player.speed
    elseif direction == "left" then
        Player.x = Player.x - Player.speed
    elseif direction == "down" then
        Player.y = Player.y + Player.speed
    elseif direction == "up" then
        Player.y = Player.y - Player.speed
    end
end

-- Function to get the player's position as a formatted string
function Player.getPosition()
    return string.format("%d,%d\n", Player.x, Player.y)
end

return Player
