map = {}

function map:createMap(fileName)
    function map:load()
        self.height = screenHeight
        self.width = screenWidth
        self.contents, size = love.filesystem.read(fileName, all)
        print(self.contents)
    end
    
    function map:update()
        
    end
    
    function map:draw()

    end

    return map
end
