class UnionFind
	def initialize(size)
		@arr = (0...size).to_a
		@size = Array.new(size, 1)
	end

	def root(x)
		original_x = x
		until @arr[x] == x
			x = @arr[x]
		end
		@arr[original_x] = x
		x
	end

	def connected?(x, y)
		root(x) == root(y)
	end

	def union(x, y)
		rootX = root(x)
		rootY = root(y)

		if @size[rootX] > @size[rootY]
			@arr[rootY] = rootX
			@size[rootX] += @size[rootY]
		else
			@arr[rootX] = rootY
			@size[rootY] += @size[rootX]
		end
	end
end