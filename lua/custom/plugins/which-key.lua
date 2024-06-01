return {

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
}
