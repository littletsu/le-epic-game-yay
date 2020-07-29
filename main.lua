level = 1
deaths = 0



function love.load(t)
 
    love.window.setMode(650, 650)
    love.window.setTitle("le epic game yay")
    love.window.setIcon(love.image.newImageData("res/icon.png"))
    world = love.physics.newWorld(0, 200, true)
        world:setCallbacks(beginContact, endContact, preSolve, postSolve)
 
    deathBlocks = {}
    
    ball = {}
        respawnBall()

    lastPosX = 650/2-200
    lastPosY = 650/2-200
    for i = 1,math.floor( love.math.random(1, level * 2) ),1 do
        if not (i > 9) then
            lastPosX = lastPosX + 50
            lastPosY = lastPosY + 50 
            local static = {}
            static.b = love.physics.newBody(world, lastPosX,lastPosY, "static")
            static.s = love.physics.newRectangleShape(200,20)
            static.f = love.physics.newFixture(static.b, static.s)
            static.f:setUserData("DeathBlock")
            static.defaultPosX = lastPosX
            static.defaultPosY = lastPosY
            table.insert(deathBlocks, static)
        end
    end
    
    
    
    finishLevel = {}
    finishLevel.b = love.physics.newBody(world, 560, 650, "static")
    finishLevel.s = love.physics.newRectangleShape(100,50)
    finishLevel.f = love.physics.newFixture(finishLevel.b, finishLevel.s)
    finishLevel.f:setUserData("FinishBlock")
    alive = true
    status = ""
    shouldMoveRight = true
    
    
end
 
function respawnBall() 
    
    ball.b = love.physics.newBody(world, 650/2, 650/2-200, "dynamic")
    ball.b:setMass(60*2)
    ball.s = love.physics.newCircleShape(30)
    ball.f = love.physics.newFixture(ball.b, ball.s)
    ball.f:setRestitution(0.4)    -- make it bouncy
    ball.f:setUserData("Ball")
end

function love.update(dt)
    --love.filesystem.load("main.lua")()

    world:update(dt)
    if alive then
        if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
            ball.b:applyForce(1000, 0)
        elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
            ball.b:applyForce(-1000, 0)
        end
        if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
            ball.b:applyForce(0, -5000)
        elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
            ball.b:applyForce(0, 1000)
        end        
    end

    if love.keyboard.isDown("f") then
        
        if alive then ball.b:destroy() end
        respawnBall()
        for k,v in pairs(deathBlocks) do 
            v.b:setPosition(v.defaultPosX, v.defaultPosY)
        end
        status = ""
        alive = true
    end

    for k,v in pairs(deathBlocks) do
        if shouldMoveRight then
            if not (v.b:getX() > 600) then
                v.b:setPosition(v.b:getX() + 1, v.b:getY())
            else 
                shouldMoveRight = false
            end  
        else 
            if not (v.b:getX() < 100) then
                v.b:setPosition(v.b:getX() - 1, v.b:getY())
            else 
                shouldMoveRight = true
            end
        end
    end

end
 
function love.draw()
    if alive then
        love.graphics.circle("fill", ball.b:getX(),ball.b:getY(), ball.s:getRadius(), 20)
    end
    love.graphics.setColor(255,0,0)
    for k, v in pairs(deathBlocks) do
        love.graphics.polygon("fill", v.b:getWorldPoints(v.s:getPoints()))
    end
    love.graphics.setColor(0,255,0)
    love.graphics.polygon("fill", finishLevel.b:getWorldPoints(finishLevel.s:getPoints()))
    love.graphics.setColor(255,255,255)
    love.graphics.print(status, 650/2-80, 650/2-80)
    love.graphics.print("Level " .. level, 20, 20)
    love.graphics.print("Deaths: " .. deaths, 20, 620)
end
 
function love.quit()
    
end

function beginContact(a, b, coll)
    if a:getUserData() == "DeathBlock" then 
        alive = false
        ball.b:destroy()
        status = "u ded, press f to respawn."
        deaths = deaths + 1

    else 
        love.load()
        level = level + 1
        
    end
end
 
function endContact(a, b, coll)

end
 
function preSolve(a, b, coll)

end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)

end
