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

local font = loadFont("Play", 20)
local layer = createLayer()
addText(layer, font, string.format("screen: %s", name), 10, 20)
if lastCommand then
    addText(layer, font, string.format("command: %s", lastCommand), 10, 40)
    addText(layer, font, string.format("payload: %s", lastPayload), 10, 60)
end
]]

return Module