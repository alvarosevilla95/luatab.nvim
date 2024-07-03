local M = {}

M.tab_labels = {'default'}

M.title = function(bufnr, current_label)
    local file = vim.fn.bufname(bufnr)
    local buftype = vim.fn.getbufvar(bufnr, '&buftype')
    local filetype = vim.fn.getbufvar(bufnr, '&filetype')

    if current_label ~= "default" then
        return current_label
    end

    if buftype == 'help' then
        return 'help:' .. vim.fn.fnamemodify(file, ':t:r')
    elseif buftype == 'quickfix' then
        return 'quickfix'
    elseif filetype == 'TelescopePrompt' then
        return 'Telescope'
    elseif filetype == 'git' then
        return 'Git'
    elseif filetype == 'fugitive' then
        return 'Fugitive'
    elseif filetype == 'NvimTree' then
        return 'NvimTree'
    elseif filetype == 'oil' then
        return 'Oil'
    elseif file:sub(file:len()-2, file:len()) == 'FZF' then
        return 'FZF'
    elseif buftype == 'terminal' then
        local _, mtch = string.match(file, "term:(.*):(%a+)")
        return mtch ~= nil and mtch or vim.fn.fnamemodify(vim.env.SHELL, ':t')
    elseif file == '' then
        return '[No Name]'
    else
        return vim.fn.pathshorten(vim.fn.fnamemodify(file, ':p:~:t'))
    end
end

M.modified = function(bufnr)
    return vim.fn.getbufvar(bufnr, '&modified') == 1 and '[+] ' or ''
end

M.windowCount = function(index)
    local nwins = vim.fn.tabpagewinnr(index, '$')
    return nwins > 1 and '(' .. nwins .. ') ' or ''
end

M.devicon = function(bufnr, isSelected, current_label)
    local icon, devhl
    local file = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':t')
    local buftype = vim.fn.getbufvar(bufnr, '&buftype')
    local filetype = vim.fn.getbufvar(bufnr, '&filetype')
    local devicons = require'nvim-web-devicons'

    if current_label ~= 'default' then
        return "🌝"
    end

    if filetype == 'TelescopePrompt' then
        icon, devhl = devicons.get_icon('telescope')
    elseif filetype == 'fugitive' then
        icon, devhl = devicons.get_icon('git')
    elseif filetype == 'vimwiki' then
        icon, devhl = devicons.get_icon('markdown')
    elseif buftype == 'terminal' then
        icon, devhl = devicons.get_icon('zsh')
    else
        icon, devhl = devicons.get_icon(file, vim.fn.expand('#'..bufnr..':e'))
    end
    if icon then
        local h = require'luatab.highlight'
        local fg = h.extract_highlight_colors(devhl, 'fg')
        local bg = h.extract_highlight_colors('TabLineSel', 'bg')
        local hl = h.create_component_highlight_group({bg = bg, fg = fg}, devhl)
        local selectedHlStart = (isSelected and hl) and '%#'..hl..'#' or ''
        local selectedHlEnd = isSelected and '%#TabLineSel#' or ''
        return selectedHlStart .. icon .. selectedHlEnd .. ' '
    end
    return ''
end

M.separator = function(index)
    return (index < vim.fn.tabpagenr('$') and '%#TabLine#|' or '')
end

M.cell = function(index)
    local isSelected = vim.fn.tabpagenr() == index
    local buflist = vim.fn.tabpagebuflist(index)
    local winnr = vim.fn.tabpagewinnr(index)
    local bufnr = buflist[winnr]
    local current_label = M.tab_labels[index]
    local hl = (isSelected and '%#TabLineSel#' or '%#TabLine#')

    return hl .. '%' .. index .. 'T' .. ' ' ..
        M.windowCount(index) ..
        M.title(bufnr, current_label) .. ' ' ..
        M.modified(bufnr) ..
        M.devicon(bufnr, isSelected, current_label) .. '%T' ..
        M.separator(index)
end

M.tabline = function()
    local line = ''
    for i = 1, vim.fn.tabpagenr('$'), 1 do
        line = line .. M.cell(i)
    end
    line = line .. '%#TabLineFill#%='
    if vim.fn.tabpagenr('$') > 1 then
        line = line .. '%#TabLine#%999XX'
    end
    return line
end


M.rename_tab = function()
    local new_label = vim.fn.input('New tab name: ')
    M.tab_labels[vim.fn.tabpagenr()] = new_label
end

local setup = function(opts)
    opts = opts or {}
    if opts.title then M.title = opts.title end
    if opts.modified then M.modified = opts.modified end
    if opts.windowCount then M.windowCount = opts.windowCount end
    if opts.devicon then M.devicon = opts.devicon end
    if opts.separator then M.separator = opts.separator end
    if opts.cell then M.cell = opts.cell end
    if opts.tabline then M.tabline = opts.tabline end

    vim.opt.tabline = '%!v:lua.require\'luatab\'.helpers.tabline()'
end

local warning = function()
    error [[
Hi, I've updated luatab.nvim to allow some proper configuration. As a result, I need to make a breaking change to the config. Apologies for the inconvinence.
If you had:
    vim.o.tabline = '%!v:lua.require\'luatab\'.tabline()'
please replace it with
    require('luatab').setup({})
]]
end

-- When you enter a new tab
vim.api.nvim_create_autocmd('TabNew', {
    callback = function()
      local tabs_labels = require('luatab').helpers.tab_labels
      table.insert(tabs_labels, 'default')
    end
})

-- When you leave a tab
vim.api.nvim_create_autocmd('TabClosed', {
    callback = function()
      local tabs_labels = require('luatab').helpers.tab_labels
      local removed_index = vim.fn.expand('<afile>')
      table.remove(tabs_labels, removed_index)
    end
})

vim.api.nvim_create_user_command('LuatabLabelRename', 'lua require(\'luatab\').helpers.rename_tab()', {})


return {
    helpers = M,
    setup = setup,
    tabline = warning,
}
