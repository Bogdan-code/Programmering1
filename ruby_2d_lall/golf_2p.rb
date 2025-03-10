require 'ruby2d'
GRID_SIZE = 8

#initialiserar skärmen
set title: "GOLF 2P", background: 'white', width: GRID_SIZE*128, height: GRID_SIZE*80, z:-100
set fps_cap:120

#initialiserar alla globala variabler
$buttonPressed = false
win_screen = false
$end_menu = false
$scores_p1 = []
$scores_p2 = []

$firstp = true
$secondp = false
$round = 1

rounds = 2


class Player #Player klassen, används för att göra spelare1 och spelare2

  def initialize#Initialiserar velocitet, spelarens angle, positionen och spelarens bild
    @velocity= 0
    @angle = 0
    @position = [60,40]
    @player_img = ''
  end

  def draw #skriver ut spelaren
    @player = Image.new(@player_img,x: @position[0] * GRID_SIZE, y:@position[1] * GRID_SIZE,  color: 'white', rotate:@angle)
  end

  def set_img(id) #sätter spelarens bild beroende på vilket id man får in
    if id == 1
      @player_img = 'boll2.png'
    else
      @player_img = 'boll3.png'
    end
  end

  def move #hanterar rörelsen på bollen
    
    if @velocity.abs < 0.2 #Ser till att bollen stannar om den har en velocitet mindre än 0.2
      @velocity = 0
    end

    radians = @angle * Math::PI / 180 #Räknar ut vilken angle som spelaren ska ha

    x_comp = Math.sin(radians)
    y_comp = Math.cos(radians)


    @position[0] += x_comp * @velocity # hanterar x rörelsen
    @position[1] -= y_comp * @velocity # hanterar y rörelsen
    @velocity -= @velocity ** 0.05 #friktion
    @velocity = @velocity.to_i


  end
  def checkClick(x, y) #Kollar om man trycker på spelaren

    ((@position[0]* GRID_SIZE).to_i..((@position[0]+4)* GRID_SIZE).to_i).to_a.include?(x) && ((@position[1]* GRID_SIZE).to_i..((@position[1]+4)* GRID_SIZE).to_i).to_a.include?(y)
  end

  def shoot(x, y) # Hanterar skottet (ökar velocitet)


    # @velocity_x = (x - (@position[0] * GRID_SIZE) ) /50
    # @velocity_y = (y - (@position[1] * GRID_SIZE) ) / 50
    ball_screen_x = @position[0] * GRID_SIZE
    ball_screen_y = @position[1] * GRID_SIZE

    dx = x - ball_screen_x
    dy = y - ball_screen_y

    dist = Math.sqrt(dx*dx + dy*dy)

    @velocity = dist / 25


  end 

  #skickar tillbaka spelaren x/y position
  def x
    @position[0]
  end

  def y
    @position[1]
  end

  def reset() #resettar spelarens position och velocitet
    @position = [60,40]
    @velocity = 0
    self.draw
  end

  def updateAngle(x, y) #updaterar spelaren angle, när man trycker ner och ändrar vart man ska skjuta
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
end


class Hole # Hål klassen

  def initialize #initialiserar hålets postion
    @position = [rand((Window.width/8)-10).to_i, rand((Window.height/8)-10).to_i]
  end

  def draw #ritar ut hålet
    @hole = Square.new(x:(@position[0] * GRID_SIZE), y:(@position[1]*GRID_SIZE), size: GRID_SIZE*5, color: 'black')
  end

  def collison(x, y)#kollar om spelaren och hålet kolliderar. returnerar true/false
    (x.to_i..x.to_i+3).to_a.intersect?((@position[0]..@position[0]+4).to_a) && (y.to_i..y.to_i+3).to_a.intersect?((@position[1]..@position[1]+4).to_a)
  end

  def changeLocation #ändrar hålets postion
    @position = [rand((Window.width/8)-10).to_i, rand((Window.height/8)-10).to_i]
    self.draw
  end
end

