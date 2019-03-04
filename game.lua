gems = {'A', 'B', 'C', 'D', 'E', 'F'}
ROWS = 10
COLS = 10
MATCH_IN_ROW = 3
grid = {}
score = 0
-- проверка что бы данные не выходили за рамки значений
local function canMove(x,y)
	return not (
	x < 1 or x > #grid or
	y < 1 or y > #grid[x])
end

-- испольется в основном цикле , а также на шаге генерации грида
local function checkAvailableMatch3()
-- Ищем так что бы эти совпадения были в каких то комбинациях
	local function checkSide(from,to)
		if to[2] < from[2] then
			local matchLeft = 1
			for k=1,3 do
				if canMove(to[1],to[2]-k) then
					if (grid[from[1]][from[2]] == grid[to[1]][to[2]-k]) then
						matchLeft = matchLeft + 1
					elseif (matchLeft == MATCH_IN_ROW) then
						return true
					else
						matchLeft = 1
					end
				else
					matchLeft = 1
				end
			end
		elseif to[2] > from[2] then
			local matchRight = 1
			for k=1,3 do
				if canMove(to[1],to[2]+k) then
					if (grid[from[1]][from[2]] == grid[to[1]][to[2]+k]) then
						matchRight = matchRight + 1
					elseif (matchRight == MATCH_IN_ROW) then
						print('+')
						return true
					else
						matchRight = 1
					end
				else
					matchRight = 1
				end
			end
		elseif to[1] < from[1] then
			local matchTop = 1
			for k=1,3 do
				if canMove(to[1]-k,to[2]) then
					if (grid[from[1]][from[2]] == grid[to[1]-k][to[2]]) then
						matchTop = matchTop + 1
					elseif (matchTop == MATCH_IN_ROW) then
						return true
					else
						matchTop = 1
					end
				else
					matchTop = 1
				end
			end
		elseif to[1] > from[1] then
			local matchBot = 1
			for k=1,3 do
				if canMove(to[1]+k,to[2]) then
					if (grid[from[1]][from[2]] == grid[to[1]+k][to[2]]) then
						matchBot = matchBot + 1
					elseif (matchBot == MATCH_IN_ROW) then
						return true
					else
						matchBot = 1
					end
				else
					matchBot = 1
				end
			end
		else
			return false
		end
	end
	
-- подготавливаемся для проверки
	local function isMatching()
		for i=1,ROWS do   
			for j=1,COLS do
				local current = {i, j}
				local left = {i, j-1}
				local right = {i, j+1}
				local top = {i-1, j}
				local bot = {i+1, j}
				if (canMove(left[1], left[2])) then
					if (checkSide(current,left)) then
						return true
					end
				end
				if (canMove(right[1], right[2])) then
					if (checkSide(current,right)) then
						return true
					end
				end
				if (canMove(top[1], top[2])) then
					if (checkSide(current,top)) then
						return true
					end
				end
				if (canMove(bot[1], bot[2])) then
					if (checkSide(current,bot)) then
						return true
					end
				end
				
			end
		end	
		
		return false
	end
	
	if isMatching() then
		return true
	else
		return false
	end
end

function init()
-- вспомогательная функция что бы не выходить за "рамки"

-- создаем таблицу
	for i=1,ROWS do
		grid[i] = {}     
		for j=1,COLS do
			grid[i][j] = ''
		end
	end	
	
	math.randomseed(os.time())
	math.random()
-- делаем построение поля так что бы небыло матч3
	local function checkMatch(y,x,v)
		-- проверка верхней стороны
		if (x > 2 and y < 3) then 
			if grid[y][x-1] == v then
				if(grid[y][x-2] == v) then
					local r = math.random(1, #gems)
					
					repeat
						r = math.random(1, #gems)
					until gems[r] ~= v
					
					return gems[r]
				else
					return v
				end
			else
				return v
			end	
		elseif (x < 3 and y > 2) then
		-- проверка левой стороны
			if grid[y-1][x] == v then
				if(grid[y-2][x] == v) then
					local r = math.random(1, #gems)
					
					repeat
						r = math.random(1, #gems)
					until gems[r] ~= v
					
					return gems[r]

				else
					return v
				end
			else
				return v
			end
		else
		-- общая часть
			if grid[y-1][x] == v and grid[y-2][x] == v  then
				local r = math.random(1, #gems)
				
				repeat
					r = math.random(1, #gems)
				until gems[r] ~= v
				
				if grid[y][x-1] == grid[y][x-2] then
					local rowReply = grid[y][x-2]
					
					repeat
						r = math.random(1, #gems)
					until gems[r] ~= v and gems[r] ~= rowReply
					return gems[r]
				else
					return gems[r]
				end				
				
			elseif grid[y][x-1] == v and grid[y][x-2] == v then
				local r = math.random(1, #gems)
				
				repeat
					r = math.random(1, #gems)
				until gems[r] ~= v
				
				if grid[y-1][x] == grid[y-2][x] then
					local rowReply = grid[y-2][x]
					
					repeat
						r = math.random(1, #gems)
					until gems[r] ~= v and gems[r] ~= rowReply
					return gems[r]
				else
					return gems[r]
				end
			else
				return v
			end
			
		end
		--
	end
-- генерируем поле
	local function rollGrid()
		for i=1,ROWS do
			for j=1,COLS do
				if i < 3 and j < 3 then
					local val = math.random(1, #gems)
					grid[i][j] = gems[val]
				else
					local val = math.random(1, #gems)
					local valz = gems[val]
					check = checkMatch(i,j,valz)
					grid[i][j] = check		
				end
			end
		end
	end
	-- получаем поле
	rollGrid()
	
	-- подбираем соответсвующее поле
	while true do
		if checkAvailableMatch3() then
			break
		else
			rollGrid()
		end
	end
end
-- ищем совпадения вынес отдельно тк используется в tick и input
local function match3()
	local countMatch = 1
	local matchX
	for i=1,ROWS do
		matchX = 1
		for j=1,COLS do
			local k = j + 1
			
			if(k == 11) then
				break
			end
			if (grid[i][j] == grid[i][k]) then
				matchX = matchX + 1
			elseif (matchX >= MATCH_IN_ROW) then
				for p=j-matchX+1, j do
				  grid[i][p] = '*'
				end
				matchX = 1
				countMatch = countMatch + 1
				
			else
				matchX = 1
			end
		end
	end
  
	local matchY
	for j=1,COLS do
		matchY = 1
		for i=1,ROWS do
			local k = i + 1

			if k ~= 11 and grid[i][j] == grid[k][j]  then
				matchY = matchY + 1
			elseif (matchY >= MATCH_IN_ROW) then
				for t=i-matchY+1, i do
					grid[t][j] = '*'
				end
				matchY = 1
				countMatch = countMatch + 1
			else
				matchY = 1
			end
		end
	end

	if countMatch > 1 then
		score = score + 1
		return true
	else
		return false
	end
end

-- визуализация
function dump()
	io.write('  ')
	for i=0,COLS-1 do
		io.write(' ' .. i)
	end
	io.write('\n')
	io.write('  ')
	for i=0,COLS-1 do
		io.write(' _')
	end
	io.write('\n')
	for i=1,ROWS do
		io.write (i-1 .. '|')
		for j=1,COLS do
			io.write(' ' ..grid[i][j])
		end
		io.write ('\n')
	end
	io.write ('\n')
end


-- перемещаем кристалы между ячейками

function move(from, to)

	local saveFrom = grid[from[1]][from[2]]
	grid[from[1]][from[2]] = grid[to[1]][to[2]]
	grid[to[1]][to[2]] = saveFrom
 
end

function tick()
	
	for j=1,COLS do
		for i=ROWS,2,-1 do
			local p = i - 1
			if (grid[i][j] == '*' and grid[p][j] ~= '*') then
				local k = i
				repeat
					if k == 10 then 
						break
					end
					local from = {k-1, j}
					local to = {k, j}
					move(from, to)
					k = k+1
				until not(grid[k][j] == '*' and k <= ROWS)
			end
		end
	end

	for i=1,ROWS do
		for j=COLS,1,-1 do
			if (grid[i][j] == '*') then
				X = math.random(1, 6)
				grid[i][j] = gems[X]
			end
		end
	end
  
	dump()
  
	if (match3()) then
		dump()
		print ('One more match \n')
		tick()
	end
  
end

-- обработка входящей строки
local function input(str)
	-- Прерываем если введен q 
	if str:sub(1,1) == 'q' then
		return
	end

	-- проверяем введеные значения
	if not (
		str:sub(1,1) == 'm' and
		canMove(str:sub(3,3) + 1, str:sub(5,5) + 1) and
		str:sub(7,7) == 'l' or str:sub(7,7) == 'r' or
		str:sub(7,7) == 'u' or str:sub(7,7) == 'd') then
		
print ([[
Error!
Retry input 
	]])
		return
	end
  
-- получаем кординаты "прибытия"
	local from = {tonumber(str:sub(5,5)) + 1,tonumber(str:sub(3,3)) + 1}
	local to =  {tonumber(str:sub(5,5)) + 1,tonumber(str:sub(3,3)) + 1}
	if (str:sub(7,7) == 'l') then
		to[2] = to[2] - 1 
	elseif (str:sub(7,7) == 'r') then
		to[2] = to[2] + 1 
	elseif (str:sub(7,7) == 'u') then
		to[1] = to[1] - 1
	elseif (str:sub(7,7) == 'd') then
		to[1] = to[1] + 1
	end
  
	if not (canMove(to[1], to[2])) then
		dump()
		print ([[
		Error!
		Retry input 
		]])
		return
	end
	
	move(from, to)
	if(match3()) then	
		dump()
		tick()
	else
		move(from, to)
		dump()
		print('no match, pls try again')
	end
end

function mix()
  init()
end

init()
dump()

print ([[ 
Input command : m x y a 
m - move
x - row 
y - col 
a - action -> l - left r - right u - up d - down
example: m 0 0 r
	]])
local str 

while str ~= 'q' do
	if checkAvailableMatch3() then
		print('Has been find 3 in row/cell gem')
	else
		print('3 in row/cell gem not avalable ')
		mix()
	end
	print('Score:'..score)
	print ('Input row-cell:')
	str = io.read()
	input(str)
end






