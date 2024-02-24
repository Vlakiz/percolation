require_relative 'percolation_stats'

raise 'Too few arguments!' if ARGV.size < 2

size = ARGV[0].to_i
trials = ARGV[1].to_i

raise 'Invalid argument: table size' if size < 2
raise 'Invalid argument: trials' if trials <= 0

PercolationStats.new(size, trials).run