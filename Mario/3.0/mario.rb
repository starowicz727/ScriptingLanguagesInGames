require 'ruby2d'

set title: "Mario"
set width: 900, height: 600
# set background: Color.new([0.17, 0.67, 0.96, 1])
set background: Color.new([0.4, 0.8, 1, 1])
GRID_SIZE = 30
PLAYER_SIZE = 50
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
    run: 1..3,
    idle: 0..0,
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

# level elements
obstacles = []
pipes = []
holes = []
lives = 1

# game state
game_over = false
message = nil

# level loading
def load_level(file)
  obstacles = []
  pipes = []
  holes = []

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
      end
      x += 1
    end
    y += 1
  end

  [obstacles, pipes, holes]
end

# first load level
obstacles, pipes, holes = load_level('level.txt')

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

  # camera follows player
  camera_x = player.x - Window.width / 2

  # update element positions
  player.x -= camera_x
  obstacles.each { |o| o.x -= camera_x }
  pipes.each { |pp| pp.x -= camera_x }
  holes.each { |h| h.x -= camera_x }
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
