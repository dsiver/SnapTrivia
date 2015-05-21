class Reviewer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.notify_reviewers(subject, body, payload)
    User.where(reviewer: true).find_each do |user|
      Message.send_system_message(user.id, subject, body, payload)
    end
  end
end
