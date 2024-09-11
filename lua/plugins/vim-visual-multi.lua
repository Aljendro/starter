return {
  "mg979/vim-visual-multi",
  init = function()
    vim.g.VM_theme = "neon"
    vim.g.VM_silent_exit = true
    vim.g.VM_mouse_mappings = true
    vim.g.VM_maps = {
      ["Find Under"] = "<C-n>",
      ["Find Subword Under"] = "<C-n>",
      ["Select All"] = "<localleader>A",
      ["Start Regex Search"] = "<localleader>/",
      ["Add Cursor Up"] = "<C-Up>",
      ["Add Cursor Down"] = "<C-Down>",
      ["Add Cursor At Pos"] = "<localleader><localleader>",

      ["Visual Regex"] = "<localleader>/",
      ["Visual All"] = "<localleader>A",
      ["Visual Add"] = "<localleader>a",
      ["Visual Find"] = "<localleader>f",
      ["Visual Cursors"] = "<localleader>c",

      ["Switch Mode"] = "<Tab>",

      ["Find Next"] = "<localleader>]",
      ["Find Prev"] = "<localleader>[",
      ["Goto Prev"] = "<localleader>{",
      ["Goto Next"] = "<localleader>}",
      ["Seek Next"] = "<C-f>",
      ["Seek Prev"] = "<C-b>",
      ["Skip Region"] = "q",
      ["Remove Region"] = "Q",
      ["Invert Direction"] = "o",
      ["Find Operator"] = "m",
      ["Surround"] = "S",
      ["Replace Pattern"] = "R",

      ["Tools Menu"] = "<localleader>`",
      ["Show Registers"] = '<localleader>"',
      ["Case Setting"] = "<localleader>c",
      ["Toggle Whole Word"] = "<localleader>w",
      ["Transpose"] = "<localleader>t",
      ["Align"] = "<localleader>a",
      ["Duplicate"] = "<localleader>d",
      ["Rewrite Last Search"] = "<localleader>r",
      ["Merge Regions"] = "<localleader>m",
      ["Split Regions"] = "<localleader>s",
      ["Remove Last Region"] = "<localleader>q",
      ["Visual Subtract"] = "<localleader>s",
      ["Case Conversion Menu"] = "<localleader>C",
      ["Search Menu"] = "<localleader>S",

      ["Run Normal"] = "<localleader>z",
      ["Run Last Normal"] = "<localleader>Z",
      ["Run Visual"] = "<localleader>v",
      ["Run Last Visual"] = "<localleader>V",
      ["Run Ex"] = "<localleader>x",
      ["Run Last Ex"] = "<localleader>X",
      ["Run Macro"] = "<localleader>@",
      ["Align Char"] = "<localleader><",
      ["Align Regex"] = "<localleader>>",
      ["Numbers"] = "<localleader>n",
      ["Numbers Append"] = "<localleader>N",
      ["Zero Numbers"] = "<localleader>0n",
      ["Zero Numbers Append"] = "<localleader>0N",
      ["Shrink"] = "<localleader>-",
      ["Enlarge"] = "<localleader>+",

      ["Toggle Block"] = "<localleader><BS>",
      ["Toggle Single Region"] = "<localleader><CR>",
      ["Toggle Multiline"] = "<localleader>M",
    }
  end,
}
