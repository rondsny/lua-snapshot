local lss = require "lsnapshot"


local sss = nil
lss.start_snapshot()

local tmp = {}
sss = {}
local function foo()
    return sss
end
local k = {}

lss.dstop_snapshot(40)
--[[
$ lua dump.lua
------------------ diff snapshot ------------------
[1] (T)    {0x7fcebfc0a260}->(T)begin_s size:2.0546875Kb
[2] (T)    {0x7fcec0001008}->(T)tmp : dump.lua:14 size:0.0546875Kb
[3] (T)    {0x7fcec0001008}->(T)sss : dump.lua:14 size:0.0546875Kb
[4] (T)    {0x7fcec0001008}->(T)k : dump.lua:14 size:0.0546875Kb
[5] (L@dump.lua:9)    {0x7fcec0001008}->(L@dump.lua:9)foo : dump.lua:14 size:0.0390625Kb
--------------- all size:2.2578125Kb ---------------
]]