require 'ruby2d'

set title: "Mario"
set width: 900, height: 600
set background: Color.new([0.4, 0.8, 1, 1])
GRID_SIZE = 30
PLAYER_SIZE = 50
ENEMY_SIZE = 30
camera_x = 0

# player
player = Sprite.new(
  'player.png',
  x: 450, y: 0,
  width: PLAYER_SIZE,
  height: PLAYER_SIZE,
  clip_width: 16,
  time: 80,
  animations: {
    idle: 0..0,
    run: 1..3,
    jump: 5..5,
    die: 6..6
  }
)

# gravity
gravity = 0.5
player_speed = 5
jump_power = 12
velocity_y = 0
on_ground = false

enemy_speed = 1.5

# level elements
obstacles = []
pipes = []
holes = []
coins = []
enemies = []
lives = 3

# game state
game_over = false
message = nil
score = 0
score_text = Text.new("Score: #{score}", x: 10, y: 10, size: 20, color: 'black')
lives_text = Text.new("Lives: #{lives}", x: 10, y: 40, size: 20, color: 'black')

# level loading
def load_level(file)
  obstacles = []
  pipes = []
  holes = []
  coins = []
  enemies = []

  y = 0
  File.readlines(file).each do |line|
    x = 0
    line.chomp.each_char do |char|
      case char
      when 'X'
        obstacles << Sprite.new('tile.jpg', x: x * GRID_SIZE, y: y * GRID_SIZE, width: GRID_SIZE, height: GRID_SIZE)
      when 'P'
        pipes << Sprite.new('pipe.png', x: x * GRID_SIZE, y: y * GRID_SIZE, width: GRID_SIZE, height: GRID_SIZE)
      when 'O'
        holes << Square.new(x: x * GRID_SIZE, y: y * GRID_SIZE, size: GRID_SIZE, color: Color.new([0.4, 0.8, 1, 1]))
      when 'C'
        coins << Sprite.new('coin.png', x: x * GRID_SIZE, y: y * GRID_SIZE, width: GRID_SIZE, height: GRID_SIZE)
      when 'E'
        enemy = Sprite.new('enemy.png', x: x * GRID_SIZE, y: y * GRID_SIZE, width: ENEMY_SIZE, height: ENEMY_SIZE,
          clip_width: 16,
          time: 100,
          animations: {
            run: 0..1,
            die: 2..2
          }
        )
        enemy.instance_variable_set(:@initial_x, enemy.x)
        enemy.instance_variable_set(:@direction, 1)
        enemy.instance_variable_set(:@last_direction_change, Time.now)
        enemies << enemy
      end
      x += 1
    end
    y += 1
  end

  [obstacles, pipes, holes, coins, enemies]
end

# first load level
obstacles, pipes, holes, coins, enemies = load_level('level.txt')

