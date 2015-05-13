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
  DIFFICULTY_LEVELS = [DIFFICULTY_LOW, DIFFICULTY_MEDIUM, DIFFICULTY_HIGH]
  EASY = 'easy'
  MEDIUM = 'medium'
  HARD = 'hard'
  NONE = 'none'
  RATINGS = [EASY, MEDIUM, HARD, NONE]

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
        @user_questions += questions_by_difficulty(Question::DIFFICULTY_MEDIUM, subject, 1)
        @user_questions.shuffle!
      elsif experience_level == User::INTERMEDIATE
        @user_questions = questions_by_difficulty(Question::DIFFICULTY_MEDIUM, subject, 3)
        @user_questions += questions_by_difficulty(Question::DIFFICULTY_LOW, subject, 1)
        @user_questions.shuffle!
      elsif experience_level == User::ADVANCED
        @user_questions = questions_by_difficulty(Question::DIFFICULTY_MEDIUM, subject, 3)
        @user_questions += questions_by_difficulty(Question::DIFFICULTY_HIGH, subject, 1)
        @user_questions.shuffle!
      else
        @user_questions = questions_by_difficulty(Question::DIFFICULTY_HIGH, subject, 3)
        @user_questions += questions_by_difficulty(Question::DIFFICULTY_MEDIUM, subject, 1)
        @user_questions.shuffle!
      end
    end
  end

  def apply_rating(rating)
    if RATINGS.include?(rating)
      case rating
        when EASY
          count = self.easy_ratings + 1
          self.update_attributes!(easy_ratings: count)
          self.save!
          true
        when MEDIUM
          count = self.medium_ratings + 1
          self.update_attributes!(medium_ratings: count)
          self.save!
          true
        when HARD
          count = self.hard_ratings + 1
          self.update_attributes!(hard_ratings: count)
          self.save!
          true
        else
          false
      end
    else
      fail 'Invalid rating.'
    end
  end

  def fifty_fifty
    [self.rightAns, self.wrongAns1]
  end
end
