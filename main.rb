raise StandardError.new('needs 2 args: level test_id') if ARGV.size != 2
level = ARGV[0]
test_id = ARGV[1]
base_file_path = "level#{level}/level#{level}_#{test_id}"
$input_file_path = base_file_path + '.in'
$output_file_path = base_file_path + '.out.txt'

def winner(fight)
  if fight[0] == fight[1]
    return fight[0]
  end
  fight = fight.chars.sort.join
  if fight == 'PR'
    'P'
  elsif fight == 'RS'
    'R'
  else
    'S'
  end
end

def group_pairs(tour)
  (tour.size/2).times.map do |index|
    tour[2*index..2*index+1]
  end
end

def winner_after_rounds(tour, round_count)
  round_count.times do
    new_tour = group_pairs(tour).map do |pair|
      winner(pair)
    end.join
    tour = new_tour
  end
  tour
end

$tour_count = nil
$tours = nil
$player_count = nil

def read_input
  f = File.open($input_file_path, 'r')
  $tour_count, $player_count = f.readline.split.map(&:to_i)
  $tours = $tour_count.times.map do
    f.readline.strip
  end
end

def solve
  $tours.map do |tour|
    winner_after_rounds(tour, 2)
  end
end

def write_output(sol)
  f = File.open($output_file_path, 'w')
  f.puts(sol)
  f.close
end

read_input

solution = solve

write_output(solution)
