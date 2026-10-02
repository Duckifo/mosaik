-- mosaik/groups.lua ~
-- This file includes static bindings for all vim-UI and
-- tree-sitter queries. Language specific bindings are at
-- the bottom of the file.

local Highlight = require("mosaik.framework.highlight")
local Map = Highlight.Map
local colors = require("mosaik.palette").colors()

--{{{ Core Editor
Map {
    -- Core UI
    Normal = { bg = colors.surface, fg = colors.text },
    NormalNC = { link = "Normal" },
    NormalFloat = { link = "Normal", },
    FloatBorder = { link = "NormalFloat" },

    EndOfBuffer = { fg = colors.textBlend },
    NonText = { fg = colors.textBlend },
    Whitespace = { fg = colors.textBlend },
    Special = { fg = colors.program },

    -- Status line
    StatusLine = { fg=colors.surface, bg=colors.user },
    StatusLineNC = { fg=colors.surface, bg=colors.program }, 
    StatusLineTerm = { link="StatusLine" },
    StatusLineTermNC = { link="StatusLineNC" },

    -- Tabline
    TabLine = { fg=colors.surface, bg=colors.program }, -- TODO: Change color. TabLineFill = { link = "LineNr" },
    TabLineSel = { fg=colors.text, bg=colors.surface, bold = true},
    
    -- Cursor & Position
    Cursor = { reverse = true },
    CursorLine = { bg = colors.surfaceSoft },
    CursorColumn = { link = "CursorLine" },
    TermCursor = { bg = colors.text, fg = colors.surface },
    Visual = { reverse = true },
    VisualNOS = { link = "Visual" },
    MatchParen = { fg = colors.user },

         
    -- Status column
    LineNr = { fg = colors.textBlend },
    LineNrAbove = { link = "LineNr" },
    LineNrBelow = { link = "LineNr" },
    SignColumn = { fg = colors.textBlend },
    FoldColumn = { link = "SignColumn" },

    -- Messages & command area
    MsgArea = { fg = colors.text },
    MsgSeparator = { fg = colors.surface, bg = colors.text },
    MoreMsg = { fg = colors.text },
    ErrorMsg = { fg = colors.orange },
    WarningMsg = { fg = colors.orange },
    ModeMsg = { fg = colors.text },
    Question = { fg = colors.text },

    -- Diff & Git signs
    Added = { link = "@diff.plus" },
    Removed = { link = "@diff.minus" },
    Changed = { link = "@diff.delta" },

    DiffAdd = { link = "@diff.plus" },
    DiffDelete = { link = "@diff.minus" },
    DiffChange = { link = "@diff.delta" },
    DiffText = { fg = colors.text },

    GitAdd = { link = "@diff.plus" },
    GitChange = { link = "@diff.delta" },
    GitDelete = { link = "@diff.minus" },

    -- Popup menu (completion)
    Pmenu = { fg = colors.text },
    PmenuSel = { fg = colors.surface, bg = colors.user },
    PmenuKind = { link = "Pmenu" },
    PmenuKindSel = { link = "PmenuSel" },
    PmenuExtra = { link = "Pmenu" },
    PmenuExtraSel = { link = "PmenuSel" },
    PmenuSbar = { link = "Pmenu" },
    PmenuThumb = { fg = colors.text, bg = colors.surfaceSoft },
    PmenuMatch = { fg = colors.text, bold = true },
    PmenuMatchSel = { fg = colors.surface, bold = true },
    WildMenu = { fg = colors.surface, bg = colors.text },
    
    -- Vim syntax
    Identifier = { link = "@variable" },
    Function = { link = "@function" },

    Keyword = { link = "@keyword" },
    Statement = { link = "@keyword" },
    Conditional = { link = "@keyword.conditional" },
    Repeat = { link = "@keyword.repeat" },
    Operator = { link = "@operator" },
    Exeption = { link = "@keyword.exeption" },
    Label = { link = "@label" },

    Type = { link = "@type" },
    Storageclass = { link = "@type" },
    Structure = { link = "@type" },
    Typedef = { link = "@type" },

    String = { link = "@string" },
    Character = { link = "@character" },
    Number = { link = "@number" },
    Float = { link = "@number.float" },
    Constant = { link = "@constant" },
    Boolean = { link = "@boolean" },

    Delimiter = { link = "@punctuation.delimiter" },

    Comment = { link = "@comment" },

    -- vim Diagnostics
    DiagnosticError = { fg=colors.orange },
    DiagnosticWarn =  { fg=colors.orange },
    DiagnosticHint =  { fg=colors.blue },
    DiagnosticInfo =  { link = "DiagnosticHint" },

    DiagnosticVirtualTextError = { link="DiagnosticError" },
    DiagnosticVirtualTextWarn = { link="DiagnosticWarn" },
    DiagnosticVirtualTextHint = { link="DiagnosticHint" },
    DiagnosticVirtualTextInfo = { link = "DiagnosticInfo" },

    DiagnosticUnderlineError = { underline=true, sp = colors.orange },
    DiagnosticUnderlineWarn = { underline=true, sp = colors.orange },
    DiagnosticUnderlineHint = { undercurl=true, sp = colors.blue },
    DiagnosticUnderlineInfo = { link = "DiagnosticUnderlineHint" },

    DiagnosticSignError = { fg=colors.orange },
    DiagnosticSignWarn = { fg=colors.orange },
    DiagnosticSignHint = { fg=colors.blue },
    DiagnosticSignInfo = { link = "DiagnosticSignHint" },

    -- Misc
    Folded = { fg = colors.textBlend },
    WinSeparator = { fg = colors.text },
    Directory = { fg = colors.user },
    Title = { fg = colors.text, bold = true },

    SnippetTabstop = { bg = colors.blue },

    Conceal = { fg = colors.textBlend },
    SpecialKey = { fg = colors.textBlend },
}
--}}}

