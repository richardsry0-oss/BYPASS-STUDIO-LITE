-- scripts/greet.lua
-- Reusable module: exposes greet() for use by other scripts and tests.

local M = {}

function M.greet(name: string): string
    if type(name) ~= "string" or name == "" then
        error("greet: 'name' must be a non-empty string", 2)
    end
    return string.format("Hello, %s! Welcome to your Luau dev tool.", name)
end

return M
