local M = {}
local coaches = {
    ["/vehicle/car/coach_01/coach_01.mdl"] = true,
    ["/vehicle/car/coach_02/coach_02.mdl"] = true,
    ["/vehicle/car/coach_03/coach_03.mdl"] = true,
}

function M.extendEarlyCoach(fileName, model)
    if type(fileName) ~= "string" or type(model) ~= "table" then return model end
    local path = fileName:gsub("\\", "/")
    if path:sub(1, 2) == "::" then
        path = path:sub(3)
    elseif path:find("::", 1, true) then
        return model -- Other mods retain their own resource definitions.
    end
    if path:sub(1, 1) ~= "/" then path = "/" .. path end
    if not coaches[path] then return model end
    local metadata = model.metadata
    if type(metadata) ~= "table" or type(metadata.car) ~= "table"
        or metadata.transportVehicle ~= nil then return model end
    local availability = metadata.availability
    if type(availability) == "table" and availability.yearFrom == 1900
        and availability.yearTo == 1920 then
        availability.yearFrom = 1885
    end
    return model
end

return M
