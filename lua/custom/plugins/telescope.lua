return {

  -- NOTE: Плагины могут указывать зависимости.
  --
  -- Зависимости также являются соответствующими спецификациями плагина - все, что угодно
  -- вы делаете это для плагина на верхнем уровне, вы можете сделать это для зависимости.
  --
  -- Используйте ключ `dependencies`, чтобы указать зависимости конкретного плагина

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- Если вы столкнулись с ошибками, инструкции по установке смотрите в разделе telescope-fzf-native README
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` используется для запуска некоторой команды при установке/обновлении плагина.
        -- Это выполняется только тогда, а не при каждом запуске Neovim.
        build = 'make',

        -- "cond" - это условие, используемое для определения того, следует ли
        -- устанавливать и загружать этот плагин.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Полезно для создания красивых иконок, но требует использования шрифта Nerd.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Телескоп - это прибор для поиска нечетких изображений, который поставляется с большим количеством различных предметов, которые он может найти нечетко! Это больше, чем просто "поисковик файлов", он может выполнять поиск
      -- множество различных аспектов Neovim, ваше рабочее пространство, LSP и многое другое!
      --
      -- Самый простой способ использовать Telescope - это начать с выполнения чего-то вроде:
      -- :Telescope help_tags
      --
      -- После выполнения этой команды откроется окно, в котором вы сможете
      -- ввести в окне подсказки. Вы увидите список опций `help_tags` и
      -- соответствующий предварительный просмотр справки.
      --
      -- В Telescope можно использовать две важные комбинации клавиш:
      -- - Режим вставки: <c-/>
      -- - Обычный режим: ?
      --
      -- Откроется окно, в котором отображаются все настройки для текущего телескопа.
      -- Выбор телескопа. Это действительно полезно, чтобы узнать, что может делать телескоп, а также как это сделать на самом деле!
      -- [[ Настройка телескопа ]]
      -- Смотрите раздел `:help telescope` и `:help telescope.setup()`.
      require('telescope').setup {
        -- Вы можете установить свои стандартные сопоставления / обновления / и т.д. здесь
        -- Вся информация, которую вы ищете, находится в разделе ":help telescope.setup()".
        --
        defaults = {
          mappings = {
            i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          },
        },
        pickers = {},
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Включите расширения телескопа, если они установлены
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- Вы можете передать дополнительные настройки в Telescope, чтобы изменить тему, макет и т.д.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = true,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- Также возможно передать дополнительные параметры конфигурации.
      -- Смотрите ":help telescope.builtin.live_grep()" для получения информации о конкретных ключах
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Ярлык для поиска ваших конфигурационных файлов Neovim
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
