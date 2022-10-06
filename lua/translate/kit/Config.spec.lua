local Config = require('___plugin_name___.kit.Config')

describe('kit.Config', function()

  before_each(function()
    vim.cmd([[enew]])
  end)

  it('should {setup,get} global config', function()
    local config = Config.new()
    config:global({ key = 1 })
    assert.are.same(config:get(), { key = 1 })
  end)

  it('should {setup,get} filetype config', function()
    local config = Config.new()
    vim.cmd([[set filetype=lua]])
    config:filetype('lua', { key = 1 })
    assert.are.same(config:get(), { key = 1 })
    vim.cmd([[set filetype=]])
    assert.are.same(config:get(), {})
  end)

  it('should {setup,get} buffer config', function()
    local config = Config.new()
    config:buffer(0, { key = 1 })
    assert.are.same(config:get(), { key = 1 })
    vim.cmd([[new]])
    assert.are.same(config:get(), {})
  end)

  it('should merge configuration', function()
    local config = Config.new()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.cmd([[set filetype=lua]])
    config:global({ global = 1 })
    config:filetype('lua', { filetype = 1 })
    config:buffer(0, { buffer = 1  })
    assert.are.same(config:get(), { global = 1, filetype = 1, buffer = 1 })
    vim.cmd([[set filetype=]])
    assert.are.same(config:get(), { global = 1, buffer = 1 })
    vim.cmd([[new]])
    assert.are.same(config:get(), { global = 1 })
    vim.cmd(([[%sbuffer]]):format(bufnr))
    assert.are.same(config:get(), { global = 1, buffer = 1 })
    vim.cmd([[set filetype=lua]])
    assert.are.same(config:get(), { global = 1, filetype = 1, buffer = 1 })
  end)

end)

