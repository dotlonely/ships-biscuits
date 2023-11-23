pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

amp_max = 2
amp_min = .25
freq_max = 256
freq_min = 12

-- color swapping --
aquamarine = pal(3, 131, 1)
midnight = pal(4, 129, 1)
royal = pal(11, 140, 1)


wave_max = 10
cloud_max = 125


 -- sun vars and methods --
sun_posx = 64
sun_posy = 64
sun_rad = 20
sun_col = 9
sun_speed = .1

function update_sun()
	sun_posy = 3*(sin((1/12) * time())) + 96
	if sun_posx > 128+20 then
		sun_posx = 0 - sun_rad
	end
end
 
function draw_sun()
	circfill(sun_posx, sun_posy,sun_rad * 1.1 , 7)
	circfill(sun_posx, sun_posy,sun_rad, 10)
	circfill(sun_posx, sun_posy,sun_rad * .90, 9)
end

 ------------------------

function make_raindrop(x, y)
	add(rain, {
		posx = x,
		posy = y,
		update = function(self)
			y += 1 * .5
			if y % 2 != 0 then
			 x -= 1 * .01  
			else
			 x += 1 * .01 
			end
			if y > 128 then del(self) end 
		end,
		draw = function(self)
		 pset(x, y, 6)	
		end,
	})
end

function make_wave(a, f)
	add(waves, {
		amp = a,
		freq = f,
		y = 0,
	})	
end

function make_cloud(x, y, r)
	add(clouds, {
	 posx = x,
	 posy = y,
	 rad = r,
	 update = function(self)
	 	x -= 1 * .1
	 	if x+r < 0 then 
	 		x = 128+r 
	 		r = rnd(10) + 1
	 	end
	 end,
		draw = function(self)
			if y > 42 then 
				circfill(x, y, r, 2)
			elseif y > 32 then
				circfill(x, y, r, 8)
			elseif y > 24 then
				circfill(x, y, r, 14)
			elseif y > 16 then
				circfill(x, y, r, 15)
			else
				circfill(x, y, r, 7)
			end
		end		
	})
end

function _init()	
	rain = {}
	clouds = {}
 waves = {}
 
	for x=1,wave_max, 1 do
		make_wave(rnd(amp_max) + amp_min, rnd(freq_max) + freq_min)
	end 
	
	for x=1,cloud_max, 1 do
		make_cloud(rnd(128), rnd(48), rnd(10) + 1)	
	end

end


function _update()
	for c in all(clouds) do
		c.update()
	end
	
	for x=1,1, 1 do
		make_raindrop(rnd(128), rnd(0) + 24)
	end
	
	for r in all(rain) do
		r.update()
	end
	
	
	update_sun()
	
end


function _draw()
	cls(12)
	
	draw_sun()
	
	for r in all(rain) do
		r.draw()
	end

	for c in all(clouds) do
		c.draw()
	end
	
	
	-- draw ocean --
	col_deep = 1
	col_mid = 5
	col_top = 13
	col_highlight = 7
	wave_color = 12
	origin = 96
	sum = 0
	
	for x=0,128, 1 do
		sum = 0
	 for y=1,wave_max,1 do 
		 waves[y].y = waves[y].amp*(sin(x/waves[y].freq + time()*.05))
		 sum = sum + waves[y].y
		end		
		
		-- lilac --
		line(x, sum + origin, x, 128, col_top)	

		-- aquamarine --
		line(x, (sum * .95) + origin + 2, x, 128,aquamarine)

  -- white highlight --
		pset(x, sum + origin, col_highlight)			
		
		-- deep blue --
		line(x, (sum * .85) + origin + 6,x, 128, 1)	
		
		-- midnight -- draw 2nd last
		line(x, (sum * .75) + origin + 8,x, 128, midnight)
		
		-- black -- draw last
		line(x, (sum * .25) + origin + 32, 0)
	
		
	end
	----------------
	print("ships biscuits", 38, 56, 7)
	
	
end	
	
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000005000050000500005000050000500005000050000500005000050000500005004050030500305003050020500205003050040500405008050000500005000050000500005000050000500005000050
__music__
00 01424344

