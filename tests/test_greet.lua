-- tests/test_greet.lua
local greetModule = require("../scripts/greet")

return {
    {
        name = "greet returns expected message",
        fn = function()
            local result = greetModule.greet("Travis")
            assert(result == "Hello, Travis! Welcome to your Luau dev tool.", "unexpected message: " .. result)
        end,
    },
    {
        name = "greet rejects empty string",
        fn = function()
            local ok = pcall(greetModule.greet, "")
            assert(not ok, "expected error on empty name")
        end,
    },
    {
        name = "greet rejects non-string input",
        fn = function()
            local ok = pcall(greetModule.greet, 42)
            assert(not ok, "expected error on non-string name")
        end,
    },
}
