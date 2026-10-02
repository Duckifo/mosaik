-- This module includes tools to modify the vim highlights.
local Highlight = {}

-- An unique identifier used to mark a field undefined instead of nil, as nil
-- wouldn't be detectable.
Highlight.undefined = {} ---@as nil

-- A buffer that contains all changes to be made to vim's
-- highlights as to get faster lookups / merges. Can then
-- later be applied via Highlight.Apply().
Highlight.buffer = {}

-- Apply the highlight buffer to neovim.
function Highlight.Apply()
    for capture, highlight in pairs(Highlight.buffer) do
        vim.api.nvim_set_hl(0, capture, highlight)
    end
end

-- Retrieves an highlight. Primarily looks in the mosaik
-- highlight buffer, if not found in buffer fetches
-- highlight from vim.
---@param id string
---@return vim.api.keyset.highlight
function Highlight.Get(id)
    return Highlight.buffer[id] or 
           vim.api.nvim_get_hl(0, { name = id, link = false }) ---@as vim.api.keyset.highlight
end

-- Overrides passed highlight value at id index in module
-- highlight buffer. Note that this function does not edit
-- vim's context in any way.
---@param id string
---@param highlight vim.api.keyset.highlight
function Highlight.Set(id, highlight)
    Highlight.buffer[id] = highlight
end

-- Force merges respective highlights. Takes highlight id or
-- highlight table.
---@param h1 string | vim.api.keyset.highlight
---@param h2 string | vim.api.keyset.highlight
function Highlight.Merge(h1,h2)
    if type(h1) == "string" then h1 = Highlight.Get(h1) or {} end
    if type(h2) == "string" then h2 = Highlight.Get(h2) or {} end

    return vim.tbl_extend("force", h1, h2)
end


-- Applies passed capture map to mosaik's highlight buffer.
---@param map table<string, vim.api.keyset.highlight>
function Highlight.Map(map)
    for capture, highlight in pairs(map) do
        Highlight.Set(capture, highlight)
    end
end


-- Removes all the passed highlight groups from mosaik's
-- highlight buffer.
---@param groups string[]
function Highlight.MapRemove(groups)
    for _, capture in ipairs(groups) do
        Highlight.Set(capture, {})
    end
end


-- Merge each capture with existing definition and apply to
-- mosaik's highlight buffer. Supports the undefined
-- identifier to mark fields to remove in the merge.
---@param map table<string, vim.api.keyset.highlight>
function Highlight.MapMerge(map)
    for capture, fields in pairs(map) do
        local highlight = Highlight.Get(capture)

        -- Remove fields marked as undefined
        for field, value in pairs(fields) do
            if value == Highlight.undefined then
                -- Remove the field as its marked undefined.
                highlight[field] = nil
                fields[field] = nil
            end
        end

        Highlight.Set(capture, Highlight.Merge(highlight, fields))
    end
end

-- Removes the fields from respective capture passed in the
-- context map. ! Though preferred to use contextMerge with
-- with the undefined identifier instead of this function. !
---@param map table<string, string[]>
function Highlight.MapRemoveFields(map)
    for capture, fields in pairs(map) do
        local highlight = Highlight.Get(capture)

        for _, field in ipairs(fields) do
            highlight[field] = nil
        end

        Highlight.Set(capture, highlight)
    end
end

return Highlight
