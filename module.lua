-- -=module.lua-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
--  Created by Samedi on 20/08/2022.
--  All code (c) 2022, The Samedi Corporation.
-- -=module.lua-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-



local Module = { }

function Module:register(modula, parameters)
    modula:registerForEvents(self, "onStart", "onStop")
end

-- ---------------------------------------------------------------------
-- Example event handlers
-- ---------------------------------------------------------------------

function Module:onStart()
    printf("Screen Test started.")

    player.freeze(1)
    system.lockView(true)

    local service = self.modula:getService("screen")
    if service then
        local screen = service:registerScreen(self, "main", self.renderScript)
        if screen then
            self.screen = screen
            screen:send("test", "hello world")
        end
    end

end

function Module:onStop()
    player.freeze(0)
    system.lockView(false)
    printf("Screen Test stopped.")
end

function Module:onCommand(command, arguments)
    if command == "test" then
        printf("Hello from the test module")
    end
end

function Module:onScreenReply(reply)
    printf("reply: %s", reply)
end

Module.renderScript = [[
if command then
    lastCommand = command
    lastPayload = payload
    reply = "done"
end

local render = require('samedicorp.modula.render')
local layer = render.Layer()
layer:addButton("test", render.Rect(100, 100, 60, 20), function()
    message = "test pressed"
end)
layer:addButton("other", render.Rect(100, 200, 60, 20), function()
    message = "other pressed"
end)

layer:addLabel(string.format("screen: %s", name), 10, 20)
if lastCommand then
    layer:addLabel(string.format("command: %s", lastCommand), 10, 40)
    layer:addLabel(string.format("payload: %s", lastPayload), 10, 60)
    if rate then
        layer:addLabel(string.format("refresh: %s", rate), 10, 100)
    end
    if message then
        layer:addLabel(message, 10, 80)
    end
end
layer:render()

rate = layer:scheduleRefresh()
]]

return Module