logins = File.open("logins.txt", 'a') #Skapar en "logins.txt" fil 
logins.close

logins = File.readlines('logins.txt')

logins << "hallå"

cock = File.open("logins.txt", "w")
logins.each_with_index do |event,index|
  cock.puts(logins(index))
end


def load_logins()
  logins = File.readlines('logins.txt')

  logins.each_with_index do |user, i|
    logins[i] = user.chomp
  end
  
  logins.each_with_index do |user, i|
    @usernames << user.split(" ")[0]
    @passwords << user.split(" ")[1]
  end
end

logins = File.readlines('logins.txt')

@usernames = []
@passwords = []
@cash = 0


@logged_in = false

@logged_user = ""

logins.each_with_index do |user, i|
  logins[i] = user.chomp
end

logins.each_with_index do |user, i|
  @usernames << user.split(" ")[0]
  @passwords << user.split(" ")[1]
end


#LOGIN / SIGNIN Menus

def check_user(username, password)

  if @usernames.include?(username)
    if password == @passwords[@usernames.index(username)]
      @logged_in = true
      @logged_user = username
      p "Login successfull!"
    else
        puts "\e[H\e[2J"
      p "Wrong Username Or Password"
    end
  else
      puts "\e[H\e[2J"
    p "Wrong Username Or Password"
    
  end
end


def login_menu()

  puts "LOGIN MENU"
  puts "Enter USERNAME:"
  username_in = gets.chomp
  puts "Enter PASSWORD:"
  password_in = gets.chomp
  check_user(username_in, password_in)
end

def sign_up()
  p "SIGNIN MENU"
  p "Enter uniqe USERNAME:"
  username_in = gets.chomp
  if @usernames.include?(username_in)
    puts "\e[H\e[2J"
    p "There is alreade a user named #{username_in}"
    sign_up()
  else
    p "Enter PASSWORD"
    password_in = gets.chomp
    logins = File.open("logins.txt", 'a')
    logins.puts "\n#{username_in} #{password_in}"
    logins.close
    puts "\e[H\e[2J"
    p "SIGNUP completed. Login!"
    load_logins()
    login_menu()
  end
end

def menu()
  p "Login or Signup?"
  choice = gets.chomp.downcase
  login_menu() if choice == "login"
  sign_up() if choice == "signup"
end

###############

#Pengar Funktioner

def bank(user)
  load_cash()
  puts "\e[H\e[2J"
  p "Welcome #{user} to your Bank"
  p "You currently have: #{@cash} $"
  p "Press enter to go back!"
  if gets == "\n"
    return ""
  end
  bank_append.close
end

def load_cash()
  bank_append = File.open("bank/#{@logged_user}.txt", 'a')
  bank_details = File.readlines("bank/#{@logged_user}.txt")
  bank_append.puts "80" if bank_details[0] == nil
  bank_append.close
  bank_details = File.readlines("bank/#{@logged_user}.txt")
  @cash = bank_details[0].chomp.to_i
end

def update_cash()
  bank_write = File.open("bank/#{@logged_user}.txt", 'w')
  bank_write.puts "#{@cash}"
  bank_write.close
end

def add_cash(amount)
  @cash += amount
  update_cash()
end

def remove_cash(amount)
  @cash -= amount
  update_cash()
end

############

#Casino Funktioner

def casino()
  puts "\e[H\e[2J"
  choice = ""
  p "Welcome #{@logged_user} to the CASINO!!"
  p "Which gamemode would you like to play?"
  p "Coinflip, Dice, Roulette or press enter to quit"
  choice = gets.chomp.downcase

  if ["cj", "coinflip", "cflip"].include?(choice)
    choice = ""
    coinflip()
  elsif choice == "dice"
    choice = ""
    dice()
  elsif choice == "\n"
    choice = ""
    return ""
  end

end


