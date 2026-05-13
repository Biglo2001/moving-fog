local M = {}

local random = math.random
local sqrt = math.sqrt
local pi = math.pi

local function load_cfg()
  storage.cfg = storage.cfg or {}
  local g = settings.global
  storage.cfg.fog_enabled = g["fog-enabled"].value
  storage.cfg.fog_density = g["fog-density"].value
  storage.cfg.fog_speed = g["fog-speed"].value
  storage.cfg.spawn_interval = 15
  storage.cfg.spawn_radius = 42
end

local function ensure_state()
  storage.fog_last_spawn = storage.fog_last_spawn or 0
end

local function circle_offset(radius)
  local angle = random() * 2 * pi
  local distance = sqrt(random()) * radius
  return distance * math.cos(angle), distance * math.sin(angle)
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

  local count = math.max(1, math.floor(storage.cfg.fog_density * 3))
  local radius = storage.cfg.spawn_radius

  for _, player in pairs(game.connected_players) do
    if player.valid and player.character and player.render_mode == defines.render_mode.game then
      local pos = player.position
      for _ = 1, count do
        local dx, dy = circle_offset(radius)
        spawn_fog_cloud(player.surface, { x = pos.x + dx, y = pos.y + dy })
      end
    end
  end
end

return M
