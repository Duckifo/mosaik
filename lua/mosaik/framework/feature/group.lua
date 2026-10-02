local Class = require("mosaik.framework.class")

-- Represents an identifier for an collection of features.
-- TODO: Link to development documentation once written.
---@class mosaik.Group : mosaik.Class
---@field name string
---@field description string
--- 
--- The higher the importance, the further up the group will
--- be displayed in documentation.
---@field importance int
---
--- Extending groups will be placed under their super group.
---@field extends mosaik.Group?
---@field New fun(self: self, name: string, desc: string, imp: int, ext: mosaik.Group?): self
local Group = Class.Define("Group")

function Group:Init(name, desc, imp, ext)
    self.name = name
    self.description = desc
    self.importance = imp
    self.extends = ext
end

return Group
