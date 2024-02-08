require 'pry'

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

class PercolationTable
	def initialize(size)
		raise "Incorrect size" if size < 3

		@size = size
		@table_size = size**2
		@closed_cells = (0...@table_size).to_a.shuffle
		@uf = UnionFind.new(@table_size + 2)

		first_line.each do |i|
			@uf.union(i, @table_size)
		end

		second_line.each do |i|
			@uf.union(i, @table_size + 1)
		end
	end

	def percolated?
		@uf.connected?(@table_size, @table_size + 1)
	end

	def render
		(0...@size**2).each do |i|
			print @closed_cells.include?(i) ? '■' : '□'
			print ((i + 1) % @size) == 0 ? "\n" : ' '
		end
	end

	def up_carriage
		print "\033[#{@size}F\033[J"
	end

	def open_cell
		return if @closed_cells.empty?

		value = @closed_cells.pop
		@uf.union(value, value - 1) unless first_column?(value) || cell_closed?(value - 1)
		@uf.union(value, value + 1) unless last_column?(value) || cell_closed?(value + 1)
		@uf.union(value, value + @size) unless last_row?(value) || cell_closed?(value + @size)
		@uf.union(value, value - @size) unless first_row?(value) || cell_closed?(value - @size)
	end

	private

	def first_column?(i)
		i % @size == 0
	end

	def last_column?(i)
		(i % @size) == (@size - 1)
	end

	def first_row?(i)
		i < @size
	end

	def last_row?(i)
		i >= (@table_size - @size)
	end

	def cell_open?(i)
		!cell_closed?(i)
	end

	def cell_closed?(i)
		@closed_cells.include?(i)
	end

	def first_line
		(0...@size)
	end

	def second_line
		(@table_size - @size...@table_size)
	end
end

table = PercolationTable.new(4)
until table.percolated?
	table.render
	table.open_cell
	sleep 1
	table.up_carriage
end
table.render
sleep 1
puts 'PERCOLATED!'