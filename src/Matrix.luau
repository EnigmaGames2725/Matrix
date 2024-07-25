local Matrix = {}
local Row = {}

Row.__index = Row
Matrix.__index = Matrix

Matrix.__tostring = function(self)
	local s = ""

	for i, Row in self do
		if typeof(Row) == "table" then
			for _, Column in Row do
				s ..= Column .. " "
			end
			s ..= "\n"
		end
	end

	return s
end

Matrix.__add = function(self: {[number]: {any}, Columns: number, Rows: number}, Value)
	if typeof(Value) == "table" and self.Rows == Value.Rows and self.Columns == Value.Columns then
		for r = 1, self.Rows do
			for c = 1, self.Columns do
				self[r][c] += Value[r][c]
			end
		end
	elseif typeof(Value) == "number" then
		for r = 1, self.Rows do
			for c = 1, self.Columns do
				self[r][c] += Value
			end
		end
	end
	
	return self
end

Matrix.__sub = function(self: {[number]: {any}, Columns: number, Rows: number}, Value)
	if typeof(Value) == "table" and self.Rows == Value.Rows and self.Columns == Value.Columns then
		for r = 1, self.Rows do
			for c = 1, self.Columns do
				self[r][c] -= Value[r][c]
			end
		end
	elseif typeof(Value) == "number" then
		for r = 1, self.Rows do
			for c = 1, self.Columns do
				self[r][c] -= Value
			end
		end
	end

	return self
end

Matrix.__mul = function(self: {[number]: {any}, Columns: number, Rows: number }, Value)
	if typeof(Value) == "number" then
		for r = 1, self.Rows do
			for c = 1, self.Columns do
				self[r][c] *= Value
			end
		end
	elseif typeof(Value) == "table" then
		if Value.Rows == self.Columns then
			local New = Matrix.new(self.Rows, Value.Columns)
			
			for r = 1, New.Rows do
				for c = 1, New.Columns do
					local s = 0
					for i = 1, self.Columns do
						s += self[r][i] * Value[i][c]
					end
					New[r][c] = s
				end
			end
			
			return New
		end
	end

	return self
end

Row.__add = function(self: {number}, Value)
	if typeof(Value) == "number" then
		for i = 1, #self do
			self[i] += Value
		end
	elseif typeof(Value) == "table" then
		for i = 1, #self do
			self[i] += Value[i]
		end
	end
	
	return self
end

Row.__sub = function(self: {number}, Value)
	if typeof(Value) == "number" then
		for i = 1, #self do
			self[i] -= Value
		end
	elseif typeof(Value) == "table" then
		for i = 1, #self do
			self[i] -= Value[i]
		end
	end

	return self
end

Row.__mul = function(self: {number}, Value)
	if typeof(Value) == "number" then
		for i = 1, #self do
			self[i] *= Value
		end
	elseif typeof(Value) == "table" then
		for i = 1, #self do
			self[i] *= Value[i]
		end
	end

	return self
end

Row.__div = function(self: {number}, Value)
	if typeof(Value) == "number" then
		for i = 1, #self do
			self[i] /= Value
		end
	elseif typeof(Value) == "table" then
		for i = 1, #self do
			self[i] /= Value[i]
		end
	end

	return self
end

Row.__idiv = function(self: {number}, Value)
	if typeof(Value) == "number" then
		for i = 1, #self do
			self[i] //= Value
		end
	elseif typeof(Value) == "table" then
		for i = 1, #self do
			self[i] //= Value[i]
		end
	end

	return self
end

function Matrix.new(rows: number, columns: number, ...: number?)
	local Class = {}
	Class.Rows = rows
	Class.Columns = columns
	
	local Values = table.pack(...)
	local Index = 1
	
	for r = 1, rows do
		local row = {}
		
		for c = 1, columns do
			row[c] = Values[Index] or 0
			Index += 1
		end
		
		Class[r] = setmetatable(row,Row)
	end
	
	return setmetatable(Class, Matrix)
end

return Matrix