class Game # Game klassen

  def initialize #initialiserar slag, vinster, rundor och wintext
    @hits = 0
    @wins = 0
    @round = 1
    @wintext = nil
  end

  def draw #skriver ut all text och bakgrund

    if !$end_menu #körs när man spelar
      Text.new("Hits: #{@hits}",x:20, y:20, color:"black", size:25)
      Text.new("Round: #{$round}",x:500, y:20, color:"black", size:25)
    end
    if @wintext && !$end_menu #körs om man träffat hålet
      Text.new(@wintext, x:250,y:200, color:'yellow', size:50)
    end

    if $end_menu # skriver ut poängkortet
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

  def registerHit #registrerar att man slagit bollen
    @hits += 1
    self.draw
  end 

  def registerWin(player) #registrear vinst och ändrar wintext till rätt sak(beroende på antal slag)
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
    
    #lägger in antalet slag in i rätt spelares score card
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

#Skapar hålet, spelet och spelarna
hole = Hole.new
game = Game.new
players = Array.new(2){Player.new}

#sätter rätt bild till rätt spelare
players[0].set_img(1)
players[1].set_img(2)


#Game loop
update do
  clear
  background = Image.new('golfback.png', width: 1024, height: 640, z: -5) #sätter backgrunden
  
  if !win_screen && !$end_menu #själva spelandet
    hole.draw

    if $firstp #Körs när det är player1's tur
      game.draw
      Text.new("PLAYER 1 TURN", x:400, y:0, color:'red', size: 20)#Skriver ut vems tur det är
      players[0].draw #Ritar spelaren
      players[0].move #Flyttar spelaren(kommer bara flyttas om velociteten ändras)
      if players[0].x< 0 || players[0].x > 127 || players[0].y < 0 || players[0].y > 77 #kollar om spelaren har åkt out of bounds
        players[0].reset #resetar
        game.registerHit #lägger till ett extra slag
      end
      if hole.collison(players[0].x, players[0].y) #Om spelaren kolliderar med hålet
        #registrear vinst, gör så att win_screen visas och resettar spelaren
        game.registerWin(1)
        win_screen = true
        players[0].reset
      end
    end
    if $secondp #Körs när det är player2's tur
      #samma sak som för spelare1
      game.draw
      Text.new("PLAYER 2 TURN", x:400, y:0, color:'red', size: 20)
      players[1].draw
      players[1].move
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

  if $scores_p1.length == $scores_p2.length && $scores_p2.length == $round #kollar om spelarna har lika långa scores
    $round += 1 #ökar round
    hole.changeLocation #byter hålets plats
  end
  if $round > rounds #om antalet rundor spelade blir större än antalet rundor som ska spelas
    $end_menu = true #visar slut menyn(score card)
    clear #rensar skärmen
  end
  game.draw #ritar ut spelet

end

on :mouse do |event| #kollar alla musens inputs
  if $buttonPressed && event.type == :up #Kollar om man har tryckt ner på spelaren och lyft knappen
    players[0].shoot(event.x, event.y) if $firstp #skjuter iväg spelare 1
    players[1].shoot(event.x, event.y) if $secondp #skjuter iväg spelare 2
    game.registerHit #registrerar slag
    $buttonPressed = false #ändrar så att man inte har tryck ner på spelaren
  end
  if $buttonPressed && event.type == :down # kollar om man trycker ner på spelaren.
    player.updateAngle(event.x, Window.y)
  end
end

on :mouse_down do |event|
  case event.button
  when :left #kollar om man tryckt ner med left click
    if players[0].checkClick(Window.mouse_x, Window.mouse_y) && !$buttonPressed && $firstp #kollar om man tryckt ner på spelaren
      $buttonPressed = true
    end
    if players[1].checkClick(Window.mouse_x, Window.mouse_y) && !$buttonPressed && $secondp #kollar om man tryckt ner på spelaren
      $buttonPressed = true
    end
    if win_screen #kollar om man tryckt på win_screen
      win_screen = false # tar bort winscreen
      game.resetText
    end
    if $end_menu #kollar om man tryckt på end_menu
      #nollställer alla värden
      $round = 1
      $scores_p1 = []
      $scores_p2 = []
      $end_menu = false
    end
  end
end

on :mouse_move do |event| #kollar mus rörelse
  if $buttonPressed #kollar om spelaren är nertryckt och ändrar angle
    players[0].updateAngle(event.x, event.y) if $firstp
    players[1].updateAngle(event.x, event.y) if $secondp
  end
end

show