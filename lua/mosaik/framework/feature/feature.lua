local Class = require("mosaik.framework.class")
local Highlight = require("mosaik.framework.highlight")

-- An environment for each feature that includes special
-- functions, to monitor and modify calls to environment
-- functions.
-- TODO: document these.
---@alias mosaik.Feature.callback.env {
--- option: fun(id: string, value: any),
--- set: fun(map: table<string, vim.api.keyset.highlight>),
--- remove: fun(map: string[]),
--- merge: fun(map: table<string, vim.api.keyset.highlight>)
---}

---@alias mosaik.Feature.callback 
--- fun(v: any, env: mosaik.Feature.callback.env)

---@class (exact) mosaik.Feature.params
---@field id          string
---@field callback    mosaik.Feature.callback
---@field constraint  mosaik.Constraint
---@field group       mosaik.Group
---@field description string?
---@field default     any

-- TODO: document this class.
---@class mosaik.Feature: mosaik.Class
---@field id          string
---@field default     any
---@field group       mosaik.Group
---@field description string?
---
--- An constraint object that validates values for the
--- feature.
---@field constraint  mosaik.Constraint
---
--- A callback to apply the feature.
---@field callback    mosaik.Feature.callback
---
---@field New fun(self: self, params: mosaik.Feature.params): self
local Feature = Class.Define("Feature")

function Feature:Init(params)
    self.id = params.id
    self.default = params.default
    self.description = params.description
    self.callback = params.callback
    self.group = params.group
    self.constraint = params.constraint
end

-- Creates a new environment table based of the id of the
-- instance. 
---@private
---@return mosaik.Feature.callback.env
function Feature:CreateEnvironment()
    -- TODO: track states over object, to find conflicting
    -- calls. This is also why this is a method and not a
    -- independent function.
    return {
        option = function(id, value)
            vim.g["mosaik_"..id] = vim.g["mosaik_"..id] or value
        end,
        set = Highlight.Map,
        merge = Highlight.MapMerge,
        remove = Highlight.MapRemove
    } ---@type mosaik.Feature.callback.env
end

-- Gets the user option from vim global index, alternatively
-- returns default if no user option set.
function Feature:GetValue()
    return vim.g["mosaik_"..self.id] or self.default
end

-- Applies the instance by running the feature callback.
-- Returns pcall-style status from the callback function.
---@return boolean, any, ...any
---@overload fun(): true, nil
---@overload fun(): false, string
function Feature:Apply()
    local value = self:GetValue()

    -- validate value.
    if not self.constraint:Validate(value) then
        return false, string.format("Expected %s got %s",
            self.constraint:DescribeExpected(), vim.inspect(value)
        )
    end

    local environment = self:CreateEnvironment()
    return pcall(self.callback, value, environment)
end

return Feature
