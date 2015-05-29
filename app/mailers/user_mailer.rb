class UserMailer < ApplicationMailer
  default from: "snaptriviagame@gmail.com"

  def new_game_email(user, game)
    @player1 = user
    @game = game
    @player2 = @game.opponent(@player1.id)
    mail(to: @player2.email, subject: "You Have a New Game!")
  end
end
