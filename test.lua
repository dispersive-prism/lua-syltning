-- Create a 2d table
table = require("lib.tileset")

tileset = table:init(10, 10)
tileset[10][2] = 1
print(tileset[10][2])

test = {{}}


for i = 1, 10 do
    test[i] = {}
    for j = 1, 10 do
        test[i][j] = 0
    end
end

test[3][10] = "hej"

-- print(test[1][10])
