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

" open quickfix window on make
augroup QuickFixCmdPostOpenWindow
    autocmd QuickFixCmdPost [^l]* nested bel cwindow
    autocmd QuickFixCmdPost    l* nested bel lwindow
augroup END

" enable mouse support
set mouse=a

" make clipboard work
set clipboard=unnamed

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
" if no in vimdiff mode get NERDTree to startup automatically and on the left
if !&diff
    let g:NERDTreeWinPos = "left"
    map <leader>r :NERDTreeFind<cr>
endif

" calls NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
function! s:syncTree()
  let s:curwnum = winnr()
  NERDTreeFind
  exec s:curwnum . "wincmd w"
endfunction

function! s:syncTreeIf()
  if (winnr("$") > 1)
    call s:syncTree()
  endif
endfunction
  
" Shows NERDTree on start and synchronizes the tree with opened file when switching between opened windows
autocmd BufEnter * call s:syncTreeIf()
augroup NERDTree
    autocmd!
    " Shows NERDTree on start and synchronizes the tree with opened file when switching between opened windows
    autocmd BufEnter * call s:syncTreeIf()
    " Focus on opened view after starting (instead of NERDTree)
    autocmd VimEnter * call s:syncTree()
    autocmd VimEnter * :wincmd w
    " Auto refresh NERDTree files
    autocmd CursorHold,CursorHoldI * if (winnr("$") > 1) | call NERDTreeFocus() | call g:NERDTree.ForCurrentTab().getRoot().refresh() | call g:NERDTree.ForCurrentTab().render() | wincmd w | endif

    " get vim to close if NERDTree is the only remaining window
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

" Enable Tagbar by default
if !&diff
    augroup tagbar
        autocmd!
        autocmd vimenter * TagbarToggle
    augroup END
endif

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

" Use deoplete.
let g:deoplete#enable_at_startup = 1

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
let g:mkdp_markdown_css = '/Users/richard.vodden/Documents/Source/github-markdown-css/github-markdown.css'
augroup markdown
    autocmd!
    autocmd BufNewFile,BufRead *.md,*.markdown,*.md setlocal filetype=markdown
    autocmd Filetype markdown normal zR
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
