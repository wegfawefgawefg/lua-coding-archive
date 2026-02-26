function love.load()
	screen = {}
	screen.x = 0
	screen.y = 0
	screen.xs = 1
	screen.ys = 1
	screen.xr = 256
	screen.yr = 256

	love.window.setMode(screen.xr,screen.yr)
	love.graphics.setDefaultFilter("nearest","nearest")
	scale = 4
	seed = 0
	height = 1
	detail = 6
	changed = true
	view = love.graphics.newCanvas()
	function getHeightMap(x,y,seed,scale,detail)
		return(
			(love.math.noise( x/(screen.xr/scale) , (y/(screen.yr/scale)) , seed )*0.75) + ( love.math.noise( x/(screen.xr/(scale*detail)) , (y/(screen.yr/(scale*detail))) , seed*2 )*0.25 )
		)
	end
	require 'bit'
	function rand(x, y, seed)
	  local ix = math.floor(x)
	  local iy = math.floor(y)
	  local s = seed + ix * 374761393 + iy * 668265263
	  s = bit.bxor(s, bit.rshift(s, 13)) * 1274126177 
	  return (bit.bxor(s, bit.rshift(s, 16)) % 65536) / 65536
	end

end

function love.update()
	function love.wheelmoved(x,y)
		changed = true
		if y > 0 then
			height = height + 1
		end
		if y < 0 then
			if height > 1 then
				height = height - 1
			end
		end
	end
	if love.mouse.isDown(1) then
		seed = seed + math.random(1,100)
		changed = true
	end
	if love.mouse.isDown(2) then
		seed = seed - math.random(1,100)
		changed = true
	end
end

function love.draw()
	love.graphics.clear(0,0.75*(-math.cos(love.timer.getTime()/4)),0.875*(-math.cos(love.timer.getTime()/4)))
	love.graphics.setColor(1,0.25,0.125)
	love.graphics.circle("fill",(screen.xr/2)+(math.sin(love.timer.getTime()/4)*((screen.xr+screen.yr)/6)),(screen.yr/2)+(math.cos(love.timer.getTime()/4)*((screen.xr+screen.yr)/6)),(screen.xr+screen.yr)/16)
	love.graphics.setColor(1,1,0.875)
	love.graphics.circle("fill",(screen.xr/2)+(-math.sin(love.timer.getTime()/4)*((screen.xr+screen.yr)/6)),(screen.yr/2)+(-math.cos(love.timer.getTime()/4)*((screen.xr+screen.yr)/6)),(screen.xr+screen.yr)/16)
	if changed == true then
		love.graphics.setCanvas(view)
		love.graphics.clear(0,0,0,0)
		for x = 1,screen.xr do
			for y = 1,screen.yr do
				local mappy = getHeightMap(x,y,seed,scale,detail)
				love.graphics.setColor(0,0.125,0.75,0.6)
				love.graphics.points((x-1),(y/2)+(screen.yr/2)-(0.6*height)+(height/2))
				if mappy > 0.652 then
					love.graphics.setColor(0,0.75,0,1)
				else
					love.graphics.setColor(1,0.75,0,1)
				end
				love.graphics.points((x-1),(y/2)+(screen.yr/2)-(mappy*height)+(height/2))
				if rand(x,y,seed) > 0.8 and mappy > 0.7 then
					love.graphics.setColor(0,0,0,1)
					love.graphics.line((x-1),(y/2)+(screen.yr/2)-(mappy*height)+(height/2),(x-1),(y/2)+(screen.yr/2)-((mappy+0.025)*height)+(height/2))
				end
			end
		end
		love.graphics.setColor(1,1,1,1)
		love.graphics.setCanvas()
		changed = false
	end
	love.graphics.setColor((-math.cos(love.timer.getTime()/4)),(-math.cos(love.timer.getTime()/4)),0.5 + ((-math.cos(love.timer.getTime()/4)))/2)
	love.graphics.draw(view)
	love.graphics.print(love.timer.getFPS())
end