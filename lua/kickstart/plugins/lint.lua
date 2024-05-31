return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- Установка linters для конкретных типов файлов
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
      }

      -- Отключение линтеров по умолчанию
      local disabled_linters = {
        'clojure',
        'dockerfile',
        'inko',
        'janet',
        'json',
        'rst',
        'ruby',
        'terraform',
        'text',
      }
      for _, ft in ipairs(disabled_linters) do
        lint.linters_by_ft[ft] = nil
      end

      -- Создание автокоманды для запуска линтера при определенных событиях
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}

-- return {
--
--   { -- Linting
--     'mfussenegger/nvim-lint',
--     event = { 'BufReadPre', 'BufNewFile' },
--     config = function()
--       local lint = require 'lint'
--       lint.linters_by_ft = {
--         markdown = { 'markdownlint' },
--       }
--
--       -- Чтобы разрешить другим плагинам добавлять linters в require('lint').linters_by_ft,
--       -- вместо этого установите linters_by_ft следующим образом:
--       lint.linters_by_ft = lint.linters_by_ft or {}
--       -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
--       --
--       -- Однако обратите внимание, что это включит набор стандартных
--       -- средств компоновки, которые будут вызывать ошибки, если эти инструменты не будут доступны:
--       {
--         clojure = { "clj-kondo" },
--         dockerfile = { "hadolint" },
--         inko = { "inko" },
--         janet = { "janet" },
--         json = { "jsonlint" },
--         markdown = { "vale" },
--         rst = { "vale" },
--         ruby = { "ruby" },
--         terraform = { "tflint" },
--         text = { "vale" }
--       }
--       --
--       -- Вы можете отключить линтеры по умолчанию, установив для них типы файлов равными нулю:
--       lint.linters_by_ft['clojure'] = nil
--       lint.linters_by_ft['dockerfile'] = nil
--       lint.linters_by_ft['inko'] = nil
--       lint.linters_by_ft['janet'] = nil
--       lint.linters_by_ft['json'] = nil
--       lint.linters_by_ft['markdown'] = nil
--       lint.linters_by_ft['rst'] = nil
--       lint.linters_by_ft['ruby'] = nil
--       lint.linters_by_ft['terraform'] = nil
--       lint.linters_by_ft['text'] = nil
--
--       -- Создать автокоманду, которая выполняет фактическую корректировку
--       -- по указанным событиям.
--       local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
--       vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
--         group = lint_augroup,
--         callback = function()
--           require('lint').try_lint()
--         end,
--       })
--     end,
--   },
-- }