#Dice Funktion
def dice()
  #Välkomst Text
  p "Welcome to dice!"
  p "You currently have: #{@cash}$"
  p "how much would you like to bet? (press enter to quit)"
  bet_amount = gets.chomp.to_i #Hur mycket spelaren vill betta

  if bet_amount > @cash || bet_amount < 0 #Kolla om man har tillräckligt med pengar och kolla om det är ett giltigt nummer
    p "Not sufficient balance or not valid number"
    puts "\e[H\e[2J"
    dice() #Om inte så startar man om dice
    return ""
  elsif bet_amount == 0 #Om man inte inputar något, så blir man tillbaka skickad till start skärmen
    return ""
  end

  p "choose number between 1-6"

  player_num = gets.chomp.to_i #Får in spelarens nummer

  if ![1,2,3,4,5,6].include?(player_num) #Kollar så att spelarens nummer är giltigt
    p "invalid  number!"
    puts "\e[H\e[2J"
    dice() #Startar om spelet om det inte är det
  end

  random_num = Random.rand(1..6) #Genererar en random siffra

  #Visulla delen av spelet
  sleep(1)
  print "\n"
  p "rolling dice!"
  sleep(1)
  print "\n"
  p "rolling dice!"
  sleep(1)
  print "\n"  
  p "IT LANDS ON #{random_num}"

  #Kollar om spelaren viunnit/förlorat.

  if player_num == random_num #Om vunnit, får spelaren 5gånger pengarna han lade in
    p "You WON! #{bet_amount*5}$"
    add_cash(bet_amount*5)
  else #Om förlorat
    p "You lost: #{bet_amount}$"
    remove_cash(bet_amount)
  end
  p "press enter to continue"
  if gets == "\n"
    puts "\e[H\e[2J"
    dice()
  end
end

def coinflip()
  p "Welcome to coinflip"
  p "You currently have: #{@cash}$"
  p "how much would you like to bet? (press enter to quit)"
  bet_amount = gets.chomp.to_i



  if bet_amount > @cash || bet_amount < 0
    puts "\e[H\e[2J"
    p "Not sufficient balance or not valid number"
    coinflip()
    return ""
  elsif bet_amount == 0
    return ""
  end

  p "choose heads or tails"
  player_in = gets.chomp
  if !["heads", "h", "tails", "t"].include?(player_in)
    puts "\e[H\e[2J"
    p "invalid  input"
    coinflip()
  end

  if ["heads", "h"].include?(player_in)
    player_in = 1
  elsif ["tails", "t"].include?(player_in)
    player_in = 2
  end

  random_num = Random.rand(1..2)
  print "\n"
  sleep(1)
  p "Flipping Coin!"
  print "\n"
  sleep(1)
  p "Flipping Coin"
  print "\n"
  sleep(1)
  p "Flipping Coin!"
  print "\n"  
  sleep(1)
  print "IT LANDS ON: "
  print "HEADS" if random_num == 1
  print "TAILS" if random_num == 2
  print("\n")

  if player_in == random_num
    p "You WON! #{bet_amount}$"
    add_cash(bet_amount)
  else 
    p "You lost: #{bet_amount}$"
    remove_cash(bet_amount)
  end
  update_cash()
  p "press enter to continue"
  if gets == "\n"
    puts "\e[H\e[2J"
    coinflip()
  end
end

####################

# WORK

texts = ["it must've been love", "but its over now", "hallo? HALLO? HALLLOOO?", "Hej, jag heter Bogdan", "Vilket underbart spel detta är", "Ja må han leva, ja må han leva"]

def work()
  texts = ["it must've been love", "but its over now", "hallo? HALLO? HALLLOOO?", "Hej, jag heter #{@logged_user}", "Vilket underbart spel detta är", "Ja må han leva, ja må han leva", "#{@logged_user} is really beautiful", "Ska vi ut och strutsa?"]
  p "Welcome to the job (press enter to quit)"
  p "You are a writer. You earn 25dollar per text"
  p "write the text:"
  current_text = texts[Random.rand(0..texts.length-1)]
  print ("#{current_text}\n")
  user_text = gets.chomp
  if user_text == ""
    return ""
  end
  p "CHECKING INPUT!"
  sleep(0.5)
  print("\n")
  print(".")
  sleep(0.5)
  print(".")
  sleep(0.5)
  print(".\n\n")
  sleep(0.5)
  if current_text == user_text
    p "YOU WROTE CORRECTLY: you earned 25$" 
    add_cash(25)
    p "press enter to work again"
    if gets == "\n"
      puts "\e[H\e[2J"
      work()
    end
  else
    p"You wrote wrong!"
    p "press enter to try again"
    if gets == "\n"
      puts "\e[H\e[2J"
      work()
    end

  end

end

#########


loop do

  while @logged_in
    puts "\e[H\e[2J"
    load_cash()
    p "You are now logged in as #{@logged_user}"
    p "What would you like to access? Work | Bank | Casino | Quit"
    choice = gets.chomp.downcase
    if choice == "quit"
      @logged_in = false
      break
    end

    if choice == "bank"
      bank(@logged_user)
    elsif choice == "casino"
      puts "\e[H\e[2J"
      casino()
    elsif choice == "work"
      puts "\e[H\e[2J"
      work()
    end

  end
  menu()
end