--{{{ Treesitter
Map {
    -- variable
    ["@variable"] = { link = "Normal" },
    ["@variable.builtin"] = { link="@variable" },
    ["@variable.parameter"] = { link="@variable" },
    ["@variable.parameter.builtin"] = { link="@variable" },
    ["@variable.member"] = { link="@variable" },

    ["@constant"] = { link="Normal" },
    ["@constant.builtin"] = { link="@varieble.builtin" },
    ["@constant.macro"] = { link="@text" },

    ["@module"] = { fg=colors.text, italic=true },
    ["@module.builtin"] = { link="@module" },

    -- literals
    ["@string"] = { fg=colors.program },
    ["@string.documentation"] = { link="@comment" },
    ["@string.regexp"] = { link="@string" },
    ["@string.escape"] = { link = "Normal" },
    ["@string.special"] = { link="@string" },
    ["@string.special.symbol"] = { link="@string" },
    ["@string.special.path"] = { link="@string" },
    ["@string.special.url"] = { fg=colors.program, underline=true },

    ["@character"] = { link = "@string" },
    ["@character.special"] = { link="@character" },

    ["@boolean"] = { fg=colors.program  },
    ["@number"] = { fg=colors.program },
    ["@number.float"] = { link = "@number" },

    -- objects
    ["@type"] = { fg=colors.text },
    ["@type.builtin"] = { link = "@type" },
    ["@type.definition"] = { link = "@type" },

    ["@attribute"] = { fg=colors.program },
    ["@attribute.builtin"] = { link="@attribute" },

    ["@property"] = { link="Normal" },

    -- function
    ["@function"] = { fg=colors.text, italic = true },
    ["@function.call"] = { fg=colors.text },
    ["@function.method"] = { link="@function" },
    ["@function.method.call"] = { link="@function.call" },

    ["@function.builtin"] = { fg=colors.text, bold=true },
    ["@function.macro"] = { link="@function.call" },

    ["@constructor"] = { link="Normal" },
    ["@operator"] = { link="Normal" },

    -- keywords
    ["@keyword"] = { link = "Normal" },
    ["@keyword.coroutine"] = { link="@keyword" },
    ["@keyword.function"] = { link="@keyword" },
    ["@keyword.operator"] = { link="@keyword" },
    ["@keyword.import"] = { link="@keyword" },
    ["@keyword.type"] = { link="@keyword" },
    ["@keyword.modifier"] = { link="@keyword" },
    ["@keyword.repeat"] = { link="@keyword" },
    ["@keyword.return"] = { link="@keyword" },
    ["@keyword.debug"] = { link="@keyword" },
    ["@keyword.exception"] = { link="@keyword" },
    ["@keyword.conditional"] = { link="@keyword" },
    ["@keyword.conditional.ternary"] = { link="@keyword" },
    ["@keyword.directive"] = { link="@keyword" },
    ["@keyword.directive.define"] = { link="@keyword" },

    ["@punctuation"] = { fg=colors.text },
    ["@punctuation.delimiter"] = { link="@punctuation" },
    ["@punctuation.bracket"] = { link="@punctuation" },
    ["@punctuation.special"] = { link="@punctuation.bracket" },

    -- comment
    ["@comment"] = { fg=colors.user },
    ["@comment.documentation"] = { link="@comment" },

    ["@comment.error"] = { fg=colors.program, reverse=true, bold = true},
    ["@comment.warning"] = { fg=colors.program, reverse=true, bold = true },
    ["@comment.todo"] = { fg=colors.user, reverse=true, bold = true },
    ["@comment.note"] = { fg=colors.user, reverse=true, bold = true },

    -- markup
    ["@label"] = { fg = colors.user },

    ["@markup.strong"] = { bold=true },
    ["@markup.italic"] = { italic=true },
    ["@markup.strikethrough"] = { strikethrough=true },
    ["@markup.underline"] = { underline=true },

    ["@markup.heading"] = { fg=colors.user, bold = true },
    ["@markup.heading.1"] = { link="@markup.heading" },
    ["@markup.heading.2"] = { fg=colors.program, bold = true },
    ["@markup.heading.3"] = { fg=colors.text, bold = true },

    ["@markup.qoute"] = { fg=colors.text },
    ["@markup.math"] = { fg=colors.program },

    ["@markup.link"] = { link="@text.url" },
    ["@markup.link.url"] = { link="@markup.link" },
    ["@markup.link.label"] = { link="@label" },

    ["@markup.raw"] = { fg=colors.program },
    ["@markup.raw.block"] = { link = "@markup.raw" },

    ["@markup.list"] = { fg=colors.text },
    ["@markup.list.checked"] = { fg=colors.user },
    ["@markup.list.unchecked"] = { fg=colors.program },

    -- diff and tags
    ["@diff.plus"] = { fg=colors.orange, reverse = true },
    ["@diff.minus"] = { fg=colors.blue, reverse = true },
    ["@diff.delta"] = { reverse = true },

    -- text
    ["@text"] = { fg=colors.text },
    ["@text.url"] = { fg=colors.text, undercurl=true },
    ["@text.uri"] = { link = "@text.url" },
}
--}}}

Highlight.Apply()
