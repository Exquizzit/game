--[[
    GD50
    Super Mario Bros. Remake

    -- PlayState Class --
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0

    self.background = math.random(3)
    self.backgroundX = 0

    self.gravityOn = true
    self.gravityAmount = 6
end

function PlayState:enter(params)
    self.level = cartographer.load("graphics/untitled.lua")

    -- self.player = {
    --   image = love.graphics.newImage("graphics/flag.png"),
    --   x = VIRTUAL_WIDTH / 2,
    --   y = VIRTUAL_HEIGHT / 2,
    --   r = 0,
    --   name = "player"
    -- }
    --
    -- function self.player:update(dt)
    --     self.r = self.r + math.rad(90 * dt)
    -- end
    --
    -- function self.player:draw()
  	-- 		local x = math.floor(self.x)
  	-- 		local y = math.floor(self.y)
  	-- 		local r = self.r
    --     love.graphics.setColor(1, 1, 1, 1)
  	-- 		love.graphics.draw(self.image, x, y, r)
	  --  end

    self.player = Player({
        x = 50, y = VIRTUAL_HEIGHT / 2,
        width = 16, height = 20,
        texture = 'green-alien',
        map = self.level,
        world = self.world
    })
    --
    -- --self:spawnEnemies()
    --
    -- self.player:changeState('falling')
end

function PlayState:update(dt)
    Timer.update(dt)

    -- remove any nils from pickups, etc.
    self.level:update(dt)
    self.player:update(dt)

    -- update player and level
    -- self.player:update(dt)
    -- self:updateCamera()

    -- constrain player X no matter which state
    -- if self.player.x <= 0 then
    --     self.player.x = 0
    -- elseif self.player.x > TILE_SIZE * self.tileMap.width - self.player.width then
    --     self.player.x = TILE_SIZE * self.tileMap.width - self.player.width
    -- end
end

function PlayState:render()
    love.graphics.push()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)

    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    self.level:draw()

    self.player:render()

    -- self.player:render()
    love.graphics.pop()

    -- render score
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 1)
    -- love.graphics.print(tostring(self.player.score), 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
    -- love.graphics.print(tostring(self.player.score), 4, 4)
end
