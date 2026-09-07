-- tests/run_tests.lua
-- Minimal local test runner. Add each test module's name (without .lua)
-- to testModules below, then run: luau tests/run_tests.lua

local testModules = {
    "test_greet",
}

local totalPassed, totalFailed = 0, 0

for _, moduleName in ipairs(testModules) do
    local ok, cases = pcall(require, "./" .. moduleName)
    if not ok then
        print(string.format("[LOAD ERROR] %s: %s", moduleName, tostring(cases)))
        totalFailed += 1
    elseif type(cases) ~= "table" then
        print(string.format("[LOAD ERROR] %s did not return a test case table", moduleName))
        totalFailed += 1
    else
        for _, case in ipairs(cases) do
            local passed, err = pcall(case.fn)
            if passed then
                print(string.format("  [PASS] %s :: %s", moduleName, case.name))
                totalPassed += 1
            else
                print(string.format("  [FAIL] %s :: %s -- %s", moduleName, case.name, tostring(err)))
                totalFailed += 1
            end
        end
    end
end

print(string.format("\n%d passed, %d failed", totalPassed, totalFailed))
if totalFailed > 0 then
    os.exit(1)
end
