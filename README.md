lua-snapshot
============

Make a snapshot for lua state to detect memory leaks.

See dump.lua for example.

Build
=====

make linux

or

make mingw (in windows)

or

make macosx


tutorial
===

如下示例:

~~~.lua
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
~~~

在需要做快照的地方调用`start_snapshot`, 结尾处调用`dstop_snapshot([count])`, 其中count为要打印的对象个数，不填的话会全部打印。
`dstop_snapshot` 会列出从`start_snapshot`开始到结束创建出来的仍然被持有的对象,结果会根据size按照从小到大排序.

执行输出结果:
```
$ lua dump.lua
----------------- diff snapshot ------------------
[1] (T)    Root->(T)[registry]->(S)[1]->(T)lss{#dump.lua:0}->(L@./lsnapshot.lua:125)dstop_snapshot->(T)begin_s size:2.0546875Kb
[2] (T)    Root->(T)[registry]->(S)[1]->(T)k{#dump.lua:0} size:0.0546875Kb
[3] (T)    Root->(T)[registry]->(S)[1]->(T)tmp{#dump.lua:0} size:0.0546875Kb
[4] (T)    Root->(T)[registry]->(S)[1]->(T)sss{#dump.lua:0} size:0.0546875Kb
[5] (L@dump.lua:9)    Root->(T)[registry]->(S)[1]->(L@dump.lua:9)foo{#dump.lua:0} size:0.0390625Kb
--------------- all size:2.2578125Kb ---------------
``` 
其中`[X]`为索引, 第二个字段包含`(T/U/L/C/S)`.
* `(T)`表示的为table 类型
* `(U)`表示userdata 类型
* `(L)`表示lua function类型
* `(C)`表示cfunction 类型
* `(S)`表示thread 类型
* `(A)`表示string 类型

第三个为fullpath路径. `size:1234.5678Kb` 表示的为改对象占用的大小

