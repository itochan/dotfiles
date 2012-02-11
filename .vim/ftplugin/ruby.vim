function! MagicComment()
  return "# -*- coding: ".&encoding." -*-\<CR>\<BS>\<BS>\<CR>"
endfunction

inoreabbrev <buffer> ## <C-R>=MagicComment()<CR>
