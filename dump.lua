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
----------------- diff snapshot ------------------
[1] (T)    Root->(T)[registry]->(S)[1]->(T)lss{#dump.lua:0}->(L@./lsnapshot.lua:125)dstop_snapshot->(T)begin_s size:2.0546875Kb
[2] (T)    Root->(T)[registry]->(S)[1]->(T)k{#dump.lua:0} size:0.0546875Kb
[3] (T)    Root->(T)[registry]->(S)[1]->(T)tmp{#dump.lua:0} size:0.0546875Kb
[4] (T)    Root->(T)[registry]->(S)[1]->(T)sss{#dump.lua:0} size:0.0546875Kb
[5] (L@dump.lua:9)    Root->(T)[registry]->(S)[1]->(L@dump.lua:9)foo{#dump.lua:0} size:0.0390625Kb
--------------- all size:2.2578125Kb ---------------
--------------- all size:2.2578125Kb ---------------
]]