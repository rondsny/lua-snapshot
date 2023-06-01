local tbl = {
    ["a"] = {key = "a", parent = "b"},
    ["b"] = {key = "b", parent = "c"},
    ["c"] = {key = "c", parent = "a"},
    ["d"] = {key = "d", parent = "e"},
    ["e"] = {key = "e", parent = nil},
    ["f"] = {key = "f", parent = "g"},
    ["g"] = {key = "g", parent = "f"},
}

-- 计算tbl中有多少个环
local function remove_parent(tbl)
    local loop_tbl = {}
    local count = 0
    local cache = {}
    for k, v in pairs(tbl) do
        if not cache[k] then
            cache[k] = true
            local parent = v.parent
            
            local max_key = k
            while parent do
                if max_key < parent then
                    max_key = parent
                end
                cache[parent] = true
                if parent == k then
                    tbl[max_key].parent = nil
                    count = count + 1
                    loop_tbl[max_key] = tbl[max_key]
                    break
                end
                parent = tbl[parent].parent
            end
        end
    end
    return count, loop_tbl
end


local function print_tbl(tbl)
    for k, v in pairs(tbl) do
        print(k, v.parent)
    end
end

local function test()
    local new_tbl, loop_tbl = remove_parent(tbl)
    print(new_tbl)
    print("-------")
    print_tbl(loop_tbl)
    print("-------")
    print_tbl(tbl)
end

test()