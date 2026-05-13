data:extend({
  {
    type = "trivial-smoke",
    name = "fog-cloud",
    animation = {
      filename = "__moving-fog__/graphics/entity/fog/Clouds256.png",
      width = 256,
      height = 256,
      frame_count = 1,
      line_length = 1,
      animation_speed = 0.12,
      shift = {0, 0}
    },
    duration = 900,
    fade_in_duration = 120,
    fade_away_duration = 120,
    spread_duration = 760,
    start_scale = 0.75,
    end_scale = 1.25,
    color = {r = 0.85, g = 0.85, b = 0.85, a = 0.78},
    affected_by_wind = false,
    movement_slow_down_factor = 0.9,
    show_when_smoke_off = true,
    cyclic = true
  }
})
