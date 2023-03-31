raise StandardError.new('needs 2 args: level test_id') if ARGV.size != 2
level = ARGV[0]
test_id = ARGV[1]
base_file_path = "level#{level}/level#{level}_#{test_id}"
$input_file_path = base_file_path + '.in'
$output_file_path = base_file_path + '.out.txt'

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

# L P R S Y
def winner(fight)
  if fight[0] == fight[1]
    return fight[0]
  end
  fight = fight.chars.sort.join
  case fight
  when 'LP'
    'L'
  when 'LR'
    'R'
  when 'LS'
    'S'
  when 'LY'
    'L'
  when 'PR'
    'P'
  when 'PS'
    'S'
  when 'PY'
    'P'
  when 'RS'
    'R'
  when 'RY'
    'Y'
  when 'SY'
    'Y'
  else
    raise StandardError.new("bad combo #{fight}")
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

def simulate_best_s(tour)
  round = 0
  last_ok_round = tour
  while tour.size > 1
    new_tour = group_pairs(tour).map do |pair|
      winner(pair)
    end.join
    tour = new_tour

    break if !tour.include?('S')
    round += 1
    last_ok_round = tour
  end
  [ round, last_ok_round ]
end

# c = [ sc, lc, pc, yc, rc ]
# S must win
# S wins against S, L, P
# S loses against Y, R
def build_tour(c, count)
  # puts "#{count} - #{pc},#{rc},#{sc}"
  # if rc == 0
  #   return 'S' * sc + 'P' * pc
  # end
  # raise StandardError.new('error') if count <= 2
  # raise StandardError.new('no paper?') if pc == 0

  [ 0, 1, 2 ].each do |w|
    cc = c.rotate(w)


  end

  # other = S
  other_side = count / 2
  build_tour(sc, lc, pc, yc, rc, count / 2)
  # other = L
  build_tour(lc, pc, yc, rc, sc, count / 2)
  # other = P
  build_tour(pc, yc, rc, sc, lc, count / 2)

  # pc -= 1
  # other_side -= 1
  # ro = [ rc, other_side ].min
  # rc -= ro
  # other_side -= ro
  # po = [ other_side, pc ].min
  # pc -= po
  # other_side -= po
  # so = [ other_side, sc ].min
  # sc -= so
  # other_side -= so

  # right = 'P' + 'R' * ro + 'P' * po + 'S' * so
  # left = build_tour(pc, rc, sc, count / 2)

  # left + right
end

def round_count(player_count)
  c = 0
  while player_count > 1
    c += 1
    player_count /= 2
  end
  c
end

# S winner => SS, SP, SL => left = S, right = P/L/S
# 
# PL: loses to S, R 50/50, beats Y

# 3 ** R

# S, L, P, Y, R

def rec_random_tour(t)
  total_rounds = round_count(t.size)

  ids = t.size.times.to_a

  best_s, last_ok_t = simulate_best_s(t)
  t = last_ok_t
  puts best_s
  while best_s < total_rounds
    # normal_swap = rand() < 0.5
    normal_swap = true
    if normal_swap
      a, b = rand(t.size), rand(t.size)
      # c, d = rand(t.size), rand(t.size)
      # new_t = t.dup
      ids[a], ids[b] = ids[b], ids[a]
      t[a], t[b] = t[b], t[a]
      # t[c], t[d] = t[c], t[d]
    else

    end

    new_best_s, new_last_ok_t = simulate_best_s(t)
    new_best_s += best_s
    if new_best_s > best_s || (new_best_s == best_s && rand() < 0.5)
      if new_best_s > best_s
        rec_ids = rec_random_tour(new_last_ok_t)
        puts rec_ids
        break
      end
      best_s = new_best_s
      t = last_ok_t
      # puts best_s
    else
      if normal_swap
        ids[a], ids[b] = ids[b], ids[a]
        t[a], t[b] = t[b], t[a]
        # t[c], t[d] = t[c], t[d]
      end
    end
  end

  ids
end

