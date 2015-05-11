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

  def self.get_questions_by_difficulty(level)
    @questions = Question.where(difficulty: level)
  end
end