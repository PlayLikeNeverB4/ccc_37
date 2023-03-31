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

def build_tour(pc, rc, sc, count)
  # puts "#{count} - #{pc},#{rc},#{sc}"
  if rc == 0
    return 'S' * sc + 'P' * pc
  end
  raise StandardError.new('error') if count <= 2
  raise StandardError.new('no paper?') if pc == 0

  other_side = count / 2

  pc -= 1
  other_side -= 1
  ro = [ rc, other_side ].min
  rc -= ro
  other_side -= ro
  po = [ other_side, pc ].min
  pc -= po
  other_side -= po
  so = [ other_side, sc ].min
  sc -= so
  other_side -= so

  right = 'P' + 'R' * ro + 'P' * po + 'S' * so
  left = build_tour(pc, rc, sc, count / 2)

  left + right
end

def round_count(player_count)
  c = 0
  while player_count > 1
    c += 1
    player_count /= 2
  end
  c
end

def solve
  $tours.map do |tour|
    pc, rc, sc = tour.map(&:last)
    t = build_tour(pc, rc, sc, $player_count)

    after = winner_after_rounds(t, round_count($player_count))
    # puts t, after
    raise StandardError.new('bad tour') if after != 'S'

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
