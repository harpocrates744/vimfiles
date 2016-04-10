runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()
syntax on
filetype plugin indent on

" reload automatically vimrc when saved
autocmd! bufwritepost _vimrc source %

" *** GLOBAL OPTIONS ***  {{{1
set nocompatible
set noshowmode visualbell cursorline relativenumber
set autoindent smarttab
set backspace=indent,eol,start
set incsearch hlsearch ignorecase smartcase wrapscan
set noswapfile nobackup nowb        "Turn Off Swap Files
set nowrap

set laststatus=2
set ruler
set wildmenu
set lazyredraw
set scrolloff=1
set sidescrolloff=5
set display+=lastline

set autoread                        "rereads a file when exterior change detected
set formatoptions+=j " Delete comment character when joining commented lines
set history=1000
set tabpagemax=50
set foldmethod=marker
"set list listchars=tab:>-,trail:· " Display tabs and trailing spaces visually

" *** GUI OPTIONS ***  {{{1
if has('gui_running')
    set lines=42 columns=110
    if &encoding ==# 'latin1'
      set encoding=utf-8
    endif

    "let g:solarized_contrast="high"
    "colorscheme solarized
    "color wombat256mod
    color gruvbox

    set guifont=Powerline_Consolas:h11:cANSI
    set guioptions-=m       "remove the menu bar
    set guioptions-=r       "remove the right scroll bar
    set guioptions-=L       "remove the left scroll bar
    set guioptions-=T       "remove the toolbar
endif

" *** KEY MAPPINGS ***  {{{1
inoremap jj <Esc>
vnoremap <BS> <Esc>
nnoremap Q <nop>
nnoremap <F1> :tab help<Space>
nnoremap <BS> :q!<CR>

" disable arrow keys
no <down> <Nop>
no <up> <Nop>
no <left> <Nop>
no <right> <Nop>

ino <down> <Nop>
ino <up> <Nop>
ino <left> <Nop>
ino <right> <Nop>

" Edit my vimrc
noremap <leader>v :tabe $MYVIMRC<CR>

" Easymotion
nmap <Space>j <Plug>(easymotion-j)
nmap <Space>k <Plug>(easymotion-k)
nmap <Space>w <Plug>(easymotion-w)
nmap <Space>W <Plug>(easymotion-W)
nmap <Space>b <Plug>(easymotion-b)
nmap <Space>B <Plug>(easymotion-B)

" Use <C-L> to clear the highlighting of :set hlsearch.
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

"trailing white space
nnoremap <leader>sws :match ErrorMsg '\s\+$'<CR>
nnoremap <Leader>rws :%s/\s\+$//e<CR>

" NERDTree
nmap <silent> <C-F2> :NERDTreeToggle<CR>
nmap <silent> cot :NERDTreeToggle<CR>
nmap <silent> <F2> :NERDTreeFind<CR>

" Toggle GUI menu
nmap [m :set go-=m<CR>
nmap ]m :set go+=m<CR>

" VimShell mappings
nmap <F10> :<C-U>tab<CR> :VimShell<CR>

" GUndo
let g:gundo_prefer_python3=1
nnoremap <F5> :GundoToggle<CR>

" Unite config  {{{2
"noremap <F3> :Unite -start-insert file file_rec/async buffer file_mru<CR>
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <Leader>ff :Unite file<CR>
nnoremap <Leader>fu :Unite file_mru<CR>
nnoremap <Leader>fr :Unite -start-insert file_rec/async<CR>
nnoremap <Leader>fb :Unite -quick-match buffer<CR>
nnoremap <Leader>ft :Unite -quick-match tab<CR>
nnoremap <Leader>fg :Unite -quick-match register<CR>
let g:unite_source_history_yank_enable = 1
nnoremap <Leader>fy :Unite -quick-match history/yank<cr>
nnoremap <Leader>fs :Unite source<CR>

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  " Overwrite settings.

  imap <buffer> jj      <Plug>(unite_insert_leave)
  imap <buffer><expr> j unite#smart_map('j', '')
  imap <buffer> <TAB>   <Plug>(unite_select_next_line)
  imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
  imap <buffer> '     <Plug>(unite_quick_match_default_action)
  nmap <buffer> '     <Plug>(unite_quick_match_default_action)
  imap <buffer><expr> x
          \ unite#smart_map('x', "\<Plug>(unite_quick_match_jump)")
  nmap <buffer> x     <Plug>(unite_quick_match_jump)
  nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
  nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  nnoremap <silent><buffer><expr> l
          \ unite#smart_map('l', unite#do_action('default'))

  let unite = unite#get_current_unite()
  if unite.profile_name ==# 'search'
    nnoremap <silent><buffer><expr> r     unite#do_action('replace')
  else
    nnoremap <silent><buffer><expr> r     unite#do_action('rename')
  endif

  nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
  nnoremap <buffer><expr> S      unite#mappings#set_current_sorters(
          \ empty(unite#mappings#get_current_sorters()) ?
          \ ['sorter_reverse'] : [])

  " Runs "split" action by <C-s>.
  imap <silent><buffer><expr> <C-s>     unite#do_action('split')
endfunction

" add blank line above/below cursor with [<Space> / ]<Space>  {{{2
function! s:BlankUp(count) abort
  put!=repeat(nr2char(10), a:count)
  ']+1
  silent! call repeat#set("\<Plug>unimpairedBlankUp", a:count)
endfunction

function! s:BlankDown(count) abort
  put =repeat(nr2char(10), a:count)
  '[-1
  silent! call repeat#set("\<Plug>unimpairedBlankDown", a:count)
endfunction

nnoremap <silent> <Plug>unimpairedBlankUp   :<C-U>call <SID>BlankUp(v:count1)<CR>
nnoremap <silent> <Plug>unimpairedBlankDown :<C-U>call <SID>BlankDown(v:count1)<CR>

nmap [<Space> <Plug>unimpairedBlankUp
nmap ]<Space> <Plug>unimpairedBlankDown

"*** FILETYPE OVERRIDES ***  {{{1
augroup my_group
    au!
    au FileType python setl sw=4 sts=4 et
    au FileType kivy setl sw=4 sts=4 et
    au FileType vim setl sw=4 sts=4 et
    au FileType javascript setl sw=4 sts=4 et
    au FileType rst setl sw=3 sts=3 et
augroup END
