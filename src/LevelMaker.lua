--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    local levelX = width

    for x = 1, width, 1 do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        local emptyChance = math.random(1, 7)

        if x == 1 then 
            emptyChance = 7
        end    

        -- chance to just be emptiness
        if emptyChance == 1 then
            if x ~= 1 then
                for y = 7, height do
                    table.insert(tiles[y],
                        Tile(x, y, tileID, nil, tileset, topperset))
                end
            end    
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if x ~= 1 then
                if math.random(8) == 1 then
                    blockHeight = 2
                    
                    -- chance to generate bush on pillar
                    if math.random(8) == 1 then
                        table.insert(objects,
                            GameObject {
                                texture = 'bushes',
                                x = (x - 1) * TILE_SIZE,
                                y = (4 - 1) * TILE_SIZE,
                                width = 16,
                                height = 16,
                                
                                -- select random frame from bush_ids whitelist, then random row for variance
                                frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                                collidable = false
                            }
                        )
                    end
                    
                    -- pillar tiles
                    if x ~= 1 then
                        tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                        tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                        if tiles[7] then
                            if tiles[7][x] then
                                tiles[7][x].topper = nil
                            else
                                tiles[7][x] = nil
                            end    
                        end    
                    end    
                
                -- chance to generate bushes
                elseif math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (6 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end 
            end       

            -- chance to spawn a block
            local blockChance = math.random(1,20)
            if blockChance == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                local itemChance = math.random(1, 20)
                                if itemChance > 15 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                elseif itemChance == 2 then 
                                    local randomKeyNumber = math.random(1,4)

                                    local key = GameObject {
                                        texture = 'keys_and_locks',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = randomKeyNumber,
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            table.insert(player.keys, randomKeyNumber)
                                        end
                                    }
                                                
                                        -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [key] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, key)
                                    obj.hit = true
                                end
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )

            elseif blockChance == 2 then
                table.insert(objects, 
                    GameObject {
                        texture = 'keys_and_locks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        frame = math.random(5,8),
                        collidable = true,
                        hit = false,
                        solid = true,

                        onCollide = function(obj, player)
                            local hasCKey = false
                            for i, v in pairs(player.keys) do
                                if v == (obj.frame - 4) then 
                                    hasCKey = true   
                                end    
                            end  

                            --if hasCKey then 
                                local index = nil
                                for k, v in pairs(objects) do
                                    if v == obj then 
                                        index = k
                                    end    
                                end 

                                if index then 
                                    table.remove(objects, index)
                                end 

                                local flag = GameObject {
                                        texture = 'flag',
                                        x = levelX + 1483,
                                        y = 3 * TILE_SIZE - 5,
                                        width = 16,
                                        height = 48,
                                        frame = 1,
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- flag has its own function to reset level
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            gStateMachine:change('play', {
                                                width = 150
                                            })
                                        end
                                    }

                                table.insert(objects, flag)   
                            --end    


                            gSounds['empty-block']:play()
                        end  
                    }
                )    
            end
        end
    end    

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end

