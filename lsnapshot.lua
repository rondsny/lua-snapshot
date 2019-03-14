local snapshot = require "snapshot"
local M = {}

local t2simple = {
    table = "(T)",
    userdata = "(U)",
    -- ["function"] = "(L)",
    thread = "(S)",
    cfunction = "(C)",
}

local begin_s = nil
function M.start_snapshot()
    begin_s = snapshot()
end


local function reshape_snapshot(s)
    local reshape = {}
    for k, v in pairs(s) do
        local rk = k
        k = tostring(k)
        k = string.match(k, "userdata: (.+)")
        local t, pk, field = string.match(v, "([^\n]+)\n([%a%d]+) : ([^\n]+)")
        local tt, size = string.match(t, "([^%s]*) {(%d+)}")
        if not tt then
            error(string.format("invalid snapshot value:%s", v))
        end
        t = tt
        size = size and tonumber(size) or 0
        local st = t2simple[t] or string.format("(L@%s)", t)
        reshape[k] = {
            v = rk,
            t = t,
            size = size,
            st = st,
            parent_key = pk,
            field = field,
            item = st .. field,
            fullpath = nil,
        }
    end

    local function gen_fullname()
        for k, entry in pairs(reshape) do
            if not entry.fullpath then
                local list = {
                    {entry = entry, item = entry.item}
                }
                local map = {}
                while true do
                    local pk = entry.parent_key
                    local pentry = reshape[pk]
                    if not pentry then
                        list[#list+1] = string.format("{%s}", entry.parent_key)
                        break
                    elseif pentry.fullpath then
                        list[#list+1] = pentry.fullpath
                        break
                    else
                        if map[pk] then
                            pentry.fullpath = pentry.item
                            list[#list+1] = pentry.item
                            break
                        else
                            list[#list+1] = {
                                entry = pentry,
                                item = pentry.item,
                            }
                            map[pk] = true
                        end
                    end
                    entry = pentry
                end

                local nlist = {}
                local len = #list
                for i=len, 1, -1 do
                    nlist[#nlist+1] = list[i]
                end

                local spath = {}
                for i,v in ipairs(nlist) do
                    if type(v) == "string" then
                        spath[#spath+1] = v
                    else
                        spath[#spath+1] = v.item
                        local fullpath = table.concat(spath, "->")
                        v.entry.fullpath = fullpath
                    end
                end
            end
        end
    end
    gen_fullname()

    local ret = {}
    for k,v in pairs(reshape) do
        ret[#ret+1] = {
            type = v.t,
            path = v.fullpath,
            v = v.v,
            st = v.st,
            size = v.size,
        }
    end
    return ret
end


function M.dstop_snapshot(len)
    if not begin_s then
        error("snapshot not begin")
    end
    local end_s = snapshot()
    local diff_s = {}
    for k,v in pairs(end_s) do
        if begin_s[k] == nil then
            diff_s[k] = v
        end
    end

    local reshape = reshape_snapshot(diff_s)
    table.sort(reshape, function (a, b)
            return a.size > b.size
        end)
    local rlen = #reshape
    len = len or rlen
    if len < 0 or len > rlen then
        len = rlen
    end

    local all_size = 0
    print("------------------ diff snapshot ------------------")
    for i=1, rlen do
        local v = reshape[i]
        all_size = all_size + v.size
        if i <= len then
            print(string.format("[%d] %s    %s size:%sKb", i, v.st, v.path, v.size / 1024))
        elseif i == len+1 then
            print(string.format("more than %d ...", rlen - len))
        end
    end
    print(string.format("--------------- all size:%sKb ---------------", all_size / 1024))
end

return M