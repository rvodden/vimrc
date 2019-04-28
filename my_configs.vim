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

" configure jenkinsfile to use groovy highlighing
augroup Jenkins
    autocmd!
    au BufNewFile,BufRead Jenkinsfile setf groovy
augroup END

" indent xml using xmllint
augroup XML
    autocmd!
    autocmd FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
augroup END

" add yaml stuffs
let g:syntastic_yaml_checkers = ['yamllint']
augroup YAML
    autocmd! 
    autocmd BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
    autocmd FileType yaml setlocal expandtab
augroup END

" open quickfix window on make
augroup QuickFixCmdPostOpenWindow
    autocmd QuickFixCmdPost [^l]* nested bel cwindow
    autocmd QuickFixCmdPost    l* nested bel lwindow
augroup END

" enable mouse support
set mouse=a

" ************************* OS SPECIFICS *********************************
" detect the operating system
if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

" ************************* PLUGIN CONFIGS *******************************
" get NERDTree to startup automatically and on the left
let g:NERDTreeWinPos = "left"
augroup NERDTree
    autocmd!
    autocmd vimenter * NERDTree
    autocmd vimenter * wincmd p
    " get vim to close if NERDTree is the only remaining window
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

if (g:os == "Darwin")
" Use the pbcopy and pbpaste command line utilities to work around the lack of clipboard support
    nmap <leader>p :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
    imap <leader>p <Esc>:set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
    nmap <leader>y :.w !pbcopy<CR><CR>
    vnoremap <silent> <leader>y :<CR>:let @a=@" \| execute "normal! vgvy" \| let res=system("pbcopy", @") \| let @"=@a<CR>
end

" Enable Tagbar by default
augroup tagbar
    autocmd!
    autocmd vimenter * TagbarToggle
augroup END

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
            \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
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
