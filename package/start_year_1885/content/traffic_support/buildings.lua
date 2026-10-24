local M = {}
local earlyBuildings = {
    ["/depots/road/road_depot/road_depot.con"] = 1940,
    ["/depots/road/tram_depot/tram_depot.con"] = 1940,
    ["/depots/road/road_maint_station.con"] = 1940,
    ["/depots/rail/rail_depot.con"] = 1940,
    ["/depots/rail/rail_maint_station.con"] = 1940,
    ["/depots/water/water_depot.con"] = 1940,
    ["/depots/water/water_maint_station.con"] = 1940,
    ["/stations/street/modular_street_station/modular_terminal.con"] = 1950,
}

function M.extendEarlyBuildings(fileName, construction)
    if type(fileName) ~= "string" or type(construction) ~= "table" then return construction end
    local path = fileName:gsub("\\", "/")
    if path:sub(1, 2) == "::" then
        path = path:sub(3)
    elseif path:find("::", 1, true) then
        return construction
    end
    if path:sub(1, 1) ~= "/" then path = "/" .. path end
    path = path:gsub("%.con%.lua$", ".con")
    local firstEraEnd = earlyBuildings[path]
    if not firstEraEnd then return construction end
    local templates = construction.constructionTemplates
    if type(templates) ~= "table" then return construction end
    local changed = 0
    for _, template in ipairs(templates) do
        if type(template) == "table" then
            local availability = template.availability
            if type(availability) == "table" and availability.yearFrom == 1900
                and availability.yearTo == firstEraEnd then
                availability.yearFrom = 1885
                changed = changed + 1
            end
        end
    end
    if changed > 0 then
        print("[1885 Start Support r5] " .. path .. ": " .. changed .. " early building template(s) from 1885")
    end
    return construction
end

return M
