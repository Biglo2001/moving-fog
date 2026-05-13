local fog = require("fog")

local function on_init()
  fog.on_init()
end

local function on_configuration_changed()
  fog.on_configuration_changed()
end

script.on_init(on_init)
script.on_configuration_changed(on_configuration_changed)
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  if event.setting and event.setting:find("^fog%-") then
    fog.on_configuration_changed()
  end
end)
script.on_event(defines.events.on_tick, fog.on_tick)
script.on_event(defines.events.on_surface_created, on_configuration_changed)
script.on_event(defines.events.on_surface_deleted, on_configuration_changed)
