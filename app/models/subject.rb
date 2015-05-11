class Subject < ActiveRecord::Base
  belongs_to :question
  ART = "Art"
  ART_ICON = "fa fa-paint-brush"
  ENTERTAINMENT = "Entertainment"
  ENTERTAINMENT_ICON = "fa fa-film"
  GEOGRAPHY = "Geography"
  GEOGRAPHY_ICON = "fa fa-globe"
  HISTORY = "History"
  HISTORY_ICON = "fa fa-book"
  SCIENCE = "Science"
  SCIENCE_ICON = "fa fa-flask"
  SPORTS = "Sports"
  SPORTS_ICON = "fa fa-futbol-o"

  def self.subjects
    @subjects = [ART, ENTERTAINMENT, GEOGRAPHY, HISTORY, SCIENCE, SPORTS]
  end

  def self.subject_valid?(subject)
    Subject.subjects.include?(subject)
  end
end
