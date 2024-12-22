require 'ruby2d'
GRID_SIZE = 8
set title: "GOLF TYPE SHI", background: 'green', width: GRID_SIZE*128, height: GRID_SIZE*80
set fps_cap:12

$buttonPressed = false
win_screen = false

class Player
  def initialize
    @velocity_x = 0
    @velocity_y = 0
    @position = [60,40]
  end

  def draw
    @player = Square.new(x: @position[0] * GRID_SIZE, y:@position[1] * GRID_SIZE, size: GRID_SIZE*4, color: 'white')
  end

  def move

    # @velocity_x = @velocity_x.to_i
    # @velocity_y = @velocity_y.to_i
    
    if @velocity_x <= 0.4 && @velocity_x >= -0.4
      @velocity_x = 0
    end
    if @velocity_y < 0.4 && @velocity_y > -0.4
      @velocity_y = 0
    end
    @position[0] -= @velocity_x
    @position[1] -= @velocity_y
    @velocity_x -= @velocity_x ** 0.6
    @velocity_y -= @velocity_y ** 0.6
    @velocity_x = @velocity_x.real.to_i
    @velocity_y = @velocity_y.real.to_i


  end
  def checkClick(x, y)

    ((@position[0]* GRID_SIZE).to_i..((@position[0]+4)* GRID_SIZE).to_i).to_a.include?(x) && ((@position[1]* GRID_SIZE).to_i..((@position[1]+4)* GRID_SIZE).to_i).to_a.include?(y)
  end

  def shoot(x, y)
    @velocity_x = (x - (@position[0] * GRID_SIZE) ) /50
    @velocity_y = (y - (@position[1] * GRID_SIZE) ) / 50

    p @velocity_x
    p @velocity_y
  end

  def x
    @position[0]
  end

  def y
    @position[1]
  end

  def reset() 
    @position = [60,40]
    @velocity_x = 0
    @velocity_y = 0
    self.draw

  end
end


class Hole
  def initialize
    @position = [rand((Window.width/8)-10).to_i, rand((Window.height/8)-10).to_i]
  end

  def draw
    @hole = Square.new(x:(@position[0] * GRID_SIZE), y:(@position[1]*GRID_SIZE), size: GRID_SIZE*5, color: 'black')
  end

  def collison(x, y)
    (x..x+3).to_a.intersect?((@position[0]..@position[0]+4).to_a) && (y..y+3).to_a.intersect?((@position[1]..@position[1]+4).to_a)
  end

  def changeLocation
    @position = [rand(Window.width/8).to_i, rand(Window.height/8).to_i]
    self.draw
  end
end

class Game
  def initialize
    @hits = 0
    @wins = 0
    @wintext = nil
  end
  def draw
    Text.new("Hits: #{@hits}",x:20, y:20, color:"black", size:25)
    Text.new("Wins: #{@wins}",x:500, y:20, color:"black", size:25)

    if @wintext
      Text.new(@wintext, x:250,y:200, color:'yellow', size:50)
    end
  end
  def registerHit
    @hits += 1
    self.draw
  end 
  def registerWin
    if @hits == 1
      @wintext = "HOLE IN ONE!!!"
    elsif @hits == 2
      @wintext = "DOUBLE BIRDIE!!!"
    elsif @hits == 3
      @wintext = "BIRDIE!!!!" 
    elsif @hits == 4  
      @wintext = "Par"
    else
      @wintext = "You made it!"
    end
    @hits = 0
    @wins += 1
  end

  def resetText
    @wintext = nil
  end
end


game = Game.new
player = Player.new
hole = Hole.new

update do
  clear
  if !win_screen
    hole.draw
    game.draw
    player.draw
    player.move
    if player.x< 0 || player.x > 127 || player.y < 0 || player.y > 77
      player.reset
      game.registerHit
    end
    
    if hole.collison(player.x, player.y)
      game.registerWin
      win_screen = true
      player.reset
      hole.changeLocation

    end
  end
  game.draw
end

on :mouse do |event|

  if $buttonPressed && event.type == :up
    player.shoot(event.x, event.y)
    game.registerHit
    $buttonPressed = false
  end
end

on :mouse_down do |event|
  case event.button
  when :left
    if player.checkClick(Window.mouse_x, Window.mouse_y) && !$buttonPressed
      $buttonPressed = true
    end
    if win_screen
      win_screen = false
      game.resetText
    end
  end

end


show