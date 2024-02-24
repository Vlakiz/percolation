require_relative 'union_find'

class PercolationTable
	def initialize(size)
		raise "Incorrect size" if size < 2

		@size = size
		@table_size = size**2
		@closed_cells = (0...@table_size).to_a.shuffle
		@cells = Array.new(@table_size, false)
		@uf = UnionFind.new(@table_size + 2)

		first_line.each do |i|
			@uf.union(i, @table_size)
		end

		second_line.each do |i|
			@uf.union(i, @table_size + 1)
		end
	end

	def open_cell
		return if @closed_cells.empty?

		value = @closed_cells.pop
		@cells[value] = true
		@uf.union(value, value - 1) unless first_column?(value) || cell_closed?(value - 1)
		@uf.union(value, value + 1) unless last_column?(value) || cell_closed?(value + 1)
		@uf.union(value, value + @size) unless last_row?(value) || cell_closed?(value + @size)
		@uf.union(value, value - @size) unless first_row?(value) || cell_closed?(value - @size)
	end

	def number_of_open_cells
		@table_size - @closed_cells.size
	end

	def percolates?
		@uf.connected?(@table_size, @table_size + 1)
	end

	def render
		(0...@size**2).each do |i|
			print @cells[i] ? '□' : '■'
			print ((i + 1) % @size) == 0 ? "\n" : ' '
		end
	end

	def up_carriage
		print "\033[#{@size}F\033[J"
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
		!@cells[i]
	end

	def first_line
		(0...@size)
	end

	def second_line
		(@table_size - @size...@table_size)
	end
end