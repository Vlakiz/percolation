class UnionFind
	def initialize(size)
		@arr = (0...size).to_a
		@size = Array.new(size, 1)
	end

	def root(x)
		until @arr[x] == x
			@arr[x] = @arr[@arr[x]]
			x = @arr[x]
		end
		x
	end

	def connected?(x, y)
		root(x) == root(y)
	end

	def union(x, y)
		rootX = root(x)
		rootY = root(y)

		if rootX == rootY
			return
		elsif @size[rootX] < @size[rootY]
			@arr[rootX] = rootY
			@size[rootY] += @size[rootX]
		else
			@arr[rootY] = rootX
			@size[rootX] += @size[rootY]
		end
	end
end