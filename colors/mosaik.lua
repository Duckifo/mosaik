local temp = {
    text = "#1f1f1d",
    textBlend = "#a2a3a0",

    surface = "#f7f6f4",
    surfaceSoft = "#e8e7e5",

    user = "#c96c48",
    program = "#3a57b3"
}

-- Wraps Neovim's API and set highlight at namespace 0.
function set(id, highlight)
    vim.api.nvim_set_hl(0, id, highlight)
end


set("Ident", { italic = true })
set("Program", { fg = temp.program })
set("User", { fg = temp.user })
set("Dim", { fg = temp.textBlend})

set("Visual", { reverse = true })

set("Normal", { fg = temp.text, bg = temp.surface })
set("NormalFloat", { fg = temp.text, bg = temp.surfaceSoft })
set("NormalBorder", { fg = temp.text, bg = temp.surfaceSoft })
set("ColorColumn", { bg = temp.surfaceSoft })

set("StatusLine", { fg = temp.surface, bg = temp.user })
set("StatusLineNC", { fg = temp.surface, bg = temp.program })

set("Search", { bg = temp.user, fg = temp.surface })

set("CursorLine", { bg = temp.surfaceSoft })
set("CursorColumn", { link = "CursorLine" })
set("LineNr", { link = "Dim" })
set("NonText", { link = "Dim" })

set("@comment", { link = "User" })
set("@string", { link = "Program" })
set("@number", { link = "Program" })

set("@property", { link = "Normal" })
set("@keyword", { link = "Normal" })
set("@punctuation", { link = "Normal" })
set("@punctuation.special", { link = "@punctuation" })
set("@constructor", { link = "Normal" })
set("@variable", { link = "Normal" })

set("@function", { link = "Ident" })
set("@function.call", { link = "Normal" })
set("@function.builtin", { link = "Normal" })

require("mosaik.groups")
