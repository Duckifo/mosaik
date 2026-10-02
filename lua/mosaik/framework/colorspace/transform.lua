local hex = require("mosaik.framework.colorspace.hexrgb")
local oklch = require("mosaik.framework.colorspace.oklch")

local function lerp(a,b,t)
    return a + (b - a) * t
end

local transform = {}

-- Lerps inbetween two colors on the oklch
-- color space. Each field of the colors are interpolated
-- separatly with alpha of coresponding field in `opts`.
---@param c1 mosaik.RGB
---@param c2 mosaik.RGB
---@param opts { L: number, c: number, h: number }
---@return mosaik.RGB
function transform.shift_sRGB(c1, c2, opts)
    local c1_oklch = oklch.sRGB_to_OkLch(c1)
    local c2_oklch = oklch.sRGB_to_OkLch(c2)
    return oklch.OkLch_to_sRGB({
        L = lerp(c1_oklch.L, c2_oklch.L, opts.L),
        c = lerp(c1_oklch.c, 0, opts.c),
        h = oklch.lerp_hue(c1_oklch.h, c2_oklch.h, opts.h),
    })
end

---@see transform.shift_sRGB
---@param c1 mosaik.RGB | string
---@param c2 mosaik.RGB | string
---@param opts mosaik.Lch
---@return string
function transform.shift(c1, c2, opts)
    if type(c1) == "string" then c1 = hex.hex_to_sRGB(c1) end
    if type(c2) == "string" then c2 = hex.hex_to_sRGB(c2) end
    return hex.sRGB_to_hex(transform.shift_sRGB(c1, c2, opts))
end

return transform
