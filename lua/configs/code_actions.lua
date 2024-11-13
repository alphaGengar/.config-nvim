local M = {}

function M.setup()
  require("actions-preview").setup({
    backend = { "telescope", "nui" },

    telescope = vim.tbl_extend(
      "force",
      require("telescope.themes").get_dropdown({
        layout_config = {
          width = 0.4,
          height = 0.4,
        },
        borderchars = {
          prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        },
      }),
      {
        previewer = false, -- Disable preview for a cleaner look
      }
    ),

    nui = {
      dir = "row", -- Horizontal layout is usually cleaner
      layout = {
        position = "50%",
        size = {
          width = "40%",
          height = "30%",
        },
        min_width = 40,
        min_height = 10,
        relative = "editor",
      },
      preview = {
        size = "60%",
        border = {
          style = "single", -- Simpler border style
          padding = { 0, 1 },
          text = {
            top = " Preview ",
          },
        },
      },
      select = {
        size = "40%",
        border = {
          style = "single", -- Simpler border style
          padding = { 0, 1 },
          text = {
            top = " Actions ",
          },
        },
      },
    },
  })

end

return M
