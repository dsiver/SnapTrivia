class User < ActiveRecord::Base
  NEW_LEVEL = 'new_level'
  SAME_LEVEL = 'same_level'
  has_merit

  has_many :games
  validates :games, :presence => false
  has_many :messages
  validates :messages, :presence => false
  has_many :questions
  validates :questions, :presence => false
  #has_paper_trail :only => [:request_reviewer]

  # Set default values not handled in previous migrations
  after_initialize :defaults
  def defaults
    self.admin = false if self.admin.nil?
    self.reviewer = false if self.reviewer.nil?
    self.provider ||= 'self'
  end

  # Social media login
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data == session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    #Create user if none
    unless user
      user = User.create(name: data["name"],
                         email: data["email"],
                         password: Devise.friendly_token[0,20],
                         image: data["image"],
                         provider: 'google'
      )
    end
    user
  end

  def increment_total_questions
    total = self.total_questions
    total+=1
    self.update_attributes!(:total_questions => total)
    self.save!
  end

  def increment_correct_questions
    correct = self.correct_questions
    correct+=1
    self.update_attributes!(:correct_questions => correct)
    self.save!
  end

  def apply_question_results(subject, result)
    old_level = self.level
    increment_total_questions
    increment_correct_questions if result == Question::CORRECT
    apply_result_by_subject(result, subject)
    level_up_player
    if self.level > old_level
      give_badge
      return NEW_LEVEL
    end
    SAME_LEVEL
  end

  def level_up_player
    level = self.level
    coins = self.coins
    case self.correct_questions
      when 0..49
        if self.correct_questions % 5 == 0
          level += 1
          coins += 1
        end
      when 60..150
        if self.correct_questions % 10 == 0
          level += 1
          coins += 2
        end
      when 160..300
        if self.correct_questions % 15 == 0
          level += 1
          coins += 3
        end
      else
        if self.correct_questions % 20 == 0
          level += 1
          coins += 5
        end
    end
    self.update_attributes!(:level => level, :coins => coins)
    self.save!
  end

  def apply_result_by_subject(result, subject)
    case subject
      when Subject::ART
        correct = self.art_correct_count
        correct += 1 if result == Question::CORRECT
        total = self.art_total_count + 1
        self.update_attributes!(:art_correct_count => correct, :art_total_count => total)
      when Subject::ENTERTAINMENT
        correct = self.entertainment_correct_count
        correct += 1 if result == Question::CORRECT
        total = self.entertainment_total_count + 1
        self.update_attributes!(:entertainment_correct_count => correct, :entertainment_total_count => total)
      when Subject::HISTORY
        correct = self.history_correct_count
        correct += 1 if result == Question::CORRECT
        total = self.history_total_count + 1
        self.update_attributes!(:history_correct_count => correct, :history_total_count => total)
      when Subject::GEOGRAPHY
        correct = self.geography_correct_count
        correct += 1 if result == Question::CORRECT
        total = self.geography_total_count + 1
        self.update_attributes!(:geography_correct_count => correct, :geography_total_count => total)
      when Subject::SCIENCE
        correct = self.science_correct_count
        correct += 1 if result == Question::CORRECT
        total = self.science_total_count + 1
        self.update_attributes!(:science_correct_count => correct, :science_total_count => total)
      when Subject::SPORTS
        correct = self.sports_correct_count
        correct += 1 if result == Question::CORRECT
        total = self.sports_total_count + 1
        self.update_attributes!(:sports_correct_count => correct, :sports_total_count => total)
      else
        # type code here
    end
    self.save!
  end

  def apply_game_result(game_id)
    method_result = Game::LOSER
    game = Game.find(game_id)
    total_games = self.total_games
    total_games += 1
    total_wins = self.total_wins
    if self.id == game.winner_id
      total_wins += 1
      give_winner_trophy
      method_result = Game::WINNER
    end
    self.update_attributes!(:total_games => total_games, :total_wins => total_wins)
    self.save!
    method_result
  end

  def give_extra_time
    give_power_up(Question::EXTRA_TIME)
  end

  def use_extra_time
    take_power_up(Question::EXTRA_TIME)
  end

  def give_remove_wrong_answers
    give_power_up(Question::REMOVE_WRONG_ANSWERS)
  end

  def use_remove_wrong_answer
    take_power_up(Question::REMOVE_WRONG_ANSWERS)
  end

  def give_skip_question
    give_power_up(Question::SKIP_QUESTION)
  end

  def use_skip_question
    take_power_up(Question::SKIP_QUESTION)
  end

  def give_power_up(type)
    self.add_points(1, category: type) if type == Question::EXTRA_TIME
    self.add_points(1, category: type) if type == Question::REMOVE_WRONG_ANSWERS
    self.add_points(1, category: type) if type == Question::SKIP_QUESTION
  end

  def take_power_up(type)
    self.subtract_points(1, category: type) if type == Question::EXTRA_TIME
    self.subtract_points(1, category: type) if type == Question::REMOVE_WRONG_ANSWERS
    self.subtract_points(1, category: type) if type == Question::SKIP_QUESTION
  end

  def power_ups(type)
    self.points(category: type)
  end

  def give_badge
    if self.level == 2
      self.add_badge(Merit::BadgeRules::BEGINNER_ID)
    elsif self.level == 11
      self.add_badge(Merit::BadgeRules::INTERMEDIATE_ID)
    elsif self.level == 21
      self.add_badge(Merit::BadgeRules::ADVANCED_ID)
    elsif self.level == 31
      self.add_badge(Merit::BadgeRules::EXPERT_ID)
    end
  end

  def has_badge?(badge_id)
    self.badges.any? { |badge| badge.id == badge_id }
  end

  def give_winner_trophy
    if self.total_wins == 1
      self.add_badge(Merit::BadgeRules::FIRST_WIN_ID)
    end
  end

  def user_messages
    @user_messages = Message.where(recipient_id: id).to_a
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  private



end
