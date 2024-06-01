return {

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
}
