require 'opt'
require 'check_lazy'

-- [[ Настройка и установка плагинов ]]
--
--  Чтобы проверить текущее состояние ваших плагинов, запустите
--    :Lazy
--
--  Вы можете нажать "?" в этом меню для получения справки. Используйте ":q", чтобы закрыть окно
--
--  Чтобы обновить плагины, вы можете запустить
--    :Lazy update
--
-- NOTE: Здесь вы можете установить свои плагины.
require('lazy').setup({
  -- NOTE: Плагины могут быть добавлены по ссылке (или для репозитория на github: 'owner/repo' link).
  'tpope/vim-sleuth', -- Автоматическое определение уровня табуляции и ширины сдвига

  -- NOTE: Плагины также могут быть добавлены с помощью таблицы,
  -- где первым аргументом является ссылка, а следующие
  -- ключи могут использоваться для настройки поведения плагина/загрузки/и т.д.
  --
  -- Используйте `opts = {}`, чтобы принудительно загрузить плагин.
  --
  --  Это эквивалентно:
  --    require('Comment').setup({})

  -- "gc" для комментирования визуальных областей/строк
  { 'numToStr/Comment.nvim', opts = {} },

  -- Вот более продвинутый пример, в котором мы передаем configuration
  -- options в `gitsigns.nvim`. Это эквивалентно следующему Lua:
  -- require('gitsigns').setup({ ... })
  --
  -- Смотрите раздел `:help gitsigns", чтобы понять, что делают конфигурационные ключи
  { -- Добавляет в желоб знаки, связанные с git, а также утилиты для управления изменениями
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- NOTE: Плагины также можно настроить на запуск Lua-кода при их загрузке.
  --
  -- Это часто очень полезно как для настройки группы, так и для управления
  -- плагины с отложенной загрузкой, которые не нужно загружать сразу при запуске.
  --
  -- Например, в следующей конфигурации мы используем:
  --  event = 'VimEnter'
  --
  -- который загружает which-key перед загрузкой всех элементов пользовательского интерфейса. Событиями могут быть
  -- обычные события autocommands (`:help autocmd-events`).
  --
  -- Затем, поскольку мы используем ключ "config", выполняется только настройка
  -- после загрузки плагина:
  -- config = function() ... end

  { -- Полезный плагин для отображения ожидающих ввода комбинаций клавиш.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Устанавливает для события загрузки значение "VimEnter"
    config = function() -- Это функция, которая запускается ПОСЛЕ загрузки
      require('which-key').setup()

      -- Документируйте существующие цепочки ключей
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
        ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
        ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
      }
      -- visual mode
      require('which-key').register({
        ['<leader>h'] = { 'Git [H]unk' },
      }, { mode = 'v' })
    end,
  },

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

  { -- Настройка и плагины LSP
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Автоматическая установка LSP и связанных с ними инструментов в stdpath для Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Должен быть загружен раньше, чем dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Полезные обновления статуса для LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` настраивает Lua LSP для вашей конфигурации Neovim, среды выполнения и плагинов
      -- используется для завершения, аннотаций и подписей API Neovim
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      -- Краткое отступление: **Что такое LSP?**
      --
      -- LSP — это аббревиатура, которую вы, вероятно, слышали, но, возможно, не понимаете, что это такое.
      --
      -- LSP расшифровывается как Language Server Protocol (Протокол Серверов Языка). Это протокол, который помогает редакторам
      -- и инструментам для работы с языками программирования взаимодействовать стандартизированным образом.
      --
      -- В общем, у вас есть "сервер", который представляет собой инструмент, созданный для понимания конкретного
      -- языка (например, `gopls`, `lua_ls`, `rust_analyzer` и т.д.). Эти серверы языков (иногда называемые серверами LSP,
      -- что похоже на "машина с банкоматом") являются отдельными процессами, которые взаимодействуют с "клиентом" - в данном случае, Neovim!
      --
      -- LSP предоставляет Neovim такие возможности, как:
      --  - Переход к определению
      --  - Поиск ссылок
      --  - Автозавершение
      --  - Поиск символов
      --  - и многое другое!
      --
      -- Таким образом, серверы языков являются внешними инструментами, которые необходимо устанавливать отдельно от
      -- Neovim. Здесь на помощь приходят `mason` и связанные с ним плагины.
      --
      -- Если вас интересует разница между lsp и treesitter, вы можете ознакомиться с прекрасно
      -- и элегантно составленным разделом справки `:help lsp-vs-treesitter`.

      -- Эта функция выполняется, когда LSP подключается к конкретному буферу.
      -- Иными словами, каждый раз, когда открывается новый файл, связанный с
      -- LSP (например, открытие `main.rs` связано с `rust_analyzer`), эта
      -- функция будет выполняться для настройки текущего буфера.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- ЗАМЕТКА: Помните, что Lua — это настоящий язык программирования, и поэтому возможно
          -- определять небольшие вспомогательные функции, чтобы не повторяться.
          --
          -- В данном случае мы создаем функцию, которая позволяет нам легче определять сопоставления клавиш,
          -- специфичные для элементов, связанных с LSP. Она задает режим, буфер и описание для нас каждый раз.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Перейти к определению слова под курсором.
          -- Это место, где переменная была впервые объявлена или где определена функция и т.д.
          -- Чтобы вернуться назад, нажмите <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Найти ссылки на слово под курсором.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Перейти к реализации слова под курсором.
          -- Полезно, когда ваш язык имеет способы объявления типов без реальной реализации.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Перейти к типу слова под курсором.
          -- Полезно, когда вы не уверены, какого типа переменная, и хотите увидеть
          -- определение ее *типа*, а не место, где она была *определена*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Нечеткий поиск всех символов в текущем документе.
          -- Символы — это такие вещи, как переменные, функции, типы и т.д.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Нечеткий поиск всех символов в текущем рабочем пространстве.
          -- Похоже на символы документа, но ищет по всему вашему проекту.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Переименовать переменную под курсором.
          -- Большинство серверов LSP поддерживают переименование через файлы и т.д.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Выполнить действие с кодом, обычно ваш курсор должен находиться на ошибке
          -- или предложении от вашего LSP, чтобы это активировалось.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Открыть всплывающее окно, которое отображает документацию о слове под курсором.
          -- См. `:help K` для информации о том, почему используется эта клавиша.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- ПРЕДУПРЕЖДЕНИЕ: Это не Переход к определению, это Переход к объявлению.
          -- Например, в C это приведет вас к заголовочному файлу.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Следующие две автокоманды используются для подсветки ссылок на слово под вашим курсором,
          -- когда курсор находится на нем некоторое время.
          -- См. `:help CursorHold` для информации о том, когда это выполняется.
          --
          -- Когда вы перемещаете курсор, подсветка будет очищена (вторая автокоманда).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- Следующая автокоманда используется для включения подсказок в вашем коде,
          -- если ваш сервер языка поддерживает их.
          --
          -- Это может быть нежелательным, так как они могут смещать часть вашего кода.
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Серверы и клиенты LSP могут сообщать друг другу, какие возможности они поддерживают.
      -- По умолчанию Neovim не поддерживает все, что есть в спецификации LSP.
      -- Когда вы добавляете nvim-cmp, luasnip и т.д., Neovim получает *больше* возможностей.
      -- Поэтому мы создаем новые возможности с nvim-cmp и передаем их серверам.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Включение следующих серверов языка
      -- Чувствуйте себя свободно добавлять/удалять любые LSP, которые вам нужны. Они будут автоматически установлены.
      --
      -- Добавьте любую дополнительную конфигурацию в следующие таблицы. Доступные ключи:
      -- - cmd (table): Переопределить команду по умолчанию, используемую для запуска сервера.
      -- - filetypes (table): Переопределить список типов файлов, связанных с сервером.
      -- - capabilities (table): Переопределить поля в возможностях. Можно использовать для отключения некоторых функций LSP.
      -- - settings (table): Переопределить настройки по умолчанию, передаваемые при инициализации сервера.
      -- Например, чтобы увидеть опции для `lua_ls`, вы можете перейти на: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        gopls = {},
        pyright = {},
        rust_analyzer = {},
        -- ... и т.д. См. `:help lspconfig-all` для списка всех предустановленных LSP.
        --
        -- Некоторые языки (например, TypeScript) имеют целые плагины для языка, которые могут быть полезны:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- Но для многих настроек сервер LSP (`tsserver`) будет работать отлично.
        tsserver = {},
        marksman = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- Вы можете включить ниже, чтобы игнорировать шумные предупреждения `missing-fields` от Lua_LS.
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Убедитесь, что указанные выше серверы и инструменты установлены.
      -- Чтобы проверить текущее состояние установленных инструментов и/или вручную установить
      -- другие инструменты, вы можете запустить:
      -- :Mason
      --
      -- Вы можете нажать `g?` для получения справки в этом меню.
      require('mason').setup()

      -- Вы можете добавить сюда другие инструменты, которые хотите, чтобы Mason установил
      -- для вас, чтобы они были доступны в Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Используется для форматирования кода Lua.
        'mdformat', -- Используется для форматирования кода markdown.
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- Это обрабатывает переопределение только тех значений, которые явно переданы
            -- в конфигурации сервера выше. Полезно при отключении
            -- некоторых функций LSP (например, отключение форматирования для tsserver).
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { 'isort', 'black' },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        javascript = { { 'prettierd', 'prettier' } },
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      -- ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
      ensure_installed = { 'lua', 'luadoc', 'markdown', 'python', 'rust' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
