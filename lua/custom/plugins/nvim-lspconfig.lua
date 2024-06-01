return {

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
}
