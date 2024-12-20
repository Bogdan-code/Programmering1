require 'ruby2d'

set title: "TEST SPEL!", background: 'white', width: 640, height: 480
GRID_SIZE = 1


score = 0
@enemySpawnAmount = 3
@enemysAlive = 0

shopOpen = false

@score_text = Text.new(
  score.to_s,
  x: 300, y: 10,
  style: 'bold',
  size: 40,
  color: 'black',
  z: 10
)

@square = Square.new(x: 10, y: 20, size: 25, color: 'blue', z:5)

class Enemy
  def draw
    while @enemysAlive <= @enemySpawnAmount
      Square.new(x:rand(Window.width), y:rand(Window.height), size: 20, color:'red')
    end
  end
end





def spawn_enemy()
  # i = 0
  # while i < @enemySpawnAmount
  #   @enemy = Square.new(x:rand(Window.width- 40), y:rand(Window.height-30), color:'red')
  #   i+=1
  # end
  @enemy = Square.new(x:rand(Window.width- 40), y:rand(Window.height-30), size: 20, color:'red')
end


@speed = 5

def spawn()
  set background: 'white'
  @square.add
  spawn_enemy()
  @score_text.add
end

def checkMovement(event)
  if event.key == 'a'
    @square.x -= @speed
  elsif event.key == 'd'
    @square.x += @speed
  elsif event.key == 'w'
    @square.y -= @speed
  elsif event.key == 's'
    @square.y += @speed
  end
end

def openShop()
  clear
  set background:'black'
end

on :key_held do |event|
  checkMovement(event)
  
  if event.key == "r" && shopOpen == false

    shopOpen = true
    openShop()
    sleep(0.2)
  elsif event.key == "r" && shopOpen == true
    sleep(0.2)
    shopOpen = false
    p "cock"
    clear
    spawn()

  end
end

update do
  if @square.contains? @enemy.x * 20, @enemy.y * 20
    @enemy.remove
    score += 1
    newEnemy = Enemy.new
    newEnemy
  end
  
  @square.size = score+20
  @score_text.text = score.to_s
end
show