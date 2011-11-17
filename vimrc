"avoiding annoying CSApprox warning message
let g:CSApprox_verbose_level = 0

"activate pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

"allow backspacing over everything in insert mode
set backspace=indent,eol,start

"store lots of :cmdline history
set history=1000

set showcmd     "show incomplete cmds down the bottom
set showmode    "show current mode down the bottom

set number      "show line numbers

"display tabs and trailing spaces
set list
set listchars=tab:▸\ ,eol:¬
if has("gui_running")
	colorscheme molokai
else
	colorscheme desert
endif

set incsearch   "find the next match as we type the search
set hlsearch    "hilight searches by default

set wrap        "dont wrap lines
set linebreak   "wrap lines at convenient points

if v:version >= 703
  "undo settings
  set undodir=~/.vim/undofiles
  set undofile

  set colorcolumn=+1 "mark the ideal max text width
endif


"default indent settings
set nowrap
set expandtab
set shiftwidth=2
"set tabstop=2
set softtabstop=2
set autoindent

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmode=list:longest,list:full   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~, "stuff to ignore when tab completing

set formatoptions-=o "dont continue comments when pushing o/O

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1
"load ftplugins and indent files
filetype plugin on
filetype indent on

"turn on syntax highlighting
syntax on

"some stuff to get the mouse going in term
"set mouse=a
"set ttymouse=xterm2

"tell the term has 256 colors
set t_Co=256

"hide buffers when not displayed
set hidden

"statusline setup
set statusline=%f       "tail of the filename

"Git
"set statusline+=[%{GitBranch()}]
"display a warning if file encoding isnt utf-8
set fenc=utf-8
"display a warning if &et is wrong, or we have mixed-indenting

set statusline+=%{StatuslineLongLineWarning()}

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

""return '[&et]' if &et is set wrong
""return '[mixed-indenting]' if spaces and tabs are used to indent
""return an empty string if everything is fine
function! StatuslineTabWarning()
  if !exists("b:statusline_tab_warning")
    let b:statusline_tab_warning = ''

    if !&modifiable
      return b:statusline_tab_warning
    endif

    let tabs = search('^\t', 'nw') != 0

    "find spaces that arent used as alignment in the first indent column
    let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

    if tabs && spaces
      let b:statusline_tab_warning =  '[mixed-indenting]'
    elseif (spaces && !&et) || (tabs && &et)
      let b:statusline_tab_warning = '[&et]'
    endif
  endif
  return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)

"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
	if !exists("b:statusline_long_line_warning")

		if !&modifiable
			let b:statusline_long_line_warning = ''
			return b:statusline_long_line_warning
		endif

		let long_line_lens = s:LongLines()

		if len(long_line_lens) > 0
			let b:statusline_long_line_warning = "[" .
						\ '#' . len(long_line_lens) . "," .
						\ '$' . max(long_line_lens) . "]"
		else
			let b:statusline_long_line_warning = ""
		endif
	endif
	return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
	let threshold = (&tw ? &tw : 80)
	let spaces = repeat(" ", &ts)

	let long_line_lens = []

	let i = 1
	while i <= line("$")
		let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
		if len > threshold
			call add(long_line_lens, len)
		endif
		let i += 1
	endwhile

	return long_line_lens
endfunction

"find the median of the given array of numbers
"function! s:Median(nums)
	"let nums = sort(a:nums)
	"let l = len(nums)

	"if l % 2 == 1
		"let i = (l-1) / 2
		"return nums[i]
	"else
		"return (nums[l/2] + nums[(l/2)-1]) / 2
	"endif
"endfunction

"syntastic settings
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=2

"snipmate settings
let g:snips_author = "Joel He"

"taglist settings
let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
let Tlist_Compact_Format = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Exit_OnlyWindow = 0
let Tlist_WinWidth = 35
let tlist_php_settings = 'php;c:class;f:Functions'
let Tlist_Use_Right_Window=1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Display_Tag_Scope = 1
let Tlist_Process_File_Always = 1
let Tlist_Show_One_File = 1

"nerdtree settings
let g:NERDTreeMouseMode = 2
let g:NERDTreeWinSize = 25

"explorer mappings
nnoremap <Leader>1 :BufExplorer<cr>
nnoremap <Leader>2 :NERDTreeToggle<cr>
nnoremap <Leader>3 :TlistToggle<cr>
nnoremap <Leader>4 :GundoToggle<CR>

imap jj <ESC>
cmap <c-a>	  <home>
cmap <c-e>	  <end>
cnoremap <c-b>	<left>
cnoremap <c-d>	<del>
cnoremap <c-f>	<right>
cnoremap <c-n>	<down>
cnoremap <c-p>	<up>


"source project specific config files
runtime! projects/**/*.vim

"dont load csapprox if we no gui support - silences an annoying warning
if !has("gui")
  let g:CSApprox_loaded = 1
endif

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

"map Q to something useful
noremap Q gq

"make Y consistent with C and D
nnoremap Y y$

"visual search mappings
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>


"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if &filetype !~ 'svn\|commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction

"spell check when writing commit logs
autocmd filetype svn,*commit* set spell

"set autochdir on
"set autochdir


"vim templates setting
autocmd BufNewFile * silent! 0r ~/.vim/templates/%:e.tpl
"keybind for templates files edit
nnoremap <c-j> /<+.\{-1,}+><cr>c/+>/e<cr>
inoremap <c-j> <ESC>/<+.\{-1,}+><cr>c/+>/e<cr>

"snipmate_for_django
"autocmd FileType python set ft=python.django " For SnipMate
"autocmd FileType html set ft=htmldjango.html " For SnipMate

"Removing the toolbar in Macvim
if has("gui_running")
  set guioptions=egmt
endif

" toggle full screen on macvim
if has("gui_macvim")
  set fuoptions=maxvert,maxhorz
endif

"Command-T configuration
let g:CommandTMaxHeight=20

"NERDcomment setting
let NERDDefaultNesting = 0
"open and close Vim without losing the setting,list of open files
" autocmd VimEnter * call LoadSession()
" autocmd VimLeave * call SaveSession()
" function! SaveSession()
"   execute 'mksession! $HOME/.vim/sessions/session.vim'
" endfunction

" function! LoadSession()
"   if argc() == 0
"     execute 'source $HOME/.vim/sessions/session.vim'
"   endif
" endfunction
set guifont=Monaco:h12
set tw=120

"configuration for autocomplpop
let g:acp_behaviorSnipmateLength = 1

"insert current time
"disable those filetype syntax check
let g:syntastic_disabled_filetypes = ['html']
" Tabular
if exists(":Tabularize")
	nmap <Leader>a> :Tabularize /=><CR>
	vmap <Leader>a> :Tabularize /=><CR>
	nmap <Leader>a= :Tabularize /=<CR>
	vmap <Leader>a= :Tabularize /=<CR>
	nmap <Leader>a: :Tabularize /:\zs<CR>
	vmap <Leader>a: :Tabularize /:\zs<CR>
endif

"filetype
if has("autocmd")
	au BufRead,BufNewFile *.go set filetype=go
	autocmd BufNewFile,BufRead *.slim setf slim
	autocmd FileType slim setlocal ts=2 sts=2 sw=2 expandtab

	autocmd FileType css setlocal ts=4 sts=4 sw=4 expandtab
	autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
endif

"Avoid trailing whitespace.
autocmd BufWritePre * :%s/\s\+$//e

"highlight current line and column
"set cursorline
"set cursorcolumn
" vim:noet:sw=4:ts=4:ft=vim
