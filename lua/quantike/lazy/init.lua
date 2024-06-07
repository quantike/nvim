return {

    {
        "nvim-lua/plenary.nvim",
        name = "plenary"
    },

    "eandrju/cellular-automaton.nvim",
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = false,
                    theme = 'gruvbox',
                    component_separators = { left = '', right = ''},
                    section_separators = { left = '', right = ''},
                }
            }
        end
    },
    {
      'numToStr/Comment.nvim',
      config = function()
          require('Comment').setup()
      end
  }
}
