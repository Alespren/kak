require-module wayland
set-option global termcmd "ghostty -e fish -c"

colorscheme gruvbox-dark

source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyorst/plug.kak" noload

plug "gustavo-hms/luar"
plug "gustavo-hms/peneira"

plug "alexherbo2/auto-pairs.kak"
plug "h-youhei/kakoune-surround"

plug "occivink/kakoune-filetree"

plug "https://bitbucket.org/KJ_Duncan/kakoune-racket.kak"

require-module luar
require-module peneira

map global user f ':peneira-files<ret>' -docstring 'File picker'
map global user p '!wl-paste<ret>' -docstring 'Paste from system clipboard'
map global user y ':nop %sh{wl-copy $kak_selections 2>/dev/null 1>/dev/null}<ret>' -docstring 'Yank to system clipboard'
map global user c ':comment-line<ret>' -docstring 'Comment line'
map global user h ':lsp-hover<ret>' -docstring 'LSP Hover'

set-option global auto_pairs ( ) { } [ ] '"' '"' "'" "'" ` ` “ ” ‘ ’ « » ‹ ›
enable-auto-pairs

declare-user-mode surround
map global surround m 'm' -docstring 'goto matching'
map global surround M 'M' -docstring 'extend to matching'
map global surround s ':surround<ret>' -docstring 'surround'
map global surround c ':change-surround<ret>' -docstring 'change'
map global surround d ':delete-surround<ret>' -docstring 'delete'
map global surround t ':select-surrounding-tag<ret>' -docstring 'select tag'
map global normal m ':enter-user-mode surround<ret>' -docstring 'surround mode'

define-command -hidden smart-append %{
    try %{ exec -draft <a-k>\A\n\z<ret> ; exec A } catch %{ exec a }
}
map global normal a ': smart-append<ret>'

# kak-lsp
eval %sh{kak-lsp}
lsp-enable

set-option global modelinefmt "%opt{lsp_modeline} %opt{modelinefmt}"

map global user l ':enter-user-mode lsp<ret>' -docstring 'LSP mode'

map global goto d <esc>:lsp-definition<ret> -docstring 'LSP definition'
map global goto r <esc>:lsp-references<ret> -docstring 'LSP references'
map global goto y <esc>:lsp-type-definition<ret> -docstring 'LSP type definition'
map global goto n <esc>:lsp-next-function<ret> -docstring 'LSP next function'
map global goto p <esc>:lsp-previous-function<ret> -docstring 'LSP previous function'
map global goto s <esc>:lsp-next-symbol<ret> -docstring 'LSP next symbol'
map global goto <a-s> <esc>:lsp-previous-symbol<ret> -docstring 'LSP previous symbol'

map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'

map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object f '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
map global object t '<a-semicolon>lsp-object Class Interface Module Namespace Struct<ret>' -docstring 'LSP class or module'
map global object d '<a-semicolon>lsp-diagnostic-object error warning<ret>' -docstring 'LSP errors and warnings'
map global object D '<a-semicolon>lsp-diagnostic-object error<ret>' -docstring 'LSP errors'

lsp-inlay-hints-enable global

face global InfoDefault               Information
face global InfoBlock                 Information
face global InfoBlockQuote            Information
face global InfoBullet                Information
face global InfoHeader                Information
face global InfoLink                  Information
face global InfoLinkMono              Information
face global InfoMono                  Information
face global InfoRule                  Information
face global InfoDiagnosticError       Information
face global InfoDiagnosticHint        Information
face global InfoDiagnosticInformation Information
face global InfoDiagnosticWarning     Information

hook global BufCreate .*\.shpl %{
    set buffer filetype shplait
}

hook -group lsp-filetype-shplait global BufSetOption filetype=shplait %{
    set-option buffer lsp_servers %{
        [racket-language-server]
        root_globs = ["info.rkt"]
        command = "racket"
        args = ["-l", "racket-langserver"]
    }
}
