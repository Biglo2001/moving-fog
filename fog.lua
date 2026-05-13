local M = {}

local random = math.random
local floor = math.floor

local function load_cfg()
  storage.cfg = storage.cfg or {}
  local g = settings.global
  storage.cfg.fog_enabled = g["fog-enabled"].value
  storage.cfg.fog_density = g["fog-density"].value
  storage.cfg.fog_speed = g["fog-speed"].value
  storage.cfg.spawn_interval = 15
  storage.cfg.spawn_radius = 42
  storage.cfg.grid_spacing = 8
end

local function ensure_state()
  storage.fog_last_spawn = storage.fog_last_spawn or 0
end

local function align_to_grid(value, grid)
  return floor(value / grid + 0.5) * grid
end

local function spawn_fog_cloud(surface, position)
  local speed_factor = storage.cfg.fog_speed * 0.02
  surface.create_trivial_smoke{
    name = "fog-cloud",
    position = position,
    speed = { x = (random() - 0.5) * speed_factor, y = (random() - 0.5) * speed_factor },
    height = 0.05,
    speed_multiplier = 0.5
  }
end

local function spawn_grid_fog(surface, center, count)
  local spacing = storage.cfg.grid_spacing
  local radius = storage.cfg.spawn_radius
  local half_cells = floor(radius / spacing)
  local origin_x = align_to_grid(center.x, spacing) - half_cells * spacing
  local origin_y = align_to_grid(center.y, spacing) - half_cells * spacing

  local positions = {}
  for row = 0, half_cells * 2 do
    for col = 0, half_cells * 2 do
      local x = origin_x + col * spacing
      local y = origin_y + row * spacing
      positions[#positions + 1] = { x = x, y = y }
    end
  end

  local total = #positions
  if count >= total then
    for _, pos in ipairs(positions) do
      spawn_fog_cloud(surface, pos)
    end
    return
  end

  for i = 1, count do
    local index = random(1, #positions)
    spawn_fog_cloud(surface, table.remove(positions, index))
  end
end

function M.on_init()
  load_cfg()
  ensure_state()
end

function M.on_configuration_changed()
  load_cfg()
  ensure_state()
end

function M.on_tick()
  if not storage.cfg.fog_enabled then
    return
  end

  local tick = game.tick
  if tick % storage.cfg.spawn_interval ~= 0 then
    return
  end

  local count = math.max(1, math.floor(storage.cfg.fog_density * 4))

  for _, player in pairs(game.connected_players) do
    if player.valid and player.character and player.render_mode == defines.render_mode.game then
      spawn_grid_fog(player.surface, player.position, count)
    end
  end
end

return M
