class Question < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  CORRECT = 'CORRECT'
  INCORRECT = 'INCORRECT'
  EXTRA_TIME = 'extra_time'
  REMOVE_WRONG_ANSWERS = 'remove_wrong_answers'
  SKIP_QUESTION = 'skip_question'

  has_one :rating
  accepts_nested_attributes_for :rating
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

<<<<<<< HEAD
  def self.questions_by_difficulty(level)
    if level != Question::DIFFICULTY_LOW && level != Question::DIFFICULTY_MEDIUM && level != DIFFICULTY_HIGH
      fail 'Invalid difficulty level'
    else
      if level == Question::DIFFICULTY_HIGH
        @questions = Question.where(difficulty: Question::DIFFICULTY_HIGH).limit(4)
      else
        @questions = Question.where(difficulty: level).limit(3)
      end
    end
  end

  def self.questions_by_user_experience(experience_level)
    if experience_level != User::BEGINNER && experience_level != User::INTERMEDIATE && experience_level != User::ADVANCED && experience_level != User::EXPERT
      fail 'Invalid experience level'
    else
      @user_questions = questions_by_difficulty(experience_level)
      if experience_level == User::INTERMEDIATE
        @user_questions << Question.where(difficulty: Question::DIFFICULTY_LOW).limit(1)
      else
        @user_questions << Question.where(difficulty: Question::DIFFICULTY_MEDIUM).limit(1)
      end
    end
  end

  def apply_rating(value)
=begin
    ratings_total_value = self.ratings_total_value
    ratings_total_value += value
    rating_count = self.rating_count
    rating_count += 1
    self.update_attributes!(:ratings_total_value => ratings_total_value, :rating_count => rating_count)
    self.save!
=end
=======
  def checkSolution(selected_answer)
    selected_answer == self.rightAns
>>>>>>> 83dddfb5da8a5165c1090f07fccd60c5559f2118
  end

end
