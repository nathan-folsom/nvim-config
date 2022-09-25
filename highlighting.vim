" VIM global highlight groups
hi Cursor ctermfg=8 
hi Comment ctermfg=10
hi Type ctermfg=15
hi Todo ctermfg=0
hi DiffAdd ctermbg=2
hi DiffChange ctermbg=4 
hi DiffDelete ctermbg=9
hi SignColumn ctermbg=NONE
hi LineNr ctermfg=6 
hi Pmenu ctermbg=8 ctermfg=15
hi FloatBorder ctermbg=8
hi Search ctermbg=5 ctermfg=15
hi CursorLine ctermbg=8 cterm=NONE
hi CursorLineNr cterm=NONE ctermfg=13
hi Error ctermbg=1
hi DiagnosticHint ctermfg=3
hi MatchParen ctermbg=3
hi PreProc ctermfg=14
hi Label ctermfg=9

" Treesitter highlight groups
hi link TSSymbol Type
hi link TSFunction Type

" TSX highlight groups
hi link tsxTag TSXTag
hi link tsxCloseTag TSXTag
hi link tsxTagName TSXTag
hi link tsxIntrinsicTagName TSXTag
hi link tsxCloseString TSXTag
hi link TSXTag Label

" TypeScript highlight groups
hi link typescriptImport Keyword
hi link typescriptExport Keyword
hi link typescriptVariable Keyword
hi link typescriptEnumKeyword Keyword
hi link typescriptFuncName Type
hi link typescriptTypeReference Type
hi link typescriptBraces Normal
hi link typescriptCall Normal

" Get highlight groups of character under cursor
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
