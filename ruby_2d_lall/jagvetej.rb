require 'ruby2d'
GRID_SIZE = 32
set title: "TEST SPEL!", background: 'white', width: GRID_SIZE*32, height: GRID_SIZE*20

GRID_HEIGHT = Window.height/32
GRID_WIDTH = Window.width/32

$score = 0
$shopOpen = false

set fps_cap:20


class Enemy
  def initialize
    @x = rand(GRID_WIDTH)
    @y = rand(GRID_HEIGHT)
  end

  def draw
    @enemy = Square.new(x:@x * GRID_SIZE, y:@y * GRID_SIZE, size: GRID_SIZE, color:'red')

  end

  def checkEnemyCollison(x,y)
    if @x == x && @y == y
      @x = rand(GRID_WIDTH)
      @y = rand(GRID_HEIGHT)
    end
  end

end

class Player
  def initialize
    @position = [2,0]
    @speed = 1

  end

  def draw
    Square.new(x: @position[0] * GRID_SIZE, y:@position[1] * GRID_SIZE, size: GRID_SIZE, color: 'black')
  end

  def move(event)
    if ['left', 'a'].include?(event) 
      @position[0]  =( @position[0]- @speed) % (GRID_WIDTH)
    elsif ['right', 'd'].include?(event) 
      @position[0]  =( @position[0]+ @speed) % (GRID_WIDTH)
    elsif ['up', 'w'].include?(event) 
      @position[1]  =( @position[1]- @speed) % (GRID_HEIGHT)
    elsif ['down', 's'].include?(event) 
      @position[1]  =( @position[1]+ @speed) % (GRID_HEIGHT)
    end
  end

  def x
    @position[0]
  end
  
  def y
    @position[1]
  end



end


class Game
  def initialize

  end
  def draw
    Text.new("Score #{$score}", color:'green', x:10, y:10, size:25)
  end
  def record_hit
    $score += 1
  end
end


class Shop
  def initialize
    $upgrades = [[1, 5,"UPGRADE 1", "ONE MORE ENEMY"],[1, 20,"UPGRADE 2", "BIGGER SCREEN"]]
    @checkPress = []
    p $upgrades
  end
  def openShop
    $shopOpen = !$shopOpen
  end
  def draw
    $upgrades.each_with_index do |info, upgrade|
      @upgrade = Text.new(info[2] + ":" + info[0].to_s , color: 'red', x:50, y: 64*upgrade)
    end
  end

end

$enemys = Array.new(10){Enemy.new}
player = Player.new
game = Game.new
shop = Shop.new


update do
  clear
  if !$shopOpen
    set background: 'white'
    game.draw
    $enemys.each do |enemy|
      enemy.draw
      if enemy.checkEnemyCollison(player.x, player.y)
        game.record_hit
      end
    end
    player.draw
  elsif $shopOpen
    set background: 'black'
    shop.draw
  else
    p "ERROR IN LAUNCHER"
    break
  end  
  
end
on :key_held do |event|
  if['up', 'down', 'left', 'right', 'w','s','a','d'].include?(event.key)
    player.move(event.key)
  end
end

on :key_down do |event|
  if event.key == 'b'
    shop.openShop
  end
end
show