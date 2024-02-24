require_relative 'percolation_table'

class PercolationStats
	def initialize(table_size, number_of_trials)
		@size = table_size
		@trials_count = number_of_trials
	end

	def mean
		@mean ||= @results.sum / @trials_count.to_f
	end

	def stddev
		@stddev ||= (@results.map { |x| (x - mean) ** 2 }.sum / (@trials_count - 1.0)) ** 0.5
	end

	def confidence_low
		mean - (1.96 * stddev / (@trials_count ** 0.5))
	end

	def confidence_high
		mean + (1.96 * stddev / (@trials_count ** 0.5))
	end

	def render_progress
		filled = ((@results.size / @trials_count.to_f) * 50).floor
		print "[ #{'■' * filled}#{'.' * (50 - filled)}  ] #{@results.size}/#{@trials_count}\r"
	end

	def run
		@results = []
		@trials_count.times do
			table = PercolationTable.new(@size)
			until table.percolates?
				table.open_cell
			end
			@results << (table.number_of_open_cells / (@size ** 2).to_f)
			render_progress
		end
		puts "\nDone!"
		puts "mean = #{mean}"
		puts "stddev = #{stddev}"
		puts "95% confidence interval = [#{confidence_low}, #{confidence_high}]"
	end
end