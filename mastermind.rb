#!/usr/bin/ruby

class Board
  attr_accessor :guess, :feedback, :secret

  def initialize
    @guess = Array.new(12) { |i| i = ["X","X","X","X"] }
    @feedback = Array.new(12) { |i| i = ["X","X","X","X"] }
    @secret = Array.new(4) { |i| i = "X" }
  end

  def draw(win, secret_code)
    print "-----------------\n"
    i = 0
    if win == false
      while i < @secret.length-1 do
        print "| #{@secret[i]} "
        i += 1
      end
      print "| #{@secret[@secret.length-1]} |\n"
    else #unveil the secret code if @win == true (= game was won or 12 rounds were played)
      while i < secret_code.length-1 do
        print "| #{secret_code[i]} "
        i += 1
      end
      print "| #{secret_code[secret_code.length-1]} |\n"
    end
      print "-----------------\n"


    j = @guess.length-1
    while j >= 0 do
      i = 0
      while i <= @guess[j].length do
        print "| #{@guess[j][i]} "
        i += 1
      end
      k = 0
      while k <= @feedback[j].length do
        print "| #{@feedback[j][k]} "
        k += 1
      end
       print "\n"
      j -= 1
    end
  end
end

class Player
  attr_accessor :name, :role_chose_code
  def initialize
    @name = ""
    @role_chose_code = false
  end

  def get_name
    puts "What is your name?"
    player = gets.chomp
    while player == "" do
      puts "Give your name please!"
      player = gets.chomp
    end
    @name = player.to_s
    puts "Welcome #{@name}!"
  end

  def chose_role
    answer = ""
    puts "Would you like to choose the secret code? Please enter y(es) or n(o)."
    answer = gets.chomp
    while answer != "y" && answer != "n" do
      puts answer
      puts "Invalid choice. Please enter y(es) or n(o)."
      answer = gets.chomp
    end
    if answer == "y"
      @role_chose_code = true
    end
  end

end

class Game
  def initialize
    @colors = ["Y", "O", "R", "P", "B", "G"]
    @secret_code = []
    @board = []
    @counter = 0
    @player = ""
    @win = false
    @pos_and_color_preselect = ["X", "X", "X", "X"]
  end

  def play
    @player = Player.new
    @player.get_name
    @player.chose_role
    @board = Board.new
    chose_secret_code
    while @counter < 12 && @win == false do
      @player.role_chose_code == false ? \
        @board.guess[@counter] = player_guess_or_select : \
        @board.guess[@counter] = computer_guess
      @board.feedback[@counter] = give_feedback
      if @player.role_chose_code == true
        computer_evaluate #ensure correct treatment of items that were marked with "x" and "o"
      end
      check_win
      @board.draw(@win, @secret_code)
      @counter += 1
    end

    if @win == true
      puts "The secret code has been found! Congratulations!"
    elsif @win == false && @counter == 12
      @board.draw(true, @secret_code)
      puts "Game over. The secret code was not found."
    end
  end

  private

  def chose_secret_code
    @secret_code = []
    if @player.role_chose_code == false
      @board.draw(@win, @secret_code)
      @secret_code = computer_select
      puts 'Secret code chosen. Please make your first guess.'
    else
      puts "Chose the secret code."
      @board.draw(@win, @secret_code)
      @secret_code = player_guess_or_select
      puts "Secret code chosen. The computer is starting to guess."
    end
  end

  def player_guess_or_select
    puts "Choose four colors from: yellow (Y), orange (O), red (R), pink (P), blue (B) and green (G)."
    puts "Repetitions are possible. Enter as one string without spaces in between."
    choice = gets.chomp.split("")
    x = choice.all? {|i| @colors.include?(i)}
    while (x == false || choice.length != 4) do #Check correct input
      puts "Invalid choice. Please select exactly four valid colors."
      choice = gets.chomp.split("")
      x = choice.all? {|i| @colors.include?(i)}
    end
    return choice
  end

  def computer_select
    choice = []
    i = 0
    while i < 4 do
        color = rand(@colors.length)
        choice[i] = @colors[color]
        i += 1
    end
    return choice
  end

  def computer_guess
    if @counter == 0
      choice = computer_select
    else
      choice = []
      choice.replace(@pos_and_color_preselect) #use preselection
      i = 0
      while i < 4  do
        if choice[i] == "X" #guess the values that are not preselected
            color = rand(@colors.length)
            choice[i] = @colors[color]
        end
          i += 1
      end
    end
    return choice
  end

  def give_feedback
    choice = @board.guess[@counter]
    secret_code_temp = []
    secret_code_temp.replace(@secret_code)

    i = 0
    j = 0
    feedback = ["-", "-", "-", "-"]

    while i < choice.length do #find items with correct position & color
      if choice[i] == @secret_code[i]
          feedback[i] = "x"
          secret_code_temp.delete_at(j)
          j -=1
      end
      i += 1
      j += 1
    end

    i = 0

    while i < feedback.length do #find items with correct color but wrong position
      if feedback[i] != "x" && secret_code_temp.include?(choice[i])
        feedback[i] = "o"
        secret_code_temp.delete_at(secret_code_temp.index(choice[i]))
      end
        i += 1
    end

    return feedback
  end

  def computer_evaluate
    index_free_choice = [0,1,2,3]

    @board.feedback[@counter].each_with_index do |item, index|
      if item == "x" #keep items with correct color and position
        @pos_and_color_preselect[index] =  @board.guess[@counter][index]
        index_free_choice.delete(index)
      end
    end

    @board.feedback[@counter].each_with_index do |item, index|
      if item == "o" #new guess must include colors that were marked with "o"
        puts "o at #{index}"
          new_pos = rand(index_free_choice.length)
          puts "new_pos #{index_free_choice[new_pos]}"
          @pos_and_color_preselect[index_free_choice[new_pos]] =  @board.guess[@counter][index]
        index_free_choice.delete_at(new_pos)
        puts index_free_choice.inspect
      end
    end
  end

  def check_win
    if @board.feedback[@counter] == ["x", "x", "x", "x"]
      @win = true
    end
  end

end

g = Game.new
g.play
