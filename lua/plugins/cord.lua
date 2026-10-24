-- Discord Rich Presence: shows what you're editing on your Discord profile.
-- Needs the Discord desktop app open. On first start it downloads a small helper program.
return {
  'vyfor/cord.nvim',
  event = 'VeryLazy',
  config = function() require 'setup.cord' end,
}
