require 'ruby2d'
GRID_SIZE = 8

set title: "GOLF 2P", background: 'white', width: GRID_SIZE*128, height: GRID_SIZE*80, z:-100
set fps_cap:60

$buttonPressed = false
win_screen = false
$end_menu = false
$scores_p1 = []
$scores_p2 = []

$firstp = true
$secondp = false
$round = 1


class Player

  def initialize
    @velocity= 0
    @angle = 0
    @position = [60,40]  
    @player_img = ''
  end

  def draw
    @player = Image.new(@player_img,x: @position[0] * GRID_SIZE, y:@position[1] * GRID_SIZE,  color: 'white', rotate:@angle)
  end

  def set_img(id)
    if id == 1
      @player_img = 'boll2.png'
    else
      @player_img = 'boll3.png'
    end
  end

  def move
    
    if @velocity.abs < 0.01
      @velocity = 0
    end

    radians = @angle * Math::PI / 180

    x_comp = Math.sin(radians)
    y_comp = Math.cos(radians)


    @position[0] += x_comp * @velocity
    @position[1] -= y_comp * @velocity
    @velocity -= @velocity ** 0.000000005
    @velocity = @velocity.real.to_i


  end
  def checkClick(x, y)

    ((@position[0]* GRID_SIZE).to_i..((@position[0]+4)* GRID_SIZE).to_i).to_a.include?(x) && ((@position[1]* GRID_SIZE).to_i..((@position[1]+4)* GRID_SIZE).to_i).to_a.include?(y)
  end

  def shoot(x, y)


    # @velocity_x = (x - (@position[0] * GRID_SIZE) ) /50
    # @velocity_y = (y - (@position[1] * GRID_SIZE) ) / 50
    ball_screen_x = @position[0] * GRID_SIZE
    ball_screen_y = @position[1] * GRID_SIZE

    dx = x - ball_screen_x
    dy = y - ball_screen_y

    dist = Math.sqrt(dx*dx + dy*dy)

    @velocity = dist / 50


  end 

  def x
    @position[0]
  end

  def y
    @position[1]
  end

  def reset() 
    @position = [60,40]
    @velocity = 0
    self.draw
  end

  def updateAngle(x, y)
    if x != 0
      ball_screen_x = @position[0] * GRID_SIZE
      ball_screen_y = @position[1] * GRID_SIZE
      dx = x - ball_screen_x
      dy = y - ball_screen_y
      radians = Math.atan2(dy, dx)
      angle_degs = (radians * 180 / Math::PI)
      @angle = angle_degs - 90
      
      self.draw
    end
  end

  def collison_with_wall(input)
    p @angle
    x = input[0]
    y = input[1]
    w = input[2]/GRID_SIZE
    h = input[3]/GRID_SIZE
    if (x.to_i..x.to_i+w).to_a.intersect?((@position[0].to_i..@position[0].to_i+5).to_a) && (y.to_i..y.to_i+h).to_a.intersect?((@position[1].to_i..@position[1].to_i+5).to_a)

      @angle = (@angle/-15)- 180 if @angle > -90 && @angle < 90
      @angle = (@angle/-15) + 180 if @angle < -90

    end
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
    (x.to_i..x.to_i+3).to_a.intersect?((@position[0]..@position[0]+4).to_a) && (y.to_i..y.to_i+3).to_a.intersect?((@position[1]..@position[1]+4).to_a)
  end

  def changeLocation
    @position = [rand((Window.width/8)-10).to_i, rand((Window.height/8)-10).to_i]
    self.draw
  end
end

