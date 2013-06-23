"============================================================================
" General settings
"----------------------------------------------------------------------------
    set nocompatible        " nocp:  turn off vi compatibility
    set undolevels=1000     " ul:  lots and lots of undo
    set history=50          " hi:  size of :command history
    set modelines=20
    set modeline            " ml:  Turn on modelines
    set ruler               " show the cursor position all the time
    set showcmd             " Show command
    set autochdir           "Automatically cd into the directory that the file is in
    set number              " Turn line number on
    set showmatch

"""""""""""""""""""""""""""""
" Folding
"""""""""""""""""""""""""""""
au BufWinLeave *.* mkview
au BufWinEnter *.* silent loadview
"set foldmethod=marker
set foldmethod=indent
"set foldmethod=syntax
"set foldmethod=diff
"set foldmethod=manual

"""""""""""""""""""""""""""""
" Menu
"""""""""""""""""""""""""""""
set wildmenu
set wildmode=list:longest,full

"""""""""""""""""""""""""""""
" Syntax highlight
"""""""""""""""""""""""""""""
filetype on
filetype plugin on
syntax on

"""""""""""""""""""""""""""""
" Highlighting current line "
"""""""""""""""""""""""""""""
set cul                                           " highlight current line
hi CursorLine term=none cterm=none ctermbg=3      " adjust color

""""""""""""""""""""""""
" Backup configuration "
""""""""""""""""""""""""
set backup " enable backup files
set backupdir=c:/vim/backup " where to put backup files
set directory=c:/vim/temp " directory for temp files


"============================================================================
" Statusline, Ruler
"----------------------------------------------------------------------------
set laststatus=2        " ls:  always put a status line
set statusline=%([%-n]%y\ %f%M%R%)\ %{CurrSubName()}\ %=\ %(%l,%c%V\ %P\ [0x%02.2B]%)
set maxfuncdepth=1000   " Need more depth for sub names

" Make backspace delete lots of things
set backspace=indent,eol,start

"============================================================================
" Search and Replace
"----------------------------------------------------------------------------
set incsearch           " is:  show partial matches as search is entered
set hlsearch            " hls:  highlight search patterns
set ignorecase          " Ignore case distinction when searching
set smartcase           " ... unless there are capitals in the search string.
set nowrapscan          " Don't wrap to top of buffer when searching

"============================================================================
" Tab standards
"----------------------------------------------------------------------------
set softtabstop=4
set shiftwidth=4
set shiftround " Shift to the next round tab stop
set expandtab
set autoindent
set smartindent
set cindent

"============================================================================
" Colors
"----------------------------------------------------------------------------
set t_Sf=[3%dm        " set foreground (?)
set t_Sb=[4%dm        " set background (?)


source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()

"============================================================================
" Functions
"----------------------------------------------------------------------------
function! TextMode()             " Stolen from David Hand
    set nocindent               " nocin:  don't use C-indenting
    set nosmartindent           " nosi:  don't "smart" indent, either
    set autoindent              " ai:  indent to match previous line
    set noshowmatch             " nosm:  don't show matches on parens, brackets, etc.
    set comments=n:>,n:#,fn:-   " com: list of things to be treated as comments
    set textwidth=72            " tw:  wrap at 72 characters
    set formatoptions=tcrq      " fo:  word wrap, format comments
    set dictionary+=/usr/local/dict/*  " dict:  dict for word completion
    set complete=.,w,b,u,t,i,k  " cpt:  complete words
endfunction

function! PerlMode()             " Stolen from David Hand
    set shiftwidth=4            " sw:  a healthy tab stop
    set textwidth=72            " tw:  wrap at 72 characters
    set autoindent              " ai:  indent to match previous line
    set cindent                 " cin:  Use C-indenting
    set cinkeys=0{,0},!^F,o,O,e " cink:  Perl-friendly reindent keys
    set cinoptions=t0,+4,(0,)60,u0,*100  " cino:  all sorts of options
    set cinwords=if,else,while,do,for,elsif,sub
    set comments=n:#            " com:  Perlish comments
    set formatoptions=crql      " fo:  word wrap, format comments
    set nosmartindent           " nosi:  Smart indent useless when C-indent is on
    set showmatch               " show matches on parens, bracketc, etc.
endfunction

" From http://www.perlmonks.org/?node_id=540411
function! CurrSubName()
    let g:subname = ""
    let g:subrecurssion = 0

    " See if this is a Perl file
    let l:firstline = getline(1)

    if ( l:firstline =~ '#!.*perl' || l:firstline =~ '^package ' )
        call GetSubName(line("."))
    endif

    return g:subname
endfunction

function! GetSubName(line)
    let l:str = getline(a:line)

    if l:str =~ '^sub'
        let l:str = substitute( l:str, " *{.*", "", "" )
        let l:str = substitute( l:str, "sub *", ": ", "" )
        let g:subname = l:str
        return 1
    elseif ( l:str =~ '^}' || l:str =~ '^} *#' ) && g:subrecurssion == 1
        return -1
    elseif a:line > 2
        let g:subrecurssion = g:subrecurssion + 1
        if g:subrecurssion < 190
            call GetSubName(a:line - 1)
        else
            let g:subname = ': <too deep>'
            return -1
        endif
    else
        return -1
    endif
endfunction

function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunctio
