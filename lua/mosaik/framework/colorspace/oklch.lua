--[[ oklch.lua
    
    This file implements Björn Ottossons oklch colorspace
    translations. The OkLab/OkLch conversion functions are
    adapted from following sources.
        * <https://bottosson.github.io/posts/oklab/> and
        * <https://observablehq.com/@coulterg/oklab-oklch-color-functions>.
]]

---@alias mosaik.RGB {r:number, g:number, b:number}
---@alias mosaik.Lab {L:number, a:number, b:number}
---@alias mosaik.Lch {L:number, c:number, h:number}


local function cbrt(x)
    return (x ^ (1 / 3))
end


---@param sRGB mosaik.RGB
---@return mosaik.RGB linear
local function sRGB_to_linear(sRGB)
    local function sRGBchannel_to_linear(c)
        if c <= 0.04045 then return c/12.92 end
        return ((c+0.055)/1.055)^2.4
    end

    return {
        r = sRGBchannel_to_linear(sRGB.r),
        g = sRGBchannel_to_linear(sRGB.g),
        b = sRGBchannel_to_linear(sRGB.b)
    }
end

---@param linear mosaik.RGB
---@return mosaik.RGB sRGB
local function linear_to_sRGB(linear)
    local function linear_to_sRGBchannel(c)
        if c <= 0.0031308 then
            return 12.92 * c
        else
            return 1.055 * (c ^ (1/2.4)) - 0.055
        end
    end

    return {
        r = linear_to_sRGBchannel(linear.r),
        g = linear_to_sRGBchannel(linear.g),
        b = linear_to_sRGBchannel(linear.b)
    }
end

-- Original code sample from:
-- <https://bottosson.github.io/posts/oklab/#converting-from-linear-srgb-to-oklab>
---@param c mosaik.RGB
---@return mosaik.Lab
local function linear_to_OkLab(c)
    local l = 0.4122214708 * c.r + 0.5363325363 * c.g + 0.0514459929 * c.b
	local m = 0.2119034982 * c.r + 0.6806995451 * c.g + 0.1073969566 * c.b
	local s = 0.0883024619 * c.r + 0.2817188376 * c.g + 0.6299787005 * c.b

    local l_ = cbrt(l)
    local m_ = cbrt(m)
    local s_ = cbrt(s)

    return {
        L = 0.2104542553*l_ + 0.7936177850*m_ - 0.0040720468*s_,
        a = 1.9779984951*l_ - 2.4285922050*m_ + 0.4505937099*s_,
        b = 0.0259040371*l_ + 0.7827717662*m_ - 0.8086757660*s_
    }
end


-- Original code sample from:
-- <https://bottosson.github.io/posts/oklab/#converting-from-linear-srgb-to-oklab>
---@param c mosaik.Lab
---@return mosaik.RGB
local function OkLab_to_linear(c)
    local l_ = c.L + 0.3963377774 * c.a + 0.2158037573 * c.b
    local m_ = c.L - 0.1055613458 * c.a - 0.0638541728 * c.b
    local s_ = c.L - 0.0894841775 * c.a - 1.2914855480 * c.b

    local l = l_*l_*l_
    local m = m_*m_*m_
    local s = s_*s_*s_

    return {
        r =  4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
		g = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
		b = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
    }
end

-- Original code sample:
-- <https://observablehq.com/@coulterg/oklab-oklch-color-functions#oklab_to_oklch>
---@param c mosaik.Lab
---@return mosaik.Lch
local function OkLab_to_OkLch(c)
    local C = math.sqrt(c.a * c.a + c.b * c.b)
    local h = math.atan2(c.b, c.a) * 180 / math.pi

    if h < 0 then h = h + 360 end
    return {
        L = c.L,
        c = C,
        h = h
    }
end

-- Original code sample:
-- <https://observablehq.com/@coulterg/oklab-oklch-color-functions#oklch_to_oklab>
---@param c mosaik.Lch
---@return mosaik.Lab
local function OkLch_to_OkLab(c)
    local hRad = c.h * math.pi / 180
    return {
        L = c.L,
        a = c.c * math.cos(hRad),
        b = c.c * math.sin(hRad),
    }
end

local OkLch = {}

---@param c mosaik.RGB
---@return mosaik.Lch
function OkLch.sRGB_to_OkLch(c)
    return OkLab_to_OkLch(
        linear_to_OkLab(
            sRGB_to_linear(c)
        )
    )
end

---@param c mosaik.Lch
---@return mosaik.RGB
function OkLch.OkLch_to_sRGB(c)
    return linear_to_sRGB(
        OkLab_to_linear(
            OkLch_to_OkLab(c)
        )
    )
end

---@param a number
---@param b number
---@param t number
---@return number
function OkLch.lerp_hue(a, b, t)
    local d = (b - a + 180) % 360 - 180
    return (a + d * t) % 360
end

return OkLch
