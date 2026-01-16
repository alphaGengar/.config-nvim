-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.
-- stylua: ignore
local colors = {
  blue        = '#80a0ff',
  cyan        = '#79dac8',
  black       = '#080808',
  white       = '#c6c6c6',
  red         = '#ff5189',
  violet      = '#d183e8',
  grey        = '#303030',
  comp_bg     = '#e64553', -- Background for the title
  comp_fg     = '#080808', -- Foreground (title text)
  comp_sep_bg = '#000000', -- Separator background
}

vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
vim.api.nvim_set_hl(0, "TabLine", { bg = "none" })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none" })
vim.api.nvim_set_hl(0, "TabLineSel", { bg = "none" })

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = "none" },
    c = { fg = colors.white, bg = "none" },
  },
  insert = { a = { fg = colors.black, bg = colors.blue }, b = { fg = colors.white, bg = "none" }, c = { fg = colors.white, bg = "none" } },
  visual = { a = { fg = colors.black, bg = colors.cyan }, b = { fg = colors.white, bg = "none" }, c = { fg = colors.white, bg = "none" } },
  replace = { a = { fg = colors.black, bg = colors.red }, b = { fg = colors.white, bg = "none" }, c = { fg = colors.white, bg = "none" } },
  inactive = {
    a = { fg = colors.white, bg = "none" },
    b = { fg = colors.white, bg = "none" },
    c = { fg = colors.white, bg = "none" },
  },
}
-- Define custom highlight groups for the component with a transparent background
vim.api.nvim_set_hl(0, 'CompetitestBackground', { bg = 'none' })
vim.api.nvim_set_hl(0, 'CompetitestRightSeparator', { fg = colors.comp_bg, bg = colors.comp_sep_bg })
vim.api.nvim_set_hl(0, 'CompetitestTitle', { fg = colors.comp_fg, bg = colors.comp_bg, bold = true })

-- Function to center the title with separators and transparent background
local function competitest_title()
  local buf = vim.api.nvim_get_current_buf()
  local ok, title = pcall(vim.api.nvim_buf_get_var, buf, 'competitest_title')

  -- Return an empty string if no title is set
  if not ok or title == '' then
    return ''
  end

  -- Window width and separator/title lengths
  local total_width = vim.api.nvim_win_get_width(0)
  local right_sep = '▓▒░'
  local content = '' .. ' ' .. title .. ' ' .. right_sep
  local content_length = #content

  -- Calculate padding
  local left_padding = math.floor((total_width - content_length) / 2)
  local right_padding = total_width - content_length - left_padding

  -- Return padded and styled content with a colored background
  return table.concat({
    '%#CompetitestBackground#' .. " ",
    '%#CompetitestTitle# ' .. title .. ' ',
    '%#CompetitestRightSeparator#' .. right_sep,
    '%#CompetitestBackground#' .. string.rep(' ', right_padding),
  })
end


-- Function to get the main buffer information
local function get_main_buf_info()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_ft = vim.bo[current_buf].filetype

  -- If we're already in a main buffer (not NvimTree or CompetiTest), use current buffer
  if current_ft ~= 'NvimTree' and not string.match(current_ft, 'CompetiTest') then
    return current_buf
  end

  -- Otherwise, find the first non-auxiliary buffer
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local ft = vim.bo[buf].filetype
      -- Check if it's a main buffer (e.g., cpp file)
      if ft ~= 'NvimTree'
          and not string.match(ft, 'CompetiTest')
          and ft ~= ''
          and ft ~= 'qf'   -- Exclude quickfix windows
          and ft ~= 'help' -- Exclude help windows
      then
        return buf
      end
    end
  end
  return current_buf -- Fallback to current buffer if no main buffer found
end

-- Custom filename component that always shows main buffer
local function main_filename()
  local main_buf = get_main_buf_info()
  return vim.fn.bufname(main_buf)
end

-- Custom filetype component with icon
local function main_filetype_with_icon()
  local main_buf = get_main_buf_info()
  local filetype = vim.bo[main_buf].filetype

  -- Require devicons (make sure you have nvim-web-devicons installed)
  local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
  if not has_devicons then
    return filetype
  end

  -- Get icon for the filetype
  local icon, color = devicons.get_icon_by_filetype(filetype)

  -- If no icon found, just return the filetype
  if not icon then
    return filetype
  end

  -- Return formatted string with icon
  return string.format("%s  %s", icon, filetype)
end

-- Custom filetype component that always shows main buffer
local function main_filetype()
  local main_buf = get_main_buf_info()
  return vim.bo[main_buf].filetype
end

-- Custom diagnostics component that always shows main buffer
local function main_diagnostics()
  local main_buf = get_main_buf_info()
  local diagnostics = vim.diagnostic.get(main_buf)
  local counts = { error = 0, warn = 0, info = 0, hint = 0 }

  for _, diagnostic in ipairs(diagnostics) do
    counts[diagnostic.severity] = (counts[diagnostic.severity] or 0) + 1
  end

  return {
    error = counts.error,
    warn = counts.warn,
    info = counts.info,
    hint = counts.hint,
  }
end

require('lualine').setup {
  options = {
    theme = bubbles_theme,
    component_separators = '',
    section_separators = { left = '', right = '' },
    globalstatus = true,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 3 } },
    lualine_b = {
      { main_filename },
      'branch'
    },
    lualine_c = {
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        sections = { 'error', 'warn', 'info', 'hint' },
        symbols = { error = '  ', warn = '  ', info = '  ', hint = '  ' },
        colored = true,
        update_in_insert = false,
        always_visible = true,
        fn = main_diagnostics,
      },
    },
    lualine_x = {},
    lualine_y = { { main_filetype_with_icon }, 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 3 },
    },
  },
  inactive_sections = {
    lualine_a = { { main_filename } },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { competitest_title } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { competitest_title } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}
