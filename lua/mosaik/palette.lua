local Palette = {}

function Palette.light()
    local orange = "#c96c48"
    local blue =   "#3a57b3"

    return {
        text = "#1f1f1d",
        textBlend = "#a2a3a0",
        surface = "#f7f6f4",
        surfaceSoft = "#e8e7e5",

        user = orange,
        orange = orange,

        program = blue,
        blue = blue
    }    
end

function Palette.colors()
    return Palette.light()
end

return Palette
