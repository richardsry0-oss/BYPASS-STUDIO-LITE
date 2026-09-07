-- scripts/hello.lua
-- Luau script: demonstrates structure, type annotations, error handling, and input validation.

local function greet(name: string): string
    if type(name) ~= "string" or name == "" then
        error("greet: 'name' must be a non-empty string", 2)
    end
    return string.format("Hello, %s! Welcome to your Luau dev tool.", name)
end

local ok, result = pcall(greet, "Travis")
if ok then
    print(result)
else
    print("Error: " .. tostring(result))
end

local ok2, err2 = pcall(greet, "")
if not ok2 then
    print("Validation caught as expected: " .. tostring(err2))
end
