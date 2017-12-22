set nocompatible
filetype plugin on

" configure solarized colour scheme
set background=dark
colorscheme solarized

" enable line numbers
set number

" automatically reflect changes on disk
set autoread

" enable local configuration files
set exrc
set secure

" default project options
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" highlight 110th column
set colorcolumn=110
highlight ColorColumn ctermbg=darkgrey

" ensure .c and .h files are pure c - not c++
augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END

" enable mouse support
set mouse=a

" map F10 to show syntax highlight group (helpful for debugging)
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" ************************* PLUGIN CONFIGS *******************************
" get NERDTree to startup automatically and on the left
let g:NERDTreeWinPos = "left"
autocmd vimenter * NERDTree
autocmd vimenter * wincmd p

" get vim to close if NERDTree is the only remaining window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" enable NERDTree mouse support
let g:NERDTreeMouseMode=2
let g:NERDTreeShowHidden=1

" give lightline the correct colour scheme
if !has('gui_running')
  set t_Co=256
endif

let g:lightline = {
            \ 'colorscheme': 'solarized',
            \ 'active': {
            \   'left':  [ [ 'mode', 'paste' ],
            \              [ 'fugitive', 'readonly', 'filename', 'modified' ] ],
            \   'right': [ [ 'lineinfo' ],
            \              [ 'percent' ],
            \              [ 'syntastic', 'fileformat', 'fileencoding', 'filetype' ] ]
            \ },
            \'component': {
            \   'syntastic': '%#warningmsg#%{SyntasticStatuslineFlag()}%*'
            \ },
            \'component_function': {
            \   'fugitive': 'fugitive#statusline',
            \   'filetype': 'MyFiletype',
            \   'fileformat': 'MyFileformat',
            \ },
            \ }
set noshowmode

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

" configure syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1

" configure vim_behat
let g:feature_filetype='behat'

" configure markdown
let g:markdown_fenced_languages = ['php','c','sh']
augroup markdown
    autocmd!
    autocmd BufNewFile,BufRead *.md,*.markdown,*.md setlocal filetype=markdown
augroup END

" configure pencil
let g:pencil#wrapModeDefault = 'hard'
let g:pencil#autoformat = 1
augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  autocmd FileType text         call pencil#init()
augroup END

augroup lexical
  autocmd!
  autocmd FileType markdown,mkd call lexical#init()
  autocmd FileType textile call lexical#init()
  autocmd FileType text call lexical#init({ 'spell': 0 })
augroup END

" configure localvimrc

let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0
