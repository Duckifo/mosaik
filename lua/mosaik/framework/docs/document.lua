local ClassModule = require("mosaik.framework.class")

---@class mosaik.Document : mosaik.Class
---@field out string[]
local Document = ClassModule.Define("Document")

function Document:Init(opts)
    self.out = {}
end

return Document
