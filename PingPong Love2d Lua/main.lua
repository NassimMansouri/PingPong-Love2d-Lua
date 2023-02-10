function love.load()
	love.window.setMode(960,680)
	player = {}
	enemy = {}
	ball = {}

	ball.radius = 10
	ball.x = (love.graphics.getWidth() / 2 - ball.radius / 2) 
	ball.y = love.graphics.getHeight() / 2 - ball.radius / 2
	ball.speedx = 0
	ball.speedy = 0
	ball.sprite = love.graphics.newImage('ball.png')
	love.graphics.scale(0.1, 0.1)

	player.x = love.graphics.getWidth() - 20 
	player.y = love.graphics.getHeight() / 4
	player.h = love.graphics.getHeight() / 5
	player.w = 10 
	player.speed = 5

	enemy.x = 10
	enemy.y = love.graphics.getHeight() / 4
	enemy.h = love.graphics.getHeight() / 5
	enemy.w = 10 
	enemy.speed = 7

	Font = love.graphics.newFont(30)
	timer_font = love.graphics.newFont(40)
	menuFont = love.graphics.newFont(30)
	player_score = 0
	enemy_score = 0

	menu = true
	menu_text = "Press Space to begin the game!"
	timer = 0

	collisionSound = love.audio.newSource("pling.wav", "static")
	scoreSound = love.audio.newSource("score.wav", "static")

end

function love.update(dt)
	if timer > 0 then
        timer = timer - dt
        ball.x = love.graphics.getWidth() / 2 - ball.radius / 2 - 15
		ball.y = love.graphics.getHeight() / 2 - ball.radius / 2

    else
        timer = 0
    end
	random = 0.9+(1.1-0.9)*math.random()
	ball.x = ball.x + ball.speedx
	ball.y = ball.y + ball.speedy 
	screenCollision()
	movement()
	playerCollisions()
	enemyCollisions()
	enemyMovement()

end

function love.draw()
	if menu then 
	love.graphics.setColor(love.math.colorFromBytes(245,245,245))
	love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
	love.graphics.setFont(menuFont)
	love.graphics.setColor(love.math.colorFromBytes(66,66,66))
	love.graphics.print(menu_text,love.graphics.getWidth()/4,love.graphics.getHeight()/3)
	else
	love.graphics.setColor(255,255,255)
	--love.graphics.circle("fill", ball.x, ball.y, ball.radius)
	love.graphics.draw(ball.sprite, ball.x, ball.y, angle, 0.09, 0.09)
	love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
	love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.w, enemy.h)
	love.graphics.rectangle("fill", love.graphics.getWidth()/2, 0, 1, love.graphics.getHeight())
	love.graphics.setFont(Font)
	love.graphics.print(player_score,2 * love.graphics.getWidth()/3,50)
	love.graphics.print(enemy_score,love.graphics.getWidth()/3,50)
	if timer > 0 then
		love.graphics.setColor(love.math.colorFromBytes(132, 156, 194))
		love.graphics.setFont(timer_font)
		love.graphics.print(math.ceil(timer), love.graphics.getWidth() / 2 - 12 , love.graphics.getHeight() / 3)
	end
end


end

-- Game functions
function screenCollision()
	-- Bottom
	if ball.y > love.graphics.getHeight() then
		ball.speedy = ball.speedy * (-1) * random
		collisionSound:play()
	end
	-- Right
	if ball.x > love.graphics.getWidth() then
		ball.speedx = ball.speedx * (-1) * random
		ball.x = love.graphics.getWidth() / 2 - ball.radius / 2
	 	ball.y = love.graphics.getHeight() / 2 - ball.radius / 2
	 	enemy_score = enemy_score + 1
	 	timer = 3
	 	scoreSound:play()
	end
	-- Left
	if ball.x < 0 then
		ball.speedx = ball.speedx * (-1) * random
		ball.x = love.graphics.getWidth() / 2 - ball.radius / 2
		ball.y = love.graphics.getHeight() / 2 - ball.radius / 2
		player_score = player_score + 1
		timer = 3
		scoreSound:play()
	end
	-- Top
	if ball.y < 0 then 
		ball.speedy = ball.speedy * (-1) * random
		collisionSound:play()
	end

end
function movement()
	if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
		player.y = player.y + player.speed
	end
	if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
		player.y = player.y - player.speed
	end
	if player.y > love.graphics.getHeight() - player.h then
		player.y = player.y - player.speed
	end
	if player.y < 0  then
		player.y = player.y + player.speed
	end
end
function playerCollisions()
	if (player.x < ball.x + ball.radius and player.x + player.w > ball.x and player.y < ball.y + ball.radius and player.y + player.h > ball.y) then
		ball.speedx = ball.speedx * (-1) * random
		collisionSound:play()
	end
end
function enemyCollisions()
	if (enemy.x < ball.x + ball.radius and enemy.x + enemy.w > ball.x and enemy.y < ball.y + ball.radius and enemy.y + enemy.h > ball.y) then
		ball.speedx = ball.speedx * (-1) * random
		collisionSound:play()
		
	end
	if enemy.y > love.graphics.getHeight() - enemy.h then
		enemy.y = enemy.y - enemy.speed
	end
	if enemy.y < 0  then
		enemy.y = enemy.y + 3
	end
end
function enemyMovement()
	if ball.x < love.graphics.getWidth() / 2 then
		if enemy.y > ball.y then 
			enemy.y = enemy.y - enemy.speed
		end
		if enemy.y < ball.y then
			enemy.y = enemy.y + enemy.speed
		end
	end
end

function love.keypressed(key, scancode, isrepeat)
   if key == "space" then
      timer = 3
      ball.speedx = 10
	  ball.speedy = 3
	  player_score = 0 
	  enemy_score = 0
	  menu = not menu

   end
end
