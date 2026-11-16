return {
  'jedrzejboczar/devcontainers.nvim',
  config = function()
    require('devcontainers').setup({
      autostart = true,
      log_level = 'info',
    })
  end,
}
