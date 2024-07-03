# luatab.nvim

<p align="center">
  <img src="https://github.com/alvarosevilla95/luatab.nvim/blob/master/pics/tabline.png" />
</p>

## Features
* Just a lua rewrite of the tabline render function
* No weird mixing buffers and tabs stuff

## Install
Using packer.nvim:
```lua
use { 'alvarosevilla95/luatab.nvim', requires='nvim-tree/nvim-web-devicons' }
```

Using [`lazy.nvim`](https://github.com/folke/lazy.nvim)
```lua
{ 'alvarosevilla95/luatab.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } }
```

## Usage
Add this to your init.lua:
```lua
require('luatab').setup{}
```

Rename the current tab using:
```
:LuatabLabelRename
```

## Configuration

The plugin calls the `helpers.tabline` function to render the line. It uses the other functions defined in `helpers`, such as `cell,separator,devicon`.
You can pass overrides for any of these functions in `setup`. Please see `lua/luatab/init.lua` for details.

Example:
```
require('luatab').setup{
    title = function() return '' end,
    modified = function() return '' end,
    windowCount = function() return '' end,
    devicon = function() return '' end,
    separator = function() return '' end,
}
```
