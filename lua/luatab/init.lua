local M = {}

M.title = function(bufnr)
    local file = vim.fn.bufname(bufnr)
    local buftype = vim.fn.getbufvar(bufnr, '&buftype')
    local filetype = vim.fn.getbufvar(bufnr, '&filetype')

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
    local nwins = 0
    local success, wins = pcall(vim.api.nvim_tabpage_list_wins, index)
    if success then
        for _ in pairs(wins) do nwins = nwins + 1 end
    end
    return nwins > 1 and '(' .. nwins .. ') ' or ''
end

M.devicon = function(bufnr, isSelected)
    local icon, devhl
    local file = vim.fn.bufname(bufnr)
    local buftype = vim.fn.getbufvar(bufnr, '&buftype')
    local filetype = vim.fn.getbufvar(bufnr, '&filetype')
    local devicons = require'nvim-web-devicons'
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
    local hl = (isSelected and '%#TabLineSel#' or '%#TabLine#')

    return hl .. '%' .. index .. 'T' .. ' ' ..
        M.windowCount(index) ..
        M.title(bufnr) .. ' ' ..
        M.modified(bufnr) ..
        M.devicon(bufnr, isSelected) .. '%T' ..
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

local setup = function(opts)
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

return {
    helpers = M,
    setup = setup,
    tabline = warning,
}
