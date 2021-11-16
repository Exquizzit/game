local composer = require( "composer" )

local menuScene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the menuScene event functions below will only be executed ONCE unless
-- the menuScene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local background
local title
local menuMap

-- -----------------------------------------------------------------------------------
-- menuScene event functions
-- -----------------------------------------------------------------------------------

-- create()
function menuScene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the menuScene is first created but has not yet appeared on screen
    menuMap = berry:new( 'maps/menuMap.json', 'assets/img' )
end


-- show()
function menuScene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the menuScene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the menuScene is entirely on screen

    end
end


-- hide()
function menuScene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the menuScene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the menuScene goes entirely off screen

    end
end


-- destroy()
function menuScene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of menuScene's view

end


-- -----------------------------------------------------------------------------------
-- menuScene event function listeners
-- -----------------------------------------------------------------------------------
menuScene:addEventListener( "create", menuScene )
menuScene:addEventListener( "show", menuScene )
menuScene:addEventListener( "hide", menuScene )
menuScene:addEventListener( "destroy", menuScene )
-- -----------------------------------------------------------------------------------

return menuScene
