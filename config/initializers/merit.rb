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
       name: 'New User'
   },
   {
       id: 2,
       name: 'art',
       description: 'Art trophy',
       custom_fields: { icon: 'fa fa-paint-brush', type: 'game_round' }
   },
   {
       id: 3,
       name: 'entertainment',
       description: 'Entertainment trophy',
       custom_fields: { icon: 'fa fa-film', type: 'game_round' }
   },
   {
       id: 4,
       name: 'history',
       description: 'History trophy',
       custom_fields: { icon: 'fa fa-book', type: 'game_round' }
   },
   {
       id: 5,
       name: 'geography',
       description: 'Geography trophy',
       custom_fields: { icon: 'fa fa-globe', type: 'game_round' }
   },
   {
       id: 6,
       name: 'science',
       description: 'Science trophy',
       custom_fields: { icon: 'fa fa-flask', type: 'game_round' }
   },
   {
       id: 7,
       name: 'sports',
       description: 'Sports trophy',
       custom_fields: { icon: 'fa fa-futbol-o', type: 'game_round' }
   }
  ].each do |attrs|
    Merit::Badge.create! attrs
  end