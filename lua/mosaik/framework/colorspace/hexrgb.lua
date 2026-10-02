local hexrgb = {}

---@param hex string
---@return mosaik.RGB
function hexrgb.hex_to_sRGB(hex)
    local r,g,b = hex:match('#?(..)(..)(..)')
    assert(r and g and b, "Invalid hex string.")

    r,g,b = tonumber(r,16),tonumber(g,16),tonumber(b,16)
    assert(r and g and b, "Invalid hex characters.")

    return {
        r = r/255,
        g = g/255,
        b = b/255
    }
end

---@param sRGB mosaik.RGB
---@return string
function hexrgb.sRGB_to_hex(sRGB)
    local function clamp(x)
        return math.max(0, math.min(1, x))
    end

    local r = math.floor(clamp(sRGB.r) * 255 + 0.5)
    local g = math.floor(clamp(sRGB.g) * 255 + 0.5)
    local b = math.floor(clamp(sRGB.b) * 255 + 0.5)

    return string.format("#%02x%02x%02x", r, g, b)
end

return hexrgb
