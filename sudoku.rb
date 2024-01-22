
require 'pry'

# hardest known sudoku
sudoku_input =  [
  [8, 0, 0,  0, 0, 0,  0, 0, 0],
  [0, 0, 3,  6, 0, 0,  0, 0, 0],
  [0, 7, 0,  0, 9, 0,  2, 0, 0],

  [0, 5, 0,  0, 0, 7,  0, 0, 0],
  [0, 0, 0,  0, 4, 5,  7, 0, 0],
  [0, 0, 0,  1, 0, 0,  0, 3, 0],
  
  [0, 0, 1,  0, 0, 0,  0, 6, 8],
  [0, 0, 8,  5, 0, 0,  0, 1, 0],
  [0, 9, 0,  0, 0, 0,  4, 0, 0]
]

# # medium sudoku
# sudoku_input =  [
#   [0, 0, 5,  3, 0, 0,  0, 0, 0],
#   [8, 0, 0,  0, 0, 0,  0, 2, 0],
#   [0, 7, 0,  0, 1, 0,  5, 0, 0],

#   [4, 0, 0,  0, 0, 5,  3, 0, 0],
#   [0, 1, 0,  0, 7, 0,  0, 0, 6],
#   [0, 0, 3,  2, 0, 0,  0, 8, 0],
  
#   [0, 6, 0,  5, 0, 0,  0, 0, 9],
#   [0, 0, 4,  0, 0, 0,  0, 3, 0],
#   [0, 0, 0,  0, 0, 9,  7, 0, 0]
# ]

# # easy sudoku
# sudoku_input =  [
#   [1, 0, 0,  0, 0, 7,  0, 9, 0],
#   [0, 3, 0,  0, 2, 0,  0, 0, 8],
#   [0, 0, 9,  6, 0, 0,  5, 0, 0],

#   [0, 0, 5,  3, 0, 0,  9, 0, 0],
#   [0, 1, 0,  0, 8, 0,  0, 0, 2],
#   [6, 0, 0,  0, 0, 4,  0, 0, 0],
  
#   [3, 0, 0,  0, 0, 0,  0, 1, 0],
#   [0, 4, 0,  0, 0, 0,  0, 0, 7],
#   [0, 0, 7,  0, 0, 0,  3, 0, 0]
# ] 

@backtracking_count = 0

def print_sudoku(sudoku)
  print "\n"
  width = sudoku.flatten.max.to_s.size+2
  sudoku.each_with_index do |i, i_index|
    i_third_element = ((i_index + 1) % 3).zero?
    print "\n" unless i_index.zero?
    i.each_with_index do |j, j_index|
      j_third_element = ((j_index + 1) % 3).zero?
      j_nonzero=(j.to_s.rjust(width) + (j_third_element ? ' ' : ''))
      unless j.zero?
        print "\e[37m#{j_nonzero}\e[0m"
      else
        print "\e[31m#{j_nonzero}\e[0m"
      end
    end
    print (i_third_element ? "\n" : "")
  end
  print "\n"
end

# first identity the next empty position
# then validate the sudoku with the next element
# if valid move to next else backtrack using recursion
def solve_sudoku(sudoku)
  position = find_position(sudoku)
  return true unless position

  (1..9).to_a.each do |element|
    if valid_position(sudoku, position, element)
      # print_sudoku(sudoku)
      # puts "position[0]=#{position[0]}, position[1]=#{position[1]}, sudoku[position[0]][position[1]]=#{sudoku[position[0]][position[1]]}, element=#{element}"
      # binding.pry
      sudoku[position[0]][position[1]] = element
      
      # using recursion for backtracking
      return true if solve_sudoku(sudoku)
      
      # set the element to zero for the position when the element is not fit (backtrack)
      # move to the next element in 1-9
      sudoku[position[0]][position[1]] = 0
      @backtracking_count += 1
    end
  end
  false
end

# return position if the value is zero
def find_position(sudoku)
  (0..8).to_a.each_with_index do |i|
    (0..8).to_a.each_with_index do |j|
      return [i,j] if sudoku[i][j] == 0
    end
  end
  false
end

def valid_position(sudoku, position, element)
  # return 'false' if there is an element greater then zero in the position
  return false if sudoku[position[0]][position[1]] > 0

  # return 'false' if existing element in the row or column of the position
  (0..8).to_a.each do |i|
    return false if (sudoku[position[0]][i] == element) || (sudoku[i][position[1]] == element)
  end

  # return 'false' if the existing element is in the same 3x3 block
  ((position[0]/3 * 3)..((position[0]/3 * 3) + 2)).to_a.each do |i|
    ((position[1]/3 * 3)..((position[1]/3 * 3) + 2)).to_a.each do |j|
      return false if sudoku[i][j] == element
    end
  end
  true
end

def valid_sudoku_input(sudoku)
  (0..8).to_a.each_with_index do |i|
    (0..8).to_a.each_with_index do |j|
      return false if (sudoku[i][j] > 9 || sudoku[i][j] < 0)
      if sudoku[i][j] > 0
        (0..8).to_a.each do |k|
          next if i == k || j == k
          return false if (sudoku[i][k] == sudoku[i][j]) || (sudoku[k][j] == sudoku[i][j])
        end
        ((i/3 * 3)..((i/3 * 3) + 2)).to_a.each do |l|
          ((j/3 * 3)..((j/3 * 3) + 2)).to_a.each do |m|
            next if (i == l && j == m)
            return false if sudoku[l][m] == sudoku[i][j]
          end
        end
      end
    end
  end
  true
end

print_sudoku(sudoku_input)
if !valid_sudoku_input(sudoku_input) 
    print "\e[31mInvalid Sudoku\e[0m"
    return
end
solve_sudoku(sudoku_input)
print_sudoku(sudoku_input)
puts "Backtrack iterations: #{@backtracking_count}"

# TIME COMPLEXITY (K^N)
# time complexity is K^N, where K is number of times the function calls itself