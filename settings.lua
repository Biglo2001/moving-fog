data:extend({
  {
    type = "bool-setting",
    name = "fog-enabled",
    setting_type = "runtime-global",
    default_value = true,
    order = "a"
  },
  {
    type = "double-setting",
    name = "fog-density",
    setting_type = "runtime-global",
    default_value = 0.75,
    minimum_value = 0.1,
    maximum_value = 2.0,
    order = "b"
  },
  {
    type = "double-setting",
    name = "fog-speed",
    setting_type = "runtime-global",
    default_value = 0.18,
    minimum_value = 0.0,
    maximum_value = 1.0,
    order = "c"
  }
})