update do
  next if game_over

  # gravity
  velocity_y += gravity
  player.y += velocity_y

  # collision with ground
  if player.y + PLAYER_SIZE > Window.height
    player.y = Window.height - PLAYER_SIZE
    on_ground = true
    velocity_y = 0
  else
    on_ground = false
  end

  # collisions with obstacles
  obstacles.each do |obstacle|
    if player.x + PLAYER_SIZE > obstacle.x && player.x < obstacle.x + GRID_SIZE &&
       player.y + PLAYER_SIZE > obstacle.y && player.y < obstacle.y + GRID_SIZE

      if player.y + PLAYER_SIZE - velocity_y <= obstacle.y
        # collision from above
        player.y = obstacle.y - PLAYER_SIZE
        on_ground = true
        velocity_y = 0
      elsif player.y - velocity_y >= obstacle.y + GRID_SIZE
        # collision from below
        player.y = obstacle.y + GRID_SIZE
        velocity_y = 0
      else
        # horizontal collision
        if player.x < obstacle.x
          player.x = obstacle.x - PLAYER_SIZE
        else
          player.x = obstacle.x + GRID_SIZE
        end
      end
    end
  end

  # collision with pipes
  pipes.each do |pipe|
    if player.x + PLAYER_SIZE > pipe.x && player.x < pipe.x + GRID_SIZE &&
       player.y + PLAYER_SIZE > pipe.y && player.y < pipe.y + GRID_SIZE
      game_over = true
      message = Text.new(
        'You win!',
        style: 'bold',
        x: Window.width / 2 - 120,
        y: Window.height / 2 - 100,
        size: 60,
        color: 'black'
      )
    end
  end

  # falling into holes
  holes.each do |hole|
    if player.x + PLAYER_SIZE > hole.x && player.x < hole.x + GRID_SIZE &&
       player.y + PLAYER_SIZE > hole.y && player.y < hole.y + GRID_SIZE
      lives -= 1
      lives_text.text = "Lives: #{lives}"
      if lives > 0
        player.x = 0
        player.y = 0
      else
        game_over = true
        player.play animation: :die, loop: true
        message = Text.new(
          'Game Over!',
          style: 'bold',
          x: Window.width / 2 - 120,
          y: Window.height / 2 - 100,
          size: 60,
          color: 'black'
        )
      end
    end
  end

  # collecting coins
  coins.each do |coin|
    if player.x + PLAYER_SIZE > coin.x && player.x < coin.x + GRID_SIZE &&
       player.y + PLAYER_SIZE > coin.y && player.y < coin.y + GRID_SIZE
      coin.remove
      coins.delete(coin)
      score += 1
      score_text.text = "Score: #{score}"
    end
  end

  # enemy movement
  enemies.each do |enemy|
    enemy.play animation: :run, loop: true

    direction = enemy.instance_variable_get(:@direction)
    last_change = enemy.instance_variable_get(:@last_direction_change)
    current_time = Time.now

    if current_time - last_change >= 1.5
      direction *= -1
      enemy.instance_variable_set(:@direction, direction)
      enemy.instance_variable_set(:@last_direction_change, current_time)
    end

    enemy.x += direction * enemy_speed

    # collision with player
    if player.x + PLAYER_SIZE > enemy.x && player.x < enemy.x + ENEMY_SIZE &&
       player.y + PLAYER_SIZE > enemy.y && player.y < enemy.y + ENEMY_SIZE
      if player.y + PLAYER_SIZE - velocity_y <= enemy.y
        # kill enemy
        enemy.play animation: :die, loop: false
        velocity_y = -jump_power / 1.2  # bounce after killing enemy
        enemies.delete(enemy)
        enemy.remove
      else
        # player hit by enemy
        lives -= 1
        lives_text.text = "Lives: #{lives}"
        if lives > 0
          player.x = enemy.x - 100
          player.y = 0
        else
          game_over = true
          player.play animation: :die, loop: true
          message = Text.new(
            'Game Over!',
            style: 'bold',
            x: Window.width / 2 - 120,
            y: Window.height / 2 - 100,
            size: 60,
            color: 'black'
          )
        end
      end
    end
  end

  # camera follows player
  camera_x = player.x - Window.width / 2

  # update element positions
  player.x -= camera_x
  obstacles.each { |o| o.x -= camera_x }
  pipes.each { |pp| pp.x -= camera_x }
  holes.each { |h| h.x -= camera_x }
  coins.each { |c| c.x -= camera_x }
  enemies.each { |e| e.x -= camera_x }
end

on :key_held do |event|
  next if game_over
  case event.key
  when 'left'
    player.x -= player_speed
    player.play animation: :run, loop: false, flip: :horizontal
  when 'right'
    player.x += player_speed
    player.play animation: :run, loop: false
  end
end

on :key_down do |event|
  case event.key
  when 'up'
    if on_ground && !game_over
      velocity_y = -jump_power
      player.play animation: :jump, loop: true
    end
  when 'escape'
    close
  end
end

show
