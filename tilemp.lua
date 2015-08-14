local tilemp = {}

local handlers = {funcs = {}, imgs = {}}

local function sample(table)
    return table[math.random(1, #table)]
end

function tilemp.get_tile(x, y)
    -- TODO: make this smarter
    for _, v in pairs(handlers.imgs) do
        for _, i in pairs(v.instances) do
            if i.x == x and i.y == y then
                return i
            end
        end
    end
    return nil
end

function tilemp.bind(c, bindee, quad)
    -- Generic
    if type(bindee) == 'function' then handlers.funcs[c] = bindee; return end

    -- Assuming Love2D images for now...
    if type(bindee) == 'userdata' and bindee:type() == 'Image' then
        if quad == nil then error("quad must be defined for tilemap!", 2); return end
        handlers.imgs[c] = {}
        handlers.imgs[c].instances = {}
        handlers.imgs[c].img = bindee
        handlers.imgs[c].quad = quad
    end
end

function tilemp.parse(filename)
    local y = 0
    for l in io.lines(filename) do
        local x = 0
        for c in string.gmatch(l, '.') do
            if handlers.funcs[c] ~= nil then
                handlers.funcs[c](x, y)
            elseif handlers.imgs[c] ~= nil then
                local ins = {}
                local _, _, w, h = handlers.imgs[c].quad:getViewport()
                ins.x = x * w
                ins.y = y * h
                table.insert(handlers.imgs[c].instances, ins)
            end
            x = x + 1
        end
        y = y + 1
    end
end

function tilemp.drawTiles()
    for _, e in pairs(handlers.imgs) do
        for _, i in pairs(e.instances) do
            love.graphics.draw(e.img, e.quad, i.x, i.y)
        end
    end
end

function tilemp.raw_map(filename)
    local map = {}
    for l in io.lines(filename) do
        local r = {}
        for c in string.gmatch(l, ".") do
            table.insert(r, c)
        end
        table.insert(map, r)
    end
    return map
end

return tilemp
