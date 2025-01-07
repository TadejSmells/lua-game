map = {}

function map:createMap(fileName)
    function map:load()
        self.height = screenHeight
        self.width = screenWidth
        self.grid = {}
        map:loadFromTxt()

        self.tileSize = 32
        self.tileset = love.graphics.newImage("map/map-layouts/map-tiles.png")
        self.tiles = {}

        for i = 0, 5 do
            self.tiles[i] = love.graphics.newQuad(
                i * self.tileSize, 0 , self.tileSize, self.tileSize, self.tileset:getDimensions()
            )
        end
    end
    
    -- load map from txt
    function map:loadFromTxt()
        local contents, size = love.filesystem.read(fileName)
        print(contents)
        if not contents then
            error("Failed to load map file: " .. fileName)
        end
    
        local rows = contents:split("\n")
        for y, row in ipairs(rows) do
            self.grid[y] = {}
            for x, tile in ipairs(row:split(",")) do 
                self.grid[y][x] = tonumber(tile)
            end
        end
    end

    -- seperate different tile numbers based on spaces and ,
    function string:split(sep)
        local fields = {}
        self:gsub("([^" .. sep .. "]+)", function(c) fields[#fields + 1] = c end)
        return fields
    end


    function map:update(dt)
        
    end
    
    function map:draw()
        for y, row in ipairs(self.grid) do
            for x, tile in ipairs(row) do
                local quad = self.tiles[tile]
                if quad then
                    love.graphics.draw(self.tileset, quad, (x - 1) * self.tileSize, (y - 1) * self.tileSize)
                end
            end
        end
    end

    return map
end