class Game
  def initialize
    @hits = 0
    @wins = 0
    @round = 1
    @wintext = nil
  end
  def draw
    if !$end_menu
      Text.new("Hits: #{@hits}",x:20, y:20, color:"black", size:25)
      Text.new("Round: #{$round}",x:500, y:20, color:"black", size:25)
    end
    if @wintext && !$end_menu
      Text.new(@wintext, x:250,y:200, color:'yellow', size:50)
    end
    if $end_menu
      Text.new("Player1", x:400, y:0, color:'black', size:30)
      Text.new("Player2", x:520, y:0, color:'black', size:30)
      Rectangle.new(x:510, y:0, height:375, width:2, color:'black')
      Rectangle.new(x:400, y:340, height:2, width:220, color:'black')
      $scores_p1.each_with_index do |score, index|
        Text.new(score, x:450,y:(30*index) + 50, color:'yellow', size:25)
        Text.new($scores_p2[index], x:570,y:(30*index) + 50, color:'yellow', size:25)
      end
      Text.new($scores_p1.sum, x:450, y:350, color:'black', size:30)
      Text.new($scores_p2.sum, x:570, y:350, color:'black', size:30)
      Text.new("Player 1 WON!", x:410, y:380, color:'black', size:30) if $scores_p1.sum < $scores_p2.sum
      Text.new("Player 2 WON!", x:410, y:380, color:'black', size:30) if $scores_p2.sum < $scores_p1.sum
      Text.new("Tie", x:485, y:380, color:'black', size:30) if $scores_p1.sum == $scores_p2.sum


    end
  end
  def registerHit
    @hits += 1
    self.draw
  end 
  def registerWin(player)
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
    
    if player == 1
      $scores_p1 << @hits
      $firstp = false
      $secondp = true
    elsif player == 2
      $scores_p2 << @hits
      $firstp = true
      $secondp = false
    end

    @hits = 0

  end

  def resetText
    @wintext = nil
  end
end

class Wall
  def initialize
    @position = [0,0]
    @width = 0
    @height = 0
    @color = 'black'
  end

  def draw
    @wall = Rectangle.new(x:@position[0]* GRID_SIZE, y:@position[1] * GRID_SIZE, height:@height, width:@width, color: @color)
  end

  def set(xy, w, h, c)
    @position = xy
    @width = w*GRID_SIZE
    @height = h*GRID_SIZE
    @color = c
  end

  def get
    return [@position[0], @position[1], @width, @height]
  end
end



game = Game.new
hole = Hole.new
wall1 = Wall.new
wall1.set([50,30],5,1,'red')
walls = []


players = Array.new(2){Player.new}

players[0].set_img(1)
players[1].set_img(2)

update do
  clear
  background = Image.new('golfback.png', width: 1024, height: 640, z: -5)
  wall1.draw
  
  if !win_screen && !$end_menu
    hole.draw
    if $firstp 
      game.draw
      Text.new("PLAYER 1 TURN", x:400, y:0, color:'red', size: 20)
      players[0].draw
      players[0].move
      players[0].collison_with_wall(wall1.get)
      if players[0].x< 0 || players[0].x > 127 || players[0].y < 0 || players[0].y > 77
        players[0].reset
        game.registerHit
      end
      if hole.collison(players[0].x, players[0].y)
        game.registerWin(1)
        win_screen = true
        players[0].reset
      end
    end
    if $secondp
      
      game.draw
      Text.new("PLAYER 2 TURN", x:400, y:0, color:'red', size: 20)
      players[1].draw
      players[1].move
      players[1].collison_with_wall(wall1.get)
      if players[1].x< 0 || players[1].x > 127 || players[1].y < 0 || players[1].y > 77
        players[1].reset
        game.registerHit
      end
      if hole.collison(players[1].x, players[1].y)
        game.registerWin(2)
        win_screen = true
        players[1].reset
      end
    end

  end
  if $scores_p1.length == $scores_p2.length && $scores_p2.length == $round
    $round += 1
    hole.changeLocation
  end
  if $round > 2
    $end_menu = true
    clear
  end
  game.draw

end

on :mouse do |event|
  if $buttonPressed && event.type == :up
    players[0].shoot(event.x, event.y) if $firstp
    players[1].shoot(event.x, event.y) if $secondp
    game.registerHit
    $buttonPressed = false
  end
  if $buttonPressed && event.type == :down
    p cock
    player.updateAngle(event.x, Window.y)
  end
end

on :mouse_down do |event|
  case event.button
  when :left
    if players[0].checkClick(Window.mouse_x, Window.mouse_y) && !$buttonPressed && $firstp
      $buttonPressed = true
    end
    if players[1].checkClick(Window.mouse_x, Window.mouse_y) && !$buttonPressed && $secondp
      $buttonPressed = true
    end
    if win_screen
      win_screen = false
      game.resetText
    end
    if $end_menu
      $round = 1
      $scores_p1 = []
      $scores_p2 = []
      $end_menu = false
    end
  end
end

on :mouse_move do |event|
  if $buttonPressed
    players[0].updateAngle(event.x, event.y) if $firstp
    players[1].updateAngle(event.x, event.y) if $secondp
  end
end


show