def build_random_tour(tour)
  tour = tour.map{|c| c.dup}
  total = tour.map(&:last).sum
  # total_rounds = round_count($player_count)
  total_rounds = round_count(total)
  puts tour.to_s
  # puts "Total rounds = #{total_rounds}"
  if tour[2][1] >= total / 2 - 1 && tour[1][1] > 0
    ntour = tour.dup
    ntour[2][1] -= total / 2 - 1
    ntour[1][1] -= 1
    # puts "Recursion"
    left = build_random_tour(ntour)
    right = 'P' + 'R' * (total / 2 - 1)
    return left + right
  end
  # if tour[2][1] >= total / 2 - 1 && tour[4][1] > 0
  #   ntour = tour.dup
  #   ntour[2][1] -= total / 2 - 1
  #   ntour[4][1] -= 1
  #   # puts "Recursion"
  #   left = build_random_tour(ntour)
  #   right = 'Y' + 'R' * (total / 2 - 1)
  #   return left + right
  # end
  

  # t = tour.map{|c| c[0] * c[1] }.join
  # t = t.chars.shuffle.join
  t = solve_38(tour)

  # rec_random_tour(t)

  best_s, last_ok_t = simulate_best_s(t)
  # t = last_ok_t
  puts best_s
  while best_s < total_rounds
    a, b = rand(t.size), rand(t.size)
    # c, d = rand(t.size), rand(t.size)
    # new_t = t.dup
    next if t[a] == t[b]
    t[a], t[b] = t[b], t[a]
    # t[c], t[d] = t[c], t[d]

    new_best_s, new_last_ok_t = simulate_best_s(t)
    # new_best_s += best_s
    if new_best_s > best_s || (new_best_s == best_s && rand() < 0.5)
      puts new_best_s if new_best_s > best_s
      best_s = new_best_s
      # t = new_last_ok_t
      # puts best_s
    else
      t[a], t[b] = t[b], t[a]
      # t[c], t[d] = t[c], t[d]
    end
  end

  # w = winner_after_rounds(t, total_rounds)
  # # puts t, total_rounds, w
  # while w != 'S'
  #   # puts "#{t} => #{w}"
  #   t = t.chars.shuffle.join
  #   w = winner_after_rounds(t, total_rounds)
  # end
  # raise StandardError.new('bad tour') if winner != 'S'

  t
end


def sequence(c)
  c[0] * c[1]
end

# 4096
# [["L", 0], ["P", 24], ["R", 4067], ["S", 1], ["Y", 4]]
def solve_38(tour)
  sequence(tour[3]) + sequence(tour[1]) + sequence(tour[4]) + sequence(tour[2]) + sequence(tour[0])
end

# 4096
# [["L", 11], ["P", 4], ["R", 4046], ["S", 3], ["Y", 32]]
# 4046 - 2048 = 1998
# [["L", 11], ["P", 4], ["R", 4046], ["S", 3], ["Y", 32]]
def solve_68(tour)
  sequence(tour[3]) + sequence(tour[1]) + sequence(tour[2]) + sequence(tour[0]) + sequence(tour[4])
end

def solve
  $tours.each_with_index.map do |tour, index|
    # next if index+1 < 38
    # TODO: 68
    # next if index+1 < 68
    puts "Test \##{index+1}/#{$tours.size}"
    puts tour.to_s
    # pc, rc, sc = tour.map(&:last)
    # t = build_tour(pc, rc, sc, $player_count)
    # build_tour([ tour[3], tour[0], tour[1], tour[4], tour[2] ], $player_count)

    t = build_random_tour(tour)
    # t = solve_68(tour)
    puts t.size
    puts simulate_best_s(t)[0]
    puts tour.to_s

    total = tour.map(&:last).sum
  # total_rounds = round_count($player_count)
  total_rounds = round_count(total)
    best_s, last_ok_t = simulate_best_s(t)
  # t = last_ok_t
  puts best_s
  while best_s < total_rounds
    a, b = rand(t.size), rand(t.size)
    # c, d = rand(t.size), rand(t.size)
    # new_t = t.dup
    next if t[a] == t[b]
    t[a], t[b] = t[b], t[a]
    # t[c], t[d] = t[c], t[d]

    new_best_s, new_last_ok_t = simulate_best_s(t)
    # new_best_s += best_s
    if new_best_s > best_s || (new_best_s == best_s && rand() < 0.5)
      puts new_best_s if new_best_s > best_s
      best_s = new_best_s
      # t = new_last_ok_t
      # puts best_s
    else
      t[a], t[b] = t[b], t[a]
      # t[c], t[d] = t[c], t[d]
    end
  end
    # t = solve_38(tour)

    after = winner_after_rounds(t, round_count($player_count))
    puts t, after
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
