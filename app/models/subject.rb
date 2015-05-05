class Subject < ActiveRecord::Base
  belongs_to :question
  ART = "Art"
  ENTERTAINMENT = "Entertainment"
  GEOGRAPHY = "Geography"
  HISTORY = "History"
  SCIENCE = "Science"
  SPORTS = "Sports"

  def self.subjects
    @subjects = [ART, ENTERTAINMENT, GEOGRAPHY, HISTORY, SCIENCE, SPORTS]
  end
end
