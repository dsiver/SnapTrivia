class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new


    if(@user.admin)
      can :access, :rails_admin
      can :dashboard
      cannot :manage, Game
      cannot :manage, Subject
      can :manage, Question
      can :index, User
      can :read, User
      can :update, User
    end
    if(@user.reviewer)
      can :access, :rails_admin
      can :dashboard
      cannot :manage, Game
      cannot :manage, Subject
      can :index, Question
      can :new, Question
      can :destroy, Question
      can :read, Question
      can :update, Question
      cannot :approve_question, :all
      can :approve_question, Question
    end
  end
end
