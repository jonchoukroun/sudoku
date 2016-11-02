# Start implementing col method
class Sudoku
	WIDTH = 9
	BOX_WIDTH = Math.sqrt(WIDTH).to_i

	# coord = [int, int] (row, col)
	def initialize(board_string)
		@board = board_string
		@counter = 0
	end

	def row(row)
		start_index = row * WIDTH

		@board[start_index...(start_index + WIDTH)].split('')
	end

	def col(col)
		(0...WIDTH).map { |row| get(row, col) }
	end

	def box(row, col)
		# Top left corner of box
		b_row, b_col = row * BOX_WIDTH, col * BOX_WIDTH

		(b_row...(b_row + BOX_WIDTH)).map { |r|
			(b_col...(b_col + BOX_WIDTH)).map { |c|
				get(r, c)
			}
		}.flatten
	end

	def get(row, col)
		@board[col + WIDTH * row]
	end

	def won?
		! @board.include?('-')
	end

	def unique?(num_arr)
		num_arr = remove_dashes(num_arr)
		num_arr == num_arr.uniq
	end

	def violation?
		# Check rows and columns together
		(0...WIDTH).each { |coord|
			return true unless unique?(row(coord))
			return true unless unique?(col(coord))
		}

		# Check boxes
		(0...BOX_WIDTH).each { |b_row|
			(0...BOX_WIDTH).each { |b_col|
				return true unless unique?(box(b_row, b_col))
			}
		}

		false
	end

	def solve(board = @board)
		@board = board
		@counter += 1

		if @counter % 10000 == 0
			puts "Counter: #{@counter}"
			puts to_s
		end

		return false if violation?
		return to_s if won?

		(1..WIDTH).each { |try|
			solution = solve(board.sub('-', try.to_s))
			return solution if solution
		}

		false
	end

	# Returns a nicely formatted string representing the current state of the board
	def to_s
		@board.split('').each_slice(WIDTH).to_a.map { |row|
			row.join(" ") }.join("\n")
	end


	private
	def remove_dashes(arr)
		arr.reject { |i| i == '-' }
	end
end

# Puzzles for testing
done = '435269781682571493197834562826195347374682915951743628519326874248957136763418259'
easiest = '4-5269781682571493197834562826195347374682915951743628519326874248957136763418259'
test = '4-5269781682-714931-7834562-261-53473746-29159517-362851-3268742-89571367634-8259'
p_1 = '---26-7-168--7--9-19---45--82-1---4---46-29---5---3-28--93---74-4--5--367-3-18---'
p_2 = '--5-3--819-285--6-6----4-5---74-283-34976---5--83--49-15--87--2-9----6---26-495-3'
open = '-' * 81

set_1 = 'set-01_sudoku_puzzles.txt'
set_2 = 'set-02_project_euler_50-easy-puzzles.txt'
set_3 = 'set-03_peter-norvig_95-hard-puzzles.txt'
set_4 ='set-04_peter-norvig_11-hardest-puzzles.txt'

puzzle = File.readlines(set_4)[-1]
game = Sudoku.new(puzzle)
puts game.solve
