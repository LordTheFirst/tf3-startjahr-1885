local traffic = ug_require "start_year_1885::/traffic_support/availability.lua"
local buildings = ug_require "start_year_1885::/traffic_support/buildings.lua"

function data()
    return {
        runFn = function(_configDict, _allModParams)
            addModifier("loadModel", traffic.extendEarlyCoach)
            addModifier("loadConstruction", buildings.extendEarlyBuildings)
            print("[1885 Start Support r5] Private horse-coach, depot/maintenance and street-terminal modifiers registered")
        end,
    }
end
