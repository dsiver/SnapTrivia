class Subject < ActiveRecord::Base
  belongs_to :question
  ART = "Art"
  ENTERTAINMENT = "Entertainment"
  HISTORY = "History"
  GEOGRAPHY = "Geography"
  SCIENCE = "Science"
  SPORTS = "Sports"
end
