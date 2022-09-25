set completeopt=menu,menuone,noselect
set mouse=nv
set rnu
set nu
set ruler
set nohlsearch
set cursorline
set tabstop=2
set shiftwidth=2
set expandtab
syntax enable
filetype plugin indent on
let g:rustfmt_autosave = 1

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fd <cmd>Telescope live_grep<cr>
