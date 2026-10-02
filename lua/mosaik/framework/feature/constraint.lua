local Class = require("mosaik.framework.class")

-- An interface that represents a constraint on values.
-- A constraint determines whether a value belongs to a
-- particular set of accepted values of the kind. Ex.
--      * a type ("string")
--      * an enumeration ("red", "green", "blue")
--      * a numeric range (0.0 - 1.0)
--      * etc...
---@class mosaik.Constraint: mosaik.Class
---
--- Checks whether passed value satisfies this constraint.
---@field Validate          fun(self: self, v: any): boolean
---
--- Returns human-readable documentation about the
--- constraint. Ex: `number values between 0.0 - 1.0`.
--- Each string represents a paragraph.
---@field DescribeContraint fun(self: self): string[]
---
--- Returns a human-readable description of the expected
--- value for use in validation error messages. The returned
--- string should work at `...` in this sentence: `"expected
--- ... got something else"`.
---@field DescribeExpected  fun(self: self, v: any): string


--- An namespace for all builtin constraint.
local Constraints = {}

-- {{{ Enum Constraint. 

---@alias mosaik.EnumConstraint.enumMeta 
---     { [1]: any, desc: string? }

-- Constrains value to defined enumeration of values,
-- supports enumeration documentation.
---@class mosaik.EnumConstraint: mosaik.Constraint
---@field acceptedArray any[]
---@field acceptedMeta  mosaik.EnumConstraint.enumMeta[]
---@field New           fun(self: self,
---                         opts: (mosaik.EnumConstraint.enumMeta|any)[]
---                     ): self
Constraints.Enum = Class.Define("EnumContraint")

---@param opts (mosaik.EnumConstraint.enumMeta|any)[]
function Constraints.Enum:Init(opts)
    self.acceptedMeta = vim.tbl_map(function(v)
        return type(v) == "table" and v or { v }
    end, opts)
    self.acceptedArray = vim.tbl_map(function(v)
        return v[1]
    end, self.acceptedMeta)
end

function Constraints.Enum:Validate(v)
    return vim.tbl_contains(self.acceptedArray, v)
end

function Constraints.Enum:DescribeExpected()
    return (vim.inspect(self.acceptedArray):gsub("{","("):gsub("}",")"))
end

function Constraints.Enum:DescribeContraint()
    local out = {}
    for _, v in ipairs(self.acceptedMeta) do
        table.insert(out, 
            vim.inspect(v[1]) .. (v.desc and " - " .. v.desc or "")
        )
    end
    return out
end

--}}}

-- {{{ Type Constraint.

---@class mosaik.TypeConstraint: mosaik.Constraint
---@field accepted string
---@field New   fun(self: self, type: string): self
Constraints.Type = Class.Define("TypeConstraint")

function Constraints.Type:Init(type)
    self.accepted = type 
end

function Constraints.Type:Validate(v)
    return type(v) == self.accepted
end

function Constraints.Type:DescribeExpected()
    return "typeof "..self.accepted
end

function Constraints.Type:DescribeContraint()
    return {"Any value with type of \""..self.accepted.."\""}
end

--}}}

-- {{{ Range Constraint.

---@class mosaik.RangeConstraint: mosaik.Constraint
---@field from number
---@field to number
---@field New fun(self: self, from: number, to: number): self
Constraints.Range = Class.Define("RangeConstraint")

function Constraints.Range:Init(from, to)
    assert(from < to, "from cannot be larger the to.")
    self.from = from
    self.to = to
end

function Constraints.Range:Validate(v)
    return (v < self.to) and (v > self.from)
end

function Constraints.Range:DescribeExpected()
    return string.format("number value (%.2f - %.2f)", self.from, self.to)
end

function Constraints.Range:DescribeContraint()
    return {string.format("Number value (%.2f - %.2f).", self.from, self.to)}
end

-- }}}

-- {{{ Boolean Constraint.

-- An boolean constraint with documentation, if you don't
-- need / use documentation it is preferred to use
-- UndocumentedBoolean instead.
---@class mosaik.BooleanConstraint : mosaik.EnumConstraint
---@field New fun(self: self, opts: { boolean: string? }): self
Constraints.Boolean = Class.Define("BooleanConstraint", Constraints.Enum)

-- An constraint instance that is preferred to use over
-- BooleanConstraint if no further documentation is needed.
Constraints.UndocumentedBoolean = Constraints.Type:New("boolean")

-- }}}

return Constraints 
