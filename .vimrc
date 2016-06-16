set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree.git'
Plugin 'ctrlp.vim'
Bundle 'rking/ag.vim'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'FSwitch'

" last plugin
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set number
set hlsearch
syntax on
filetype on
filetype plugin indent on
set showmatch
set backspace=indent,eol,start
set autoindent
set ignorecase
set smartcase
set autochdir
colorscheme darkblue 
set clipboard=unnamedplus
set hidden
set autowrite
" Cycle through buffers
"nnoremap <C-n> :bnext<CR>
"nnoremap <C-p> :bprevious<CR>


" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" Doxygen related
let g:DoxygenToolkit_licenseTag="Copyright 2013 Formation Data Systems, Inc."

" youcompleteme specific
let g:ycm_autoclose_preview_window_after_completion=1
autocmd Filetype c,cpp nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
autocmd Filetype python nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
" so you ultisnip uses tab key (http://www.alexeyshmalko.com/2014/youcompleteme-ultimate-autocomplete-plugin-for-vim/)
"let g:ycm_key_list_select_completion=[]
"let g:ycm_key_list_previous_completion=[]

" Ultisnips
let g:UltiSnipsSnippetsDir="~/.vim/bundle/vim-snippets/UltiSnips"
let g:UltiSnipsExpandTrigger="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" NERDTree
nmap <leader>n :NERDTreeToggle<CR>
let NERDTreeHighlightCursorline=1
let NERDTreeIgnore = ['tmp', '.yardoc', 'pkg']


" Switch between header and source file for .c, .cpp, .h
" <leader>+f switches between source and header
function! CscopeToggleSrcHeader()
	let l:name = expand('%:r')
	let l:ext = expand('%:e')
	" echo 'extension: '.l:ext
	if l:ext != 'cpp' && l:ext != 'c' && l:ext != 'h'
		" echo 'invalid file'
		return
	endif
	if l:ext == 'cpp' || l:ext == 'c'
		let l:cmd = 'cscope find f '.l:name.'.h'
	else
		let l:cmd = 'cscope find f '.l:name.'.cpp'
	endif
	exec l:cmd
endfunction
nmap <silent> <leader>f :call CscopeToggleSrcHeader()<CR>
" F as command shortcut for cs f f
command -nargs=* F cs f f <args>
" R as command shortcut for cs f f
command -nargs=* R args `ag -l <args>`

" Conqueterm related
let g:ConqueTerm_CWInsert = 1
let g:ConqueTerm_InsertOnEnter = 1
command Bash ConqueTerm bash
command Vbash ConqueTermVSplit bash
