local M = {}
local api = vim.api

local hl_config = {}

local groups = {
  { "WinBufActive",            "active" },
  { "WinBufActiveSep",         "active_sep" },
  { "WinBufInactive",          "inactive" },
  { "WinBufInactiveSep",       "inactive_sep" },
  { "WinBufActiveClose",       "active_close" },
  { "WinBufInactiveClose",     "inactive_close" },
  { "WinBufActiveModified",    "active_modified" },
  { "WinBufInactiveModified",  "inactive_modified" },
  { "WinBufActiveDiagError",   "active_diag_error" },
  { "WinBufActiveDiagWarn",    "active_diag_warn" },
  { "WinBufInactiveDiagError", "inactive_diag_error" },
  { "WinBufInactiveDiagWarn",  "inactive_diag_warn" },
  { "WinBufFill",              "fill" },
  { "WinBufActiveUnderline",   "active_underline" },
}

local function exists(name)
  local ok, hl = pcall(api.nvim_get_hl, 0, { name = name, link = true })
  return ok and next(hl) ~= nil
end

local function apply()
  for _, def in ipairs(groups) do
    local name = hl_config[def[2]]
    if type(name) ~= "string" or name == "" or not exists(name) then
      name = "Normal"
    end
    api.nvim_set_hl(0, def[1], { link = name })
  end
end

function M.setup(hl)
  hl_config = hl or {}
  apply()

  api.nvim_create_autocmd("ColorScheme", {
    group = api.nvim_create_augroup("WinBufHighlights", { clear = true }),
    callback = apply,
  })

  -- Some themes apply colors on a deferred schedule. Reapply once more
  -- after the event loop settles to make sure we win.
  vim.schedule(apply)
end

return M
