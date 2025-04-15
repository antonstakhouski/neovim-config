-- update .po files
function UpdateTranslations()
  local command = 'conda activate issa_debug; export FLASK_APP=issa; flask translate update'
  vim.api.nvim_out_write('Translating files...\n')
  local job_id = vim.fn.jobstart(command, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.api.nvim_out_write('Files translated successfully\n')
      else
        vim.api.nvim_out_write('Error translating files\n')
      end
    end,
  })
end

vim.api.nvim_set_keymap('n', '<F5>', '<cmd>lua UpdateTranslations()<CR>', { noremap = true, silent = true })
