Tile = Class{}

function Tile:init(x, y, id, topper, tileset, topperset)
    self.x = x
    self.y = y

    self.width = TILE_SIZE
    self.height = TILE_SIZE

    self.frame = def.frame
    self.texture = def.texture
end

function Tile:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.frame], self.x, self.y)
end
