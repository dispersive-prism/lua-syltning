-- Just a temporary file storing/reading levels in a comma separated fashion
-- Will probably be moved to worldMap later on...

function saveBackground(fileName, background)
    local f = assert(io.open(fileName, "w"))
    f:write(#background, ",", #background[1], ",")
    for i = 1, #background do
        for j = 1, #background[1] do
            if (i == #background and j == #background[1]) then
                f:write(t[i][j])
            else
                f:write(t[i][j], ",")
            end
        end
    end

    f:close()
end

function loadBackground(fileName)
    local q = assert(io.open(fileName, "r"))
    all = q:read()
    q:close()

    local data = {}

    for number in string.gmatch(all, "%d+") do table.insert(data, number) end

    local xDim = data[1]
    local yDim = data[2]

    local available = #data

    local readT = {}
    for i = 1, xDim do
        readT[i] = {}
        for j = 1, yDim do
            readT[i][j] = data[#data - available + 3]
            available = available - 1
        end
    end
    
    -- Will return more tables/backgrounds/data in the future
    return readT
end


--[[
t = { {1, 20}, {10, 20}, {30, 40} }
--print(#t)


saveBackground("test.txt", t)
iRead = loadBackground("test.txt")

for i = 1, #iRead do
    print(table.unpack(iRead[i]))
end
--]]

