class User < ActiveRecord::Base
  EXTRA_TIME = 'extra_time'
  REMOVE_WRONG_ANSWERS = 'remove_wrong_answers'
  SKIP_QUESTION = 'skip_question'

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

  def add_point_correct_questions
    correct = self.correct_questions
    correct+=1
    self.update_attributes!(:correct_questions => correct)
    self.save!
  end

  def apply_question_results(subject, result)
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

  def give_extra_time
    give_power_up(EXTRA_TIME)
  end

  def use_extra_time
    take_power_up(EXTRA_TIME)
  end

  def give_remove_wrong_answers
    give_power_up(REMOVE_WRONG_ANSWERS)
  end

  def use_remove_wrong_answer
    take_power_up(REMOVE_WRONG_ANSWERS)
  end

  def give_skip_question
    give_power_up(SKIP_QUESTION)
  end

  def use_skip_question
    take_power_up(SKIP_QUESTION)
  end

  def give_power_up(type)
    self.add_points(1, category: type) if type == EXTRA_TIME
    self.add_points(1, category: type) if type == REMOVE_WRONG_ANSWERS
    self.add_points(1, category: type) if type == SKIP_QUESTION
  end

  def take_power_up(type)
    self.subtract_points(1, category: type) if type == EXTRA_TIME
    self.subtract_points(1, category: type) if type == REMOVE_WRONG_ANSWERS
    self.subtract_points(1, category: type) if type == SKIP_QUESTION
  end

  def power_ups(type)
    self.points(category: type)
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
