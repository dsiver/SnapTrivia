# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  # config.checks_on_each_request = true

  # Define ORM. Could be :active_record (default) and :mongoid
  # config.orm = :active_record

  # Add application observers to get notifications when reputation changes.
  # config.add_observer 'MyObserverClassName'

  # Define :user_model_name. This model will be used to grand badge if no
  # `:to` option is given. Default is 'User'.
  # config.user_model_name = 'User'

  # Define :current_user_method. Similar to previous option. It will be used
  # to retrieve :user_model_name object if no `:to` option is given. Default
  # is "current_#{user_model_name.downcase}".
  # config.current_user_method = 'current_user'
end

# Create application badges (uses https://github.com/norman/ambry)
# badge_id = 0
# [{
#   id: (badge_id = badge_id+1),
#   name: 'just-registered'
# }, {
#   id: (badge_id = badge_id+1),
#   name: 'best-unicorn',
#   custom_fields: { category: 'fantasy' }
# }].each do |attrs|
#   Merit::Badge.create! attrs
# end

  [{
       id: 1,
       name: 'New User',
       description: 'New user registration',
       custom_fields: { icon: 'fa fa-user-plus', type: 'user_action' }
   },
   {
       id: 2,
       name: 'beginner',
       description: 'Beginner level trophy',
       custom_fields: { icon: 'fa fa-child', type: 'game_play' }
   },
   {
       id: 3,
       name: 'intermediate',
       description: 'Intermediate level trophy',
       custom_fields: { icon: 'fa fa-pencil', type: 'game_play' }
   },
   {
       id: 4,
       name: 'advanced',
       description: 'Advanced level trophy',
       custom_fields: { icon: 'fa fa-university', type: 'game_play' }
   },
   {
       id: 5,
       name: 'expert',
       description: 'Expert level trophy',
       custom_fields: { icon: 'fa fa-graduation-cap', type: 'game_play' }
   },
   {
       id: 6,
       name: 'first_win',
       description: 'Won first round trophy',
       custom_fields: { icon: 'fa fa-trophy', type: 'game_play' }
   }
  ].each do |attrs|
    Merit::Badge.create! attrs
  end