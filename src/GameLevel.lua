--[[
    GD50
    Super Mario Bros. Remake

    -- GameLevel Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameLevel = Class{}

function GameLevel:init(tilemap)

end

function GameLevel:update(dt)

end

function GameLevel:render()
    for i, tile in pairs(self.tiles) do
      tile:render()
    end
end
