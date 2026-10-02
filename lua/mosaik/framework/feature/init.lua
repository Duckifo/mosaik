local Shared = require("mosaik.shared")

-- The feature module implements a framework for the
-- color scheme properties. 
local Module = {}
local Feature = require("mosaik.framework.feature.feature")

-- All builtin constraints for Feature.
Module.Contraints = require("mosaik.framework.feature.constraint")
Module.Group = require("mosaik.framework.feature.group")


-- A registry of all registered features via the "Register"
-- call.
local registry = {}

--- Clears the feature registry from all features. Used when
--- the plugin is reloaded as to not register duplicate
--- features.
function Module.ClearFeatureRegistry()
    registry = {}    
end

-- Registers and applies a new feature to the registry. An
-- feature is an optional or conditional property of the
-- colorscheme. E.g italic comments (mosaik_comment_italic)
--
-- TODO: update this reference once documentation is
-- complete.
--
-- See README for more information on usage.
--- @param opts mosaik.Feature.params
function Module.RegisterFeature(opts)
    local feature = Feature:New(opts)
    table.insert(registry, feature)

    local success, err = feature:Apply()

    if not success then 
        Shared.Warn("Unable to apply feature '"..opts.id.."': "..err)
        return
    end
end

return Module
