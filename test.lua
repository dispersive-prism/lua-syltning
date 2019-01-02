t = { {1, 20}, {10, 20}, {30, 40} }
print(#t)
print(#t[1])
print(t[1][1])

local f = assert(io.open("test.txt", "w"))
f:write(#t, ",", #t[1], ",")
for i = 1, #t do
    for j = 1, #t[1] do
        if (i == #t and j == #t[1]) then
            f:write(t[i][j])
        else
            f:write(t[i][j], ",")
        end
    end
end

f:close()


local q = assert(io.open("test.txt", "r"))
all = q:read()
q:close()

data = {}

for number in string.gmatch(all, "%d+") do table.insert(data, number) end

-- Two first digits are x and y dimensions of the array
xDim = data[1]
yDim = data[2]

-- Iterate and create table
available = #data -- 10 

readT = {}
for i = 1, xDim do
    readT[i] = {}
    for j = 1, yDim do
        -- 10 - 10 + 3 = 2
        -- 10 - 9 + 3 = 3
        readT[i][j] = data[#data - available + 3]
        available = available - 1
    end
end

for i = 1, #readT do
    print(table.unpack(readT[i]))
end


--[[local f = assert(io.open("test.txt", "w"))
for i = 1, #t do
    if(i ~= #t) then
        f:write(t[i], ",")
    else
        f:write(t[i])
    end
end
f:close()

local f = assert(io.open("test.txt", "r"))
iRead = f:read()
print(iRead)
f:close()]]--