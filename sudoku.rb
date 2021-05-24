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

def solve_sudoku(sudoku)
  position = find_position(sudoku)
  return true unless position

  (1..9).to_a.each do |element|
    if valid_position(sudoku, position, element)
      sudoku[position[0]][position[1]] = element
      return true if solve_sudoku(sudoku)
      sudoku[position[0]][position[1]] = 0
      @backtracking_count += 1
    end
  end
  false
end

def find_position(sudoku)
  (0..8).to_a.each_with_index do |i|
    (0..8).to_a.each_with_index do |j|
      return [i,j] if sudoku[i][j] == 0
    end
  end
  false
end

def valid_position(sudoku, position, element)
  return false if sudoku[position[0]][position[1]] > 0

  (0..8).to_a.each do |i|
    return false if (sudoku[position[0]][i] == element) || (sudoku[i][position[1]] == element)
  end

  ((position[0]/3 * 3)..((position[0]/3 * 3) + 2)).to_a.each do |i|
    ((position[1]/3 * 3)..((position[1]/3 * 3) + 2)).to_a.each do |j|
      return false if sudoku[i][j] == element
    end
  end

  true
end

print_sudoku(sudoku_input)
solve_sudoku(sudoku_input)
print_sudoku(sudoku_input)
puts "Backtrack iterations: #{@backtracking_count}"