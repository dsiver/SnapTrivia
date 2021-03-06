class User < ActiveRecord::Base
  NEW_LEVEL = 'new_level'
  SAME_LEVEL = 'same_level'
  INACTIVE = 'inactive'
  BEGINNER = Merit::BadgeRules::BEGINNER
  INTERMEDIATE = Merit::BadgeRules::INTERMEDIATE
  ADVANCED = Merit::BadgeRules::ADVANCED
  EXPERT  = Merit::BadgeRules::EXPERT
  COST_EXTRA_TIME = 3
  COST_REM_WRONG_ANS = 5
  COST_SKIP_QUESTION = 5
  has_merit

  has_many :games
  validates :games, :presence => false
  has_many :messages
  validates :messages, :presence => false
  has_many :questions
  validates :questions, :presence => false

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
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
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

  def self.experience_levels
    @levels = [BEGINNER, INTERMEDIATE, ADVANCED, EXPERT]
  end

  def soft_delete
    domains = ['.com', '.edu', '.org', '.gov']
    o = [('a'..'z'), ('0'..'9')].map { |i| i.to_a }.flatten
    email = (0...10).map { o[rand(o.length)] }.join
    email += "@"
    email += (0...8).map { o[rand(o.length)] }.join
    email += domains[rand(domains.length)]
    password = (0...8).map {o[rand(o.length)]}.join
    name = self.name + " (" + User::INACTIVE + ")"
    self.update_attributes!(email: email, name: name, password: password, password_confirmation: password, provider: User::INACTIVE)
    self.save!
  end

  def give_coins(quantity)
    if quantity.is_a?(Integer)
      if quantity > 0
        self.lock!
        coins = self.coins
        coins += quantity
        self.update_attributes!(coins: coins)
        self.save!
      else
        fail 'quanity must be greater than zero.'
      end
    else
      fail 'Invalid quantity.'
    end
  end

  def playable_users_by_name(name)
    @users = User.where(name: name).where.not(id: self.id).where.not(name: 'Admin').where.not(provider: User::INACTIVE)
  end

  def playable_users
    User.where.not(id: self.id).where.not(name: 'Admin').where.not(provider: User::INACTIVE)
  end

  def increment_total_questions
    self.lock!
    total = self.total_questions
    total+=1
    self.update_attributes!(:total_questions => total)
    self.save!
  end

  def increment_correct_questions
    self.lock!
    correct = self.correct_questions
    correct+=1
    self.update_attributes!(:correct_questions => correct)
    self.save!
  end

  def apply_question_results(subject, result)
    self.lock!
    old_level = self.level
    increment_total_questions
    increment_correct_questions if result == Question::CORRECT
    apply_result_by_subject(result, subject)
    level_up_player if result == Question::CORRECT
    self.save!
    if self.level > old_level
      give_badge
    else
      SAME_LEVEL
    end
  end

  def level_up_player
    self.lock!
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
    self.lock!
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
    self.lock!
    method_result = Game::LOSER
    game = Game.find(game_id)
    total_games = self.total_games
    total_games += 1
    total_wins = self.total_wins
    if self.id == game.winner_id
      total_wins += 1
      self.give_coins(Game::WINNER_COIN_PRIZE)
      method_result = Game::WINNER
    end
    self.update_attributes!(:total_games => total_games, :total_wins => total_wins)
    self.save!
    give_winner_trophy
    method_result
  end

  def give_extra_time
    give_power_up(Question::EXTRA_TIME)
  end

  def use_extra_time
    #take_power_up(Question::EXTRA_TIME)
    deduct_cost(COST_EXTRA_TIME)
  end

  def has_extra_time?
    #has_power_up?(Question::EXTRA_TIME)
    self.coins >= COST_EXTRA_TIME
  end

  def give_remove_wrong_answers
    give_power_up(Question::REMOVE_WRONG_ANSWERS)
  end

  def use_remove_wrong_answer
    #take_power_up(Question::REMOVE_WRONG_ANSWERS)
    deduct_cost(COST_REM_WRONG_ANS)
  end

  def has_remove_wrong_answers?
    #has_power_up?(Question::REMOVE_WRONG_ANSWERS)
    self.coins >= COST_REM_WRONG_ANS
  end

  def give_skip_question
    give_power_up(Question::SKIP_QUESTION)
  end

  def use_skip_question
    #take_power_up(Question::SKIP_QUESTION)
    deduct_cost(COST_SKIP_QUESTION)
  end

  def has_skip_question?
    #has_power_up?(Question::SKIP_QUESTION)
    self.coins >= COST_SKIP_QUESTION
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
    self.lock!
    if self.level == 2
      unless self.has_badge?(Merit::BadgeRules::BEGINNER_ID)
        self.add_badge(Merit::BadgeRules::BEGINNER_ID)
        self.save!
        Merit::BadgeRules::BEGINNER
      end
    elsif self.level == 11
      unless self.has_badge?(Merit::BadgeRules::INTERMEDIATE_ID)
        self.add_badge(Merit::BadgeRules::INTERMEDIATE_ID)
        self.save!
        return Merit::BadgeRules::INTERMEDIATE
      end
    elsif self.level == 21
      unless self.has_badge?(Merit::BadgeRules::ADVANCED_ID)
        self.add_badge(Merit::BadgeRules::ADVANCED_ID)
        self.save!
        return Merit::BadgeRules::ADVANCED
      end
    elsif self.level == 31
      unless self.has_badge?(Merit::BadgeRules::EXPERT_ID)
        self.add_badge(Merit::BadgeRules::EXPERT_ID)
        self.save!
        return Merit::BadgeRules::EXPERT
      end
    else
      self.save!
      NEW_LEVEL
    end
  end

  def has_badge?(badge_id)
    self.badges.any? { |badge| badge.id == badge_id }
  end

  def experience_level
    if self.level <=10
      BEGINNER
    elsif self.level <= 20
      return INTERMEDIATE
    elsif self.level <= 30
      return ADVANCED
    else
      EXPERT
    end
  end

  def give_winner_trophy
    self.lock!
    if self.total_wins == 1
      unless self.has_badge?(Merit::BadgeRules::FIRST_WIN_ID)
        self.add_badge(Merit::BadgeRules::FIRST_WIN_ID)
      end
    end
    self.save!
  end

  def user_messages
    @user_messages = Message.where(recipient_id: id).to_a
  end

  def unread_messages
    @unread_messages = Message.unread_messages_by_user_id(self.id)
  end

  def number_correct_by_subject(subject)
    return self.art_correct_count if subject == Subject::ART
    return self.entertainment_correct_count if subject == Subject::ENTERTAINMENT
    return self.geography_correct_count if subject == Subject::GEOGRAPHY
    return self.history_correct_count if subject == Subject::HISTORY
    return self.science_correct_count if subject == Subject::SCIENCE
    self.sports_correct_count if subject == Subject::SPORTS
  end

  def total_by_subject(subject)
    return self.art_total_count if subject == Subject::ART
    return self.entertainment_total_count if subject == Subject::ENTERTAINMENT
    return self.geography_total_count if subject == Subject::GEOGRAPHY
    return self.history_total_count if subject == Subject::HISTORY
    return self.science_total_count if subject == Subject::SCIENCE
    self.sports_total_count if subject == Subject::SPORTS
  end

  def adjust_level
    new_level = 0
    new_coins = 0
    (0..self.correct_questions).each { |i|
      if i < 50 && i % 5 == 0
        new_level += 1
        new_coins += 1
      end
      if i >= 60 && i <= 150 && i % 10 == 0
        new_level += 1
        new_coins += 2
      end
      if i >= 160 && i <= 300 && i % 15 == 0
        new_level += 1
        new_coins += 3
      end
      if i > 300 && i % 20 == 0
        new_level += 1
        new_coins += 5
      end
    }
    self.update_attributes(level: new_level, coins: new_coins)
    self.save
  end

  def adjust_badges
    self.add_badge(Merit::BadgeRules::NEW_USER_ID)
    if self.correct_questions >= 5
      self.add_badge(Merit::BadgeRules::BEGINNER_ID)
    end
    if self.correct_questions >= 60
      self.add_badge(Merit::BadgeRules::INTERMEDIATE_ID)
    end
    if self.correct_questions >= 165
      self.add_badge(Merit::BadgeRules::ADVANCED_ID)
    end
    if self.correct_questions >= 320
      self.add_badge(Merit::BadgeRules::EXPERT_ID)
    end
    if self.total_wins > 1
      self.add_badge(Merit::BadgeRules::FIRST_WIN_ID)
    end
    self.save
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  ############################################################
  #####################     PRIVATE     ######################
  ############################################################

  private

  def deduct_cost(amount)
    coins = self.coins
    if amount > coins
      false
    else
      coins -= amount
      self.lock!
      self.update_attributes!(coins: coins)
      self.save!
      true
    end
  end

  def has_power_up?(power_up)
    if power_ups(power_up) > 0
      true
    else
      false
    end
  end

end
