class Question < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
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
    random_subject = ['Art', 'Entertainment', 'History', 'Geography', 'Science', 'Sports'].sample
    @question = self.random_question_by_subject(random_subject)
  end

end
