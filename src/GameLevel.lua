--[[
    GD50
    Super Mario Bros. Remake

    -- GameLevel Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameLevel = Class{}

function GameLevel:init(entities, objects, tilemap)
    self.tiles = {}
end

function GameLevel:update(dt)

end

function GameLevel:render()
    for i, tile in pairs(self.tiles)
      tile:render()
    end
end
