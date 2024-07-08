vim.opt.relativenumber = true
vim.api.nvim_create_user_command("DiagnosticToggle", function()
	local config = vim.diagnostic.config
	local vt = config().virtual_text
	config {
		virtual_text = not vt,
		underline = not vt,
		signs = not vt,
	}
end, { desc = "toggle diagnostic" })

local M = {}
M.ui = {
  theme_toggle = {"gruvchad", "catppuccin"},
  theme = "gruvchad",
  transparency = true,
}
M.plugins = "custom.plugins"

return M
