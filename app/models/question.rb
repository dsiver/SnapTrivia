class Question < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  CORRECT = 'CORRECT'
  INCORRECT = 'INCORRECT'
  EXTRA_TIME = 'extra_time'
  REMOVE_WRONG_ANSWERS = 'remove_wrong_answers'
  SKIP_QUESTION = 'skip_question'
  DIFFICULTY_LOW = 1
  DIFFICULTY_MEDIUM = 2
  DIFFICULTY_HIGH = 3

  has_one :subject
  accepts_nested_attributes_for :subject
  belongs_to :user

  validates :title, presence: true
  validates :rightAns, presence: true
  validates :wrongAns1, presence: true
  validates :wrongAns2, presence: true
  validates :wrongAns3, presence: true
  validates :subject_title, presence: true


  # Gets question by subject
  def self.question_by_subject(sub)
    @question = Question.where("questions.subject_title" => sub)
  end

  def self.questions_by_subject(subject)
    @questions = Question.where(subject_title: subject)
  end

  def self.random_question_by_subject(subject)
    questions = self.question_by_subject(subject)
    questions.offset(rand(questions.count)).first
  end

  def self.random_question_id(subject)
    question = Question.random_question_by_subject(subject)
    question.id
  end

  def self.random_question_random_subject
    random_subject = Subject::subjects.sample
    @question = self.random_question_by_subject(random_subject)
  end

  def self.questions_by_difficulty(level, subject, quantity)
    if level != Question::DIFFICULTY_LOW && level != Question::DIFFICULTY_MEDIUM && level != DIFFICULTY_HIGH
      fail 'Invalid difficulty level'
    elsif !Subject.subject_valid?(subject)
      fail 'Invalid subject'
    elsif !quantity.integer?
      fail 'Invalid quantity'
    else
      @questions = Question.where(difficulty: level, subject_title: subject).limit(quantity)
    end
  end

  def self.questions_by_user_experience(experience_level, subject)
    if !User.experience_levels.include?(experience_level)
      fail 'Invalid experience level'
    elsif !Subject.subject_valid?(subject)
        fail 'Invalid subject'
    else
      if experience_level == User::BEGINNER
        @user_questions = questions_by_difficulty(Question::DIFFICULTY_LOW, subject, 3)
        @user_questions << questions_by_difficulty(Question::DIFFICULTY_MEDIUM, subject, 1)
      elsif experience_level == User::INTERMEDIATE
        @user_questions = questions_by_difficulty(Question::DIFFICULTY_MEDIUM, subject, 3)
        @user_questions << questions_by_difficulty(Question::DIFFICULTY_LOW, subject, 1)
      elsif experience_level == User::ADVANCED
        @user_questions = questions_by_difficulty(Question::DIFFICULTY_MEDIUM, subject, 3)
        @user_questions << questions_by_difficulty(Question::DIFFICULTY_HIGH, subject, 1)
      else
        @user_questions = questions_by_difficulty(Question::DIFFICULTY_HIGH, subject, 3)
        @user_questions << questions_by_difficulty(Question::DIFFICULTY_MEDIUM, subject, 1)
      end
    end
  end

  def apply_rating(value)
    ratings_total_value = self.ratings_total_value
    ratings_total_value += value
    ratings_count = self.ratings_count
    ratings_count += 1
    self.update_attributes!(:ratings_total_value => ratings_total_value, :rating_count => ratings_count)
    self.save!
  end
end
