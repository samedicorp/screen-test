local useLocal = true --export: Use require() to load local scripts if present. Useful during development.
local logging = true --export: Enable controller debug output.

modulaSettings = { 
    name = "Screen Test",
    version = "1.0",
    logging = logging, 
    useLocal = useLocal,
    modules = {
        ["samedicorp.screen-test.module"] = { name = "main" },
        ["samedicorp.modula.modules.console"] = { name = "console" },
        ["samedicorp.modula.modules.screen"] = { }
    }
}


