# Be sure to restart your server when you modify this file.
#
# +grant_on+ accepts:
# * Nothing (always grants)
# * A block which evaluates to boolean (recieves the object as parameter)
# * A block with a hash composed of methods to run on the target object with
#   expected values (+votes: 5+ for instance).
#
# +grant_on+ can have a +:to+ method name, which called over the target object
# should retrieve the object to badge (could be +:user+, +:self+, +:follower+,
# etc). If it's not defined merit will apply the badge to the user who
# triggered the action (:action_user by default). If it's :itself, it badges
# the created object (new user for instance).
#
# The :temporary option indicates that if the condition doesn't hold but the
# badge is granted, then it's removed. It's false by default (badges are kept
# forever).

module Merit
  class BadgeRules
    include Merit::BadgeRulesMethods
    # Models
    USER = 'User'
    # Types
    TYPE_USER_ACTION = 'user_action'
    TYPE_GAME_PLAY = 'game_play'

    ## USER_ACTION related
    # New user registration
    NEW_USER = 'New User'
    NEW_USER_ICON = "fa fa-user-plus"

    ## GAME_PLAY related
    # Wins first game
    FIRST_WIN = 'First Win'
    FIRST_WIN_ICON = "fa fa-trophy"

    # Player levels up
    BEGINNER = 'Beginner'
    BEGINNER_ICON = "fa fa-child"

    INTERMEDIATE = 'Intermediate'
    INTERMEDIATE_ICON = "fa fa-pencil"

    ADVANCED = 'Advanced'
    ADVANCED_ICON = "fa fa-university"

    EXPERT = 'Expert'
    EXPERT_ICON = "fa fa-graduation-cap"

    # IDS
    NEW_USER_ID = 1
    BEGINNER_ID = 2
    INTERMEDIATE_ID = 3
    ADVANCED_ID = 4
    EXPERT_ID = 5
    FIRST_WIN_ID = 6

    def initialize
      # If it creates user, grant badge
      # Should be "current_user" after registration for badge to be granted.
      # Find badge by badge_id, badge_id takes presidence over badge
      # grant_on 'users#create', badge_id: 7, badge: 'just-registered', to: :itself

      # If it has 10 comments, grant commenter-10 badge
      # grant_on 'comments#create', badge: 'commenter', level: 10 do |comment|
      #   comment.user.comments.count == 10
      # end

      # If it has 5 votes, grant relevant-commenter badge
      # grant_on 'comments#vote', badge: 'relevant-commenter',
      #   to: :user do |comment|
      #
      #   comment.votes.count == 5
      # end

      # Changes his name by one wider than 4 chars (arbitrary ruby code case)
      # grant_on 'registrations#update', badge: 'autobiographer',
      #   temporary: true, model_name: 'User' do |user|
      #
      #   user.name.length > 4
      # end

      ### User Action Trophies ###
      # New user registration
      grant_on 'registrations#create', badge: 'New User', model_name: 'User'

      # Wins first game
      grant_on 'game#merit', badge: FIRST_WIN, to: :action_user, model_name: USER, multiple: false
      grant_on 'game#merit', badge: BEGINNER, to: :action_user, model_name: USER, multiple: false
      grant_on 'game#merit', badge: INTERMEDIATE, to: :action_user, model_name: USER, multiple: false
      grant_on 'game#merit', badge: ADVANCED, to: :action_user, model_name: USER, multiple: false
      grant_on 'game#merit', badge: EXPERT, to: :action_user, model_name: USER, multiple: false
    end
  end
end
