" Basic stuff
set nocompatible
syntax on
set termguicolors

" Toggle display of line numbers
function! ToggleLineNumbers()
    set number!
    set relativenumber!
endfunction
nnoremap ,l :call ToggleLineNumbers() <cr>


" Set colorscheme for git commit editing :
autocmd BufRead COMMIT_EDITMSG colorscheme erelde

" Default indentation
set smartindent
set autoindent

" Smart search
set ignorecase
set smartcase

" Swap files
set directory=/tmp

" Limit to 80 columns
set textwidth=79
" Spaces are the way
set shiftwidth=4
set tabstop=4
set expandtab
set softtabstop=4
set shiftround
set autoindent
set smartindent
set nocindent

" Trim trailing whitespace
autocmd BufWritePre * %s/\s\+$//e
augroup vimrcEx
    " Clear all autocmds in the group
    autocmd!

    " for javascript, autoindent with two spaces, always expand tabs
    autocmd FileType javascript,ruby,haml,eruby,yaml,html,sass,cucumber, set ai sw=2 sts=2 et
    " for python, autoindent with four spaces, always expand tabs
    autocmd FileType python,c,cpp,h,php set ai sw=4 sts=4 et

    autocmd! BufRead,BufNewFile *.sass setfiletype sass

    " Don't syntax highlight markdown because it's often wrong
    autocmd! FileType mkd setlocal syn=off
    autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
    autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;
    " *.md is markdown
    autocmd! BufNewFile,BufRead *.md setlocal ft=

    " Leave the return key alone when in command line windows, since it's used
    " to run commands there.
    autocmd! CmdwinEnter * :unmap <cr>
    autocmd! CmdwinLeave * :call MapCR()
augroup END

" RemoveFancyCharacters COMMAND
" Remove smart quotes, etc.
function! RemoveFancyCharacters()
    let typo = {}
    let typo["“"] = '"'
    let typo["”"] = '"'
    let typo["‘"] = "'"
    let typo["’"] = "'"
    let typo["–"] = '--'
    let typo["—"] = '---'
    let typo["…"] = '...'
    :exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction
command! RemoveFancyCharacters :call RemoveFancyCharacters()

" When pair programming
" Insert a remark about that in the commit message
" The list will only be composed of previous committer to the current repo
function! CommitCoAuthoredBy()
    read !echo "Co-authored-by: $(git authors | fzy)"
endfunction
command! CommitCoAuthoredBy :call CommitCoAuthoredBy()