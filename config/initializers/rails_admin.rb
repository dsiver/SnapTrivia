RailsAdmin.config do |config|
  require Rails.root.join('lib', 'rails_admin', 'approve_question.rb')
  #RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::ApproveQuestion)

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan
  config.current_user_method &:current_user

  ## == PaperTrail ==
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0
  #config.audit_with :paper_trail, 'User', 'Version' # PaperTrail < 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.included_models = ['User', 'Question']

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    #bulk_delete
    show
    edit
    #delete
    show_in_app
    approve_question
    ## With an audit adapter, you can add:
    history_index
    history_show
  end

  ### configure what is viewable in the dashboard
  config.model 'Game' do
    associated_collection_cache_all = false
  end

  config.model 'Message' do
    associated_collection_cache_all = false
  end

  config.model 'PlayerStat' do
    associated_collection_cache_all = false
  end

  config.model 'Question' do
    associated_collection_cache_all = false
    list do
      field :id
      field :user_id
      field :subject_title do
        label 'Category'
      end
      field :title do
        label 'Question'
      end
      field :approved
    end
    edit do
      include_all_fields
      #exclude_fields :user_id
      field :user_id do
        visible do
          hide
        end
      end
      field :subject_title do
        label 'Category'
      end
      field :title do
        label 'Question'
      end
    end
  end

  config.model 'User' do
    associated_collection_cache_all = false
    list do
      field :id
      field :name
      field :email
      field :admin
      field :reviewer
      field :provider
    end
    edit do
      exclude_fields :password, :password_confirmation
    end
  end

end
