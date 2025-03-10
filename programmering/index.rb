logins = File.open("logins.txt", 'a')
logins.close


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

def dice()
  p "Welcome to dice!"
  p "You currently have: #{@cash}$"
  p "how much would you like to bet? (press enter to quit)"
  bet_amount = gets.chomp.to_i



  if bet_amount > @cash || bet_amount < 0
    p "Not sufficient balance or not valid number"
    puts "\e[H\e[2J"
    dice()
    return ""
  elsif bet_amount == 0
    return ""
  end

  p "choose number between 1-6"
  player_num = gets.chomp.to_i
  if ![1,2,3,4,5,6].include?(player_num)
    p "invalid  number!"
    puts "\e[H\e[2J"
    dice()
  end
  random_num = Random.rand(1..6)
  p "rolling dice!"
  sleep(0.5)
  p ""
  p "rolling dice!"
  sleep(0.5)
  p ""
  p "IT LANDS ON #{random_num}"


  if player_num == random_num
    p "You WON! #{bet_amount*5}$"
    @cash += bet_amount*5
  else 
    p "You lost: #{bet_amount}$"
    @cash -= bet_amount
  end
  update_cash()
  p "press enter to continue"
  casino() if gets == "\n"
  

end

####################

def work()
  return ""
end


loop do

  while @logged_in
    puts "\e[H\e[2J"
    load_cash()
    p "You are now logged in as #{@logged_user}"
    p "What would you like to access? Todo | Bank | Casino | Quit"
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
    end

  end
  menu()


end