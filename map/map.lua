map = {}
function map:createMap(fileName)
    function map:load()
        love.graphics.setDefaultFilter("nearest", "nearest")

        self.grid = {}
        self.spawnPoints = {}
        map:loadFromTxt()
        local gridWidth = #self.grid[1]
        local gridHeight = #self.grid
        tileSize = math.min(ScreenWidth / gridWidth, ScreenHeight / gridHeight)

        self.width = gridWidth * tileSize
        self.height = gridHeight * tileSize
        self.baseTileSize = baseTileSize
        self.tileset = love.graphics.newImage("map/map-layouts/map-tiles.png")
        self.tiles = {}
        self.tileRatio = ratio

        for i = 0, 10 do
            self.tiles[i] = love.graphics.newQuad(
                i * self.baseTileSize, 0, self.baseTileSize, self.baseTileSize, self.tileset:getDimensions()
            )
        end
    end

    -- Load map from txt
    function map:loadFromTxt()
        local contents, size = love.filesystem.read(fileName)
        if not contents then
            error("Failed to load map file: " .. fileName)
        end

        local rows = contents:split("\n")
        for y, row in ipairs(rows) do
            self.grid[y] = {}
            for x, tile in ipairs(row:split(",")) do
                local tileNumber = tonumber(tile)
                self.grid[y][x] = tileNumber
                if tileNumber == 99 then
                    -- Store spawn points as {x, y}
                    table.insert(self.spawnPoints, {x = x, y = y})
                end
            end
        end
    end

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
                local renderTile = tile
                if tile == 99 then
                    renderTile = 0
                end
    
                local quad = self.tiles[renderTile]
                if quad then
                    local drawX = (x - 1) * tileSize
                    local drawY = (y - 1) * tileSize
                    love.graphics.draw(self.tileset, quad, drawX, drawY, 0, tileSize / baseTileSize, tileSize / baseTileSize)
                end
            end
        end
    end

    return map
end
