class QuestionsController < ApplicationController

  # gets all questions sets to @questions
  def index
    @questions = Question.all
  end

  # shows question only for display
  def show
    @question = Question.find(params[:id])

    respond_to do |format|
      format.html
      format.xml {render :xml => @question}
    end
  end


  def new
  end

  # creates new question checks params
  def create
    @question = Question.new(question_params)
    @question.save
    notify_reviewers
    redirect_to @question
  end

  # private check for params
  private
  def question_params
    params.require(:question).permit(:id, :title, :rightAns, :wrongAns1, :wrongAns2, :wrongAns3, :subject_title, :approved, :difficulty)
  end



  def notify_reviewers
    User.where(reviewer: true).find_each do |user|
      message = Message.create( { :sender_id => 0, :payload => @question.id, :subject => 'New Question', :body => @question.title, :sender_name => 'system', :recipient_name => user.name, :recipient_id => user.id } )
      message.save
    end
    flash[:notice] = 'Reviewers have been notified. Your question is pending'
  end
end
