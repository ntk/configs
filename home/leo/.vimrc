" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
fixdel " hopefully fixes the backspace problem

set wildmenu "turn on wildmenu..

filetype on
autocmd FileType makefile :set noexpandtab
set expandtab           " use spaces except for tabs
set ts=2                " set tabstop to N spaces
set shiftwidth=2        " set how many tabs should be done by one keypress

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern
" and sets the colorscheme.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  colorscheme peachpuff
endif

" Spellcheck highlight, config, enable, language
"let loaded_vimspell = 1 
highlight SpellErrors ctermfg=Red guifg=Red
  \ cterm=underline gui=underline term=reverse
let spell_executable = "aspell"
let spell_language_list = "de,en"
let spell_update_time = 2000
let spell_guess_language_ft = "tex,mail,text,html"
let spell_insert_mode = 1
let spell_auto_jump = 1
"SpellAutoEnable


" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Close_On_Select = 1

noremap <leader>hex :%!xxd<CR>
noremap <leader>nhex :%!xxd -r<CR>
noremap Y :redo<CR>
noremap f :NERDTreeToggle<CR>
noremap F :NERDTreeClose<CR>
noremap T :TlistToggle<CR>
" Map ctrl-movement keys to window switching
noremap <C-k> <C-w><Up>
noremap <C-j> <C-w><Down>
noremap <C-l> <C-w><Right>
noremap <C-h> <C-w><Left>
nnoremap <Tab> <C-w>W

inoremap <tab> <c-r>=InsertTabWrapper ("forward")<CR>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<CR>


function! InsertTabWrapper(direction)
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  elseif "backward" == a:direction
    return "\<c-p>"
  else
    return "\<c-n>"
  endif
endfunction

