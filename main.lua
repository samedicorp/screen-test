-- -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
--  Created by Samedi on 20/08/2022.
--  All code (c) 2022, The Samedi Corporation.
-- -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

local Module = { }

function Module:register(parameters)
    modula:registerForEvents(self, "onStart", "onStop")
end

-- ---------------------------------------------------------------------
-- Example event handlers
-- ---------------------------------------------------------------------

function Module:onStart()
    printf("Screen Test started.")

    player.freeze(1)
    system.lockView(true)

    local service = modula:getService("screen")
    if service then
        local screen = service:registerScreen(self, "main", self.renderScript)
        if screen then
            self.screen = screen
            screen:send({ command = "test", argument = "hello world"})
        end
    end

end

function Module:onStop()
    player.freeze(0)
    system.lockView(false)
    printf("Screen Test stopped.")
end

function Module:onScreenReply(reply)
    printf("reply: %s", reply)
end

Module.renderScript = [[
if payload and payload.command then
    lastCommand = payload
    reply = "done"
end

local screen = toolkit.Screen.new()
local layer = screen:addLayer()
layer:addButton({100, 100, 60, 20}, "test", function()
    message = "test pressed"
end)
layer:addButton({100, 200, 60, 20}, "other", { 
    style = "lineStyle", 
    onMouseUp = function()
        message = "other pressed"
    end
})

startRect = startRect or {100, 300, 60, 20}
layer:addButton(startRect, "dragme", {
    onMouseDrag = function(pos, button)
        if not buttonOffset then
            buttonOffset = button.rect:topLeft():minus(pos)
            startRect = button.rect
        else
            local newPos = pos:plus(buttonOffset)
            startRect.x = newPos.x
            startRect.y = newPos.y
        end
    end
})

layer:addLabel({10, 20}, string.format("screen: %s", name))
if lastCommand then
    layer:addLabel({10, 40}, string.format("command: %s", lastCommand.command))
    layer:addLabel({10, 60}, string.format("argument: %s", lastCommand.argument))
    if rate then
        layer:addLabel({10, 100}, string.format("refresh: %s", rate))
    end
    if message then
        layer:addLabel({10, 80}, message)
    end
end

layer:render()
screen:scheduleRefresh()
]]

return Module