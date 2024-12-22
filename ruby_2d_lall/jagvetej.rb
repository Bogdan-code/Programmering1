require 'ruby2d'
GRID_SIZE = 32
set title: "TEST SPEL!", background: 'white', width: GRID_SIZE*32, height: GRID_SIZE*20

GRID_HEIGHT = Window.height/32
GRID_WIDTH = Window.width/32

$score = 10000
$rebirths = 0
$shopOpen = false
$upgrades = [[1],[1],[1],[1]]
set fps_cap:12


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

  def rebirth
    $upgrades = [[1, 5,"UPGRADE 1", "ONE MORE ENEMY"],[1, 20,"UPGRADE 2", "MORE FOOD"],[1, 100,"UPGRADE 3", "NAS"], [$rebirths, 1000*1.2**$rebirths, "REBIRTH", "rebirth resets your stats but 2x to everything"]]
    $score = 0
  end

end




class Game
  def initialize

  end

  def draw
    Text.new("Score #{$score}", color:'green', x:10, y:10,z:10, size:25)
  end

  def record_hit
    $score += (1 + $upgrades[0][0]-1) * $rebirths+1
  end
end


class Shop
  def initialize
    @x = 200
    @y = 64
    $upgrades = [[1, 5,"UPGRADE 1", "ONE MORE ENEMY"],[1, 20,"UPGRADE 2", "MORE FOOD"],[1, 100,"UPGRADE 3", "NAS"], [0, 1000*1.2**$rebirths, "REBIRTH", "rebirth resets your stats but 2x to everything"]]
    @checkPress = []

  end

  def openShop
    $shopOpen = !$shopOpen
  end

  def draw
    Text.new("Score #{$score}", color:'green', x:10, y:10,z:10, size:25)
    $upgrades.each_with_index do |info, upgrade|
      @upgrade = Text.new(info[2] + ":" + info[0].to_s + " cost:#{(info[1]+1).to_i}" , color: 'red', x:@x, y: (@y*upgrade)+64)
      @desc = Text.new(info[3], color:'red', x:@x, y:(@y*upgrade)+92, size:10)
    end
  end

  def checkClick(x, y)
    $upgrades.each_with_index do |info, upgrade|
      if (@x..@x+128).to_a.include?(x) && (@y*upgrade+64..(@y*upgrade)+100).to_a.include?(y) && $shopOpen
        if upgrade == 3 && $score >= info[1]
          $rebirths+=1
          $score -= info[1]
          $score = $score.to_i
          info[1] *= 1.2
          return upgrade
        elsif $score >= info[1] && upgrade != 3
          info[0] += 1*($rebirths+1)
          $score -= info[1]
          $score = $score.to_i
          info[1] *= 1.2
        end
      end
    end
  end
  
  def purchase
  end
end

$enemys = Array.new($upgrades[1][0]){Enemy.new}
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
    $enemys = Array.new($upgrades[1][0]){Enemy.new}
    clear
    set background: 'black'
    shop.draw
  else
    p "ERROR IN LAUNCHER"
    break
  end  
  
end
on :key_held do |event|
  if['up', 'down', 'left', 'right', 'w','s','a','d'].include?(event.key) && !$shopOpen
    player.move(event.key)
  end
end

on :key_down do |event|
  if event.key == 'b'
    shop.openShop
  end
end

on :mouse_down do |event|
  p Window.width
  p Window.height
  case event.button
  when :left
    # Left mouse button pressed down
    if shop.checkClick(Window.mouse_x, Window.mouse_y) == 3
      player.rebirth
    end
  when :middle
  when :right
  end
end
show