Player = Class{}

local speed = 40

function Player:init(def)
    self.width = def.width
    self.height = def.height

    self.x = def.x
    self.y = def.y

    self.texture = def.texture
    self.level = def.map
end

function Player:collides(obj)
  return not (self.x > obj.x + obj.width or obj.x > self.x + self.width or
              self.y > obj.y + obj.height or obj.y > self.y + self.height)
end

function Player:update(dt)
  if love.keyboard.isDown("a") then
    local futureCollide = false

    self.x = self.x - 1

    for i, tile in pairs(self.level.tiles) do
      if self:collides(tile) then futureCollide = true end
    end

    self.x = self.x + 1

    if not futureCollide then
      self.x = self.x - speed * dt
    end
  elseif love.keyboard.isDown("d") then
    local futureCollide = false

    self.x = self.x + 1

    for i, tile in pairs(self.level.tiles) do
      if self:collides(tile) then futureCollide = true end
    end

    self.x = self.x - 1

    if not futureCollide then
      self.x = self.x + speed * dt
    end
  end
end

function Player:render()
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end
