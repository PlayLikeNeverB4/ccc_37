raise StandardError.new('needs 2 args: level test_id') if ARGV.size != 2
level = ARGV[0]
test_id = ARGV[1]
base_file_path = "level#{level}/level#{level}_#{test_id}"
$input_file_path = base_file_path + '.in'
$output_file_path = base_file_path + '.out.txt'

# ALL_CHARS = "RPS"
# $WINNER = {
#   'PR' => 'P',
#   'RS' => 'R',
#   'PS' => 'S',
# }

def winner(fight)
  if fight == 'PR'
    'P'
  elsif fight == 'RS'
    'R'
  else
    'S'
  end
end

$fight_count = nil

def read_input
  f = File.open($input_file_path, 'r')
  $fight_count = f.readline.to_i
  $fights = $fight_count.times.map do
    f.readline.strip
  end
end

def solve
  $fights.map do |fight|
    if fight[0] == fight[1]
      fight[0]
    else
      winner(fight.chars.sort.join)
    end
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
