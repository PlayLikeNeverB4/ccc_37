raise StandardError.new('needs 2 args: level test_id') if ARGV.size != 2
level = ARGV[0]
test_id = ARGV[1]
base_file_path = "level#{level}/level#{level}_#{test_id}"
$input_file_path = base_file_path + '.in'
$output_file_path = base_file_path + '.out.txt'

# $game_count = nil
# $player_count = nil
# $games = nil

def read_input
  f = File.open($input_file_path, 'r')
  # $game_count, $player_count = f.readline.split.map(&:to_i)
  # $games = $game_count.times.map do
  #   f.readline.split.map(&:to_i)
  # end
end

def solve
  # wins = Array.new($player_count, 0)
  # $games.each do |game|
  #   p1_id, p1_score, p2_id, p2_score = game
  #   if ([ p2_score, -p2_id ] <=> [ p1_score, -p1_id ]) == -1
  #     p1_id, p1_score, p2_id, p2_score = p2_id, p2_score, p1_id, p1_score
  #   end
  #   wins[p2_id] += 1
  # end
  # ranks = wins.each_with_index.sort_by{|s| [ -s[0], s[1] ] }
  # ranks
end

def write_output(sol)
  f = File.open($output_file_path, 'w')
  # sol.each do |player|
  #   f.puts("#{player[1]} #{player[0]}")
  # end
  f.close
end

read_input

solution = solve

write_output(solution)
