require_relative 'percolation_table'

raise "No arguments!" if ARGV.empty?
raise "Invalid argument!" if ARGV[0].to_i < 2

table = PercolationTable.new(ARGV[0].to_i)
until table.percolates?
	table.render
	table.open_cell
	sleep 1
	table.up_carriage
end
table.render
sleep 1
puts 'PERCOLATED!'