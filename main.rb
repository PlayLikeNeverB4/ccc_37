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
    line = f.readline.strip.split
    line.map do |s|
      fighter = s[s.size-1]
      amount = s[0..s.size-2].to_i
      [ fighter, amount ]
    end.sort
  end
end

# rock loses to paper
# rock-rock is also good
# SSS...PRPRPRPR
def solve
  $tours.map do |tour|
    puts tour.to_s
    pc, rc, sc = tour.map(&:last)
    prrr = [ pc, rc / 3 ].min
    pc -= prrr
    rc -= prrr * 3
    # prr = [ pc, rc / 2 ].min
    # pc -= prr
    # rc -= prr * 2
    pr = [ pc, rc ].min
    pc -= pr
    rc -= pr
    # raise StandardError.new('too many rocks') if rc > 0
    t = 'S' * sc + 'P' * pc + 'R' * rc + 'PR' * pr + 'PRRR' * prrr
    after = winner_after_rounds(t, 2)
    puts t, after
    raise StandardError.new('bad tour') if after.include?('R') || !after.include?('S')
    t
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
