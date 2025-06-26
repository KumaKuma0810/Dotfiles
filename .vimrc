" --- Менеджер плагинов: vim-plug ---
call plug#begin('~/.vim/plugged')

" Подсветка синтаксиса Python (без сторонних зависимостей)
Plug 'vim-python/python-syntax'

" Статус-бар и темы
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Файловый менеджер
Plug 'preservim/nerdtree'

" Сниппеты и автодополнение
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Терминал
Plug 'voldikss/vim-floaterm'

" (Рекомендация) Удобная работа с окружением (например, кавычки, скобки)
Plug 'tpope/vim-surround'

call plug#end()

" --- Основные настройки ---
set nocompatible
syntax enable
filetype plugin indent on

set number                    " Показывать номера строк
" set relativenumber           " Относительная нумерация строк (раскомментируй, если нужно)
set tabstop=4                 " 4 пробела за таб
set shiftwidth=4              " 4 пробела для автосдвига
set expandtab                 " Пробелы вместо табов
set autoindent                " Автоотступ
set smartindent               " Умный автоотступ
set cursorline                " Подсветка строки курсора
set clipboard=unnamedplus     " Система буфера обмена
set mouse=a                   " Поддержка мыши
set background=dark

" --- Автосохранение ---
autocmd InsertLeave *.py silent! write

" --- NERDTree ---
" Тоггл по Ctrl+b (открыть/закрыть), а не только Find
nnoremap <C-b> :NERDTreeFind<CR>
" Открывать NERDTree при запуске без аргументов
autocmd VimEnter * if argc() == 0 | NERDTree | endif
" Автоматически закрывать NERDTree, если он остался единственным окном
" autocmd BufEnter * if winnr('$') == 1 && &filetype ==# 'nerdtree' | quit | endif

" --- Python-специфические настройки ---
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab

" --- Airline: минимальная настройка ---
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 0
let g:airline_theme='behelit'
let g:airline#extensions#tabline#formatter = 'unique_tail'

" --- Сниппеты и автодополнение ---
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'

" Tab для coc.nvim + UltiSnips (чтобы tab работал и на сниппеты, и на автодополнение)
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : UltiSnips#CanExpandSnippet() ? "<C-R>=UltiSnips#ExpandSnippet()<CR>" : "\<Tab>"

" --- Терминал ---
" Для normal mode (открытие/закрытие)
nnoremap <silent> <C-`> :FloatermToggle<CR>
" Для terminal mode (закрытие изнутри)
tnoremap <silent> <C-`> <C-\><C-n>:FloatermToggle<CR>
let g:floaterm_height=0.2
let g:floaterm_position='bottom'
let g:floaterm_wintype = 'split'         " Ключевая настройка!


" --- Буферы ---
nnoremap <S-Tab> :bprevious<CR>

" --- (Опционально) Цветовая схема ---
" colorscheme desert
