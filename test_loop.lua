local tbl = {
    ["a"] = {addr = "a", mem = 100, key = "a", parent = "x"},
    ["b"] = {addr = "b", mem = 100, key = "b", parent = "c"},
    ["c"] = {addr = "c", mem = 100, key = "c", parent = "a"},
    ["x"] = {addr = "x", mem = 100, key = "x", parent = 'b'},

    ["d"] = {addr = "d", mem = 100, key = "d", parent = "e"},
    ["e"] = {addr = "e", mem = 100, key = "e", parent = nil},

    ["f"] = {addr = "f", mem = 100, key = "f", parent = "g"},
    ["g"] = {addr = "g", mem = 100, key = "g", parent = "f"},
    
    ["y"] = {addr = "y", mem = 100, key = "y", parent = nil},
    ["z"] = {addr = "z", mem = 100, key = "z", parent = "y"},
    ["i"] = {addr = "i", mem = 100, key = "i", parent = "y"},
}

-- 断开环结构
local function remove_circle_parent(tbl)
    local loop_tbl = {}
    local count = 0
    local cache = {}
    for k, v in pairs(tbl) do
        local circle = {[v.addr] = true}

        if not cache[k] then
            cache[k] = true
            local parent = v.parent
            
            local max_key = k
            while parent do
                if max_key < parent then
                    max_key = parent
                end
                cache[parent] = true
                if parent == k then  -- 纯环，断开最大地址的parent
                    tbl[max_key].parent = nil  -- 断开
                    count = count + 1
                    loop_tbl[max_key] = tbl[max_key]
                    break
                end

                if circle[parent] then  -- 有环，断开环的最后一个
                    tbl[parent].parent = nil  -- 断开
                    count = count + 1
                    loop_tbl[k] = tbl[k]
                    break
                end

                circle[parent] = true
                parent = tbl[parent].parent
                print("weiyg circle", k, parent)
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
    local new_tbl, loop_tbl = remove_circle_parent(tbl)
    print(new_tbl)
    print("-------")
    print_tbl(loop_tbl)
    print("-------")
    print_tbl(tbl)
end

test()
