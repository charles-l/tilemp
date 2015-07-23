-- run love from within '.', but include tilemp.lua
package.path = package.path .. ";../?.lua"
tilemp = require '../tilemp'

function love.load()
    rects = {}
    local tilesheet = love.graphics.newImage('an_image.gif')
    tilemp.bind('^', tilesheet, love.graphics.newQuad(0, 0, 16, 16, tilesheet:getDimensions()))
    tilemp.bind('|', tilesheet, love.graphics.newQuad(0, 18, 16, 16, tilesheet:getDimensions()))
    tilemp.bind('#', tilesheet, love.graphics.newQuad(1, 52, 16, 16, tilesheet:getDimensions()))
    tilemp.bind('@', tilesheet, love.graphics.newQuad(86, 35, 16, 16, tilesheet:getDimensions()))
    tilemp.bind('e', function(x, y)
        r = {}
        r.w = 16
        r.h = 16
        r.x = x * r.w
        r.y = y * r.h
        table.insert(rects, r)
    end)
    tilemp.parse('test')
    print(tilemp.get_tile(0, 0)) -- access the (0,0) tile. This is in terms of tiles not pixels.
end

function love.draw()
    tilemp.drawTiles()
    for _,r in pairs(rects) do
        love.graphics.rectangle('line', r.x, r.y, r.w, r.h)
    end
end
