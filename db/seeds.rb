# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

### Deletes all subjects in table ###
Subject.delete_all
### Adds Subjects to Subjects table  ###
Subject.create!([
                    {subject_title: 'Art'},
                    {subject_title: 'Entertainment'},
                    {subject_title: 'History'},
                    {subject_title: 'Geography'},
                    {subject_title: 'Science'},
                    {subject_title: 'Sports'},
                    {subject_title: 'Bonus'},
                ])


### Creates Users ###
# Deletes all users in users table
User.delete_all
# Creates users in users table
User.create!([
                 {name: 'Admin', email: 'snaptriviagame@gmail.com', password: 'administratorpassword', password_confirmation: 'administratorpassword', admin: true, reviewer: true, coins: 100000, play_sounds: false},
                 {name: 'Bill', email: 'wcahill1@my.westga.edu', password: 'password', password_confirmation: 'password', admin: true, reviewer: true, coins: 100, play_sounds: false},
                 {name: 'David', email: 'dsiver1@my.westga.edu', password: 'davidpassword', password_confirmation: 'davidpassword', admin: true, reviewer: true, coins: 100, play_sounds: false},
             ])


#### Deletes all questions in table #####
Question.delete_all
### Adds Questions to table ###
#
# EXAMPLE ENTRY:
# {title: '', rightAns: '', wrongAns1: '', wrongAns2: '', wrongAns3: '', subject_title: '', approved: true, difficulty: ''},
#
Question.create!([
                     # Art Difficulty Level 1
                     {title: 'Who did not paint the Sistine Chapel?', rightAns: 'Pablo Picasso', wrongAns1: 'Pietro Perugino',
                      wrongAns2: 'Sandro Botticelli', wrongAns3: 'Michelangelo', subject_title: 'Art', approved: true, difficulty: '1', user_id: 2},
                     {title: 'Who sculpted the statue of David?', rightAns: 'Michelangelo', wrongAns1: 'Pietro Perugino',
                      wrongAns2: 'Sandro Botticelli', wrongAns3: 'Pablo Picasso', subject_title: 'Art', approved: true, difficulty: '1', user_id: 3},
                     {title: 'Define Renaissance', rightAns: 'Rebirth', wrongAns1: 'Learning',
                      wrongAns2: 'Growth', wrongAns3: 'Birth', subject_title: 'Art', approved: true, difficulty: '1', user_id: 2},

                     # Art Difficulty Level 2
                     {title: 'In what Italian city is the statue of David located?', rightAns: 'Florence', wrongAns1: 'Rome',
                      wrongAns2: 'Venice', wrongAns3: 'Naples', subject_title: 'Art', approved: true, difficulty: '2', user_id: 3},
                     {title: 'In what Italian city is the statue of David located?', rightAns: 'Florence', wrongAns1: 'Rome',
                      wrongAns2: 'Venice', wrongAns3: 'Naples', subject_title: 'Art', approved: true, difficulty: '2', user_id: 3},
                     {title: 'What is the most visited art museum in the world?', rightAns: 'Louvre', wrongAns1: 'Guggenheim',
                      wrongAns2: 'The Getty Center', wrongAns3: 'The Metropolitan Museum of Art', subject_title: 'Art', approved: true, difficulty: '2', user_id: 3},

                     # Art Difficulty Level 3
                     {title: 'What 16th century style of art was developed in Italy and Spain?', rightAns: 'Baroque', wrongAns1: 'Impressionism',
                      wrongAns2: 'Expressionism', wrongAns3: 'Fauvism', subject_title: 'Art', approved: true, difficulty: '3', user_id: 3},
                     {title: 'What American author won the 1931 Pulitzer and 1938 Nobel Prize?', rightAns: 'Pearl Buck', wrongAns1: 'Patricia Aakhus',
                      wrongAns2: 'Paula Gunn Allen', wrongAns3: 'Dorothy Allison', subject_title: 'Art', approved: true, difficulty: '3', user_id: 3},
                     {title: 'What 19th century french artist is known for ballerinas and cafe life?', rightAns: 'Edgar Degas', wrongAns1: 'Pablo Picasso',
                      wrongAns2: 'Leonardo DaVinci', wrongAns3: 'Odoardo Toscani', subject_title: 'Art', approved: true, difficulty: '3', user_id: 2},

                     # Entertainment Difficulty Level 1
                     {title: 'When was sound introduced to films', rightAns: '1927', wrongAns1: '1929',
                      wrongAns2: '1920', wrongAns3: '1917', subject_title: 'Entertainment', approved: true, difficulty: '1', user_id: 2},
                     {title: 'What does Dorothy chant to get home in the Wizard of Oz?', rightAns: "There's no place like home", wrongAns1: 'I want to go home.',
                      wrongAns2: 'Take me home.', wrongAns3: 'Let me go home', subject_title: 'Entertainment', approved: true, difficulty: '1', user_id: 3},
                     {title: 'In what movie does Bill Murray repeat the same day?', rightAns: 'Groundhog Day', wrongAns1: 'What About Bob?',
                      wrongAns2: 'Stripes', wrongAns3: 'Scrooged', subject_title: 'Entertainment', approved: true, difficulty: '1', user_id: 3},

                     # Entertainment Difficulty Level 2
                     {title: 'What movie character was named after the film cutting machine?', rightAns: 'R2D2', wrongAns1: 'C3PO',
                      wrongAns2: 'SID 6.7', wrongAns3: 'ED 209', subject_title: 'Entertainment', approved: true, difficulty: '2', user_id: 2},
                     {title: 'What was the last song played at Woodstock?', rightAns: 'The Star Spangled Banner', wrongAns1: 'Purple Haze',
                      wrongAns2: 'Amazing Grace', wrongAns3: 'Oh Happy Day', subject_title: 'Entertainment', approved: true, difficulty: '2', user_id: 2},
                     {title: 'On what TV show did the Simpsons start?', rightAns: 'The Tracy Ullman Show', wrongAns1: 'Saturday Night Live',
                      wrongAns2: 'The Kids in the Hall', wrongAns3: 'The Comedy Company', subject_title: 'Entertainment', approved: true, difficulty: '2', user_id: 3},

                     # Entertainment Difficulty Level 3
                     {title: 'In 1987, what film won 9 Oscars?', rightAns: 'The Last Emperor', wrongAns1: 'Broadcast News', wrongAns2: 'Good Morning, Vietnam',
                      wrongAns3: 'Moonstruck', subject_title: 'Entertainment', approved: true, difficulty: '3', user_id: 3},
                     {title: 'In 1971, Dustin Hoffman won an Oscar for what film?', rightAns: 'Kramer vs Kramer', wrongAns1: 'Tootsie', wrongAns2: 'Agatha',
                      wrongAns3: 'Straight Time', subject_title: 'Entertainment', approved: true, difficulty: '3', user_id: 3},
                     {title: 'In 1988, Dustin Hoffman won an Oscar for what film?', rightAns: 'Rain Man', wrongAns1: 'Ishtar', wrongAns2: 'Family Business',
                      wrongAns3: 'Death of a Salesman', subject_title: 'Entertainment', approved: true, difficulty: '3', user_id: 3},

                     # Geography Difficulty Level 1
                     {title: 'What is the 5th largest country by landmass?', rightAns: 'Brazil', wrongAns1: 'Russia',
                      wrongAns2: 'United States of America', wrongAns3: 'Australia', subject_title: 'Geography', approved: true, difficulty: '1', user_id: 3},
                     {title: 'What sea, with the name of a country, borders England?', rightAns: 'Irish Sea', wrongAns1: 'English Sea',
                      wrongAns2: 'Danish Sea', wrongAns3: 'French Sea', subject_title: 'Geography', approved: true, difficulty: '1', user_id: 3},
                     {title: 'What is the highest mountain in the US?', rightAns: 'Mt. McKinley', wrongAns1: 'Mt. Whitney',
                      wrongAns2: 'Mt. Rainier', wrongAns3: 'Mt. Elbert', subject_title: 'Geography', approved: true, difficulty: '1', user_id: 3},

                     # Geography Difficulty Level 2
                     {title: 'What country does not border the country Georgia?', rightAns: 'Ukraine', wrongAns1: 'Turkey',
                      wrongAns2: 'Armenia', wrongAns3: 'Russia', subject_title: 'Geography', approved: true, difficulty: '2', user_id: 3},
                     {title: 'Highest point east of the Mississippi is found in which state?', rightAns: 'North Carolina', wrongAns1: 'New York',
                      wrongAns2: 'Georgia', wrongAns3: 'Virginia', subject_title: 'Geography', approved: true, difficulty: '2', user_id: 3},
                     {title: 'What Central American country does not border the Pacific Ocean?', rightAns: 'Belize', wrongAns1: 'Honduras',
                      wrongAns2: 'Guatemala', wrongAns3: 'El Salvador', subject_title: 'Geography', approved: true, difficulty: '2', user_id: 3},

                     # Geography Difficulty Level 3
                     {title: 'Which lake contains 1/5th of all the worlds fresh water?', rightAns: 'Lake Baikal', wrongAns1: 'Tanganyika',
                      wrongAns2: 'Lake Michigan', wrongAns3: 'Lake Superior', subject_title: 'Geography', approved: true, difficulty: '3', user_id: 3},
                     {title: 'What is the capital of the Democratic Republic of the Congo?', rightAns: 'Kinshasa', wrongAns1: 'Mombasa',
                      wrongAns2: 'Harare', wrongAns3: 'Kikwit', subject_title: 'Geography', approved: true, difficulty: '3', user_id: 3},
                     {title: 'The Canary Islands are named after what kind of animal?', rightAns: 'Dogs', wrongAns1: 'Cats',
                      wrongAns2: 'Birds', wrongAns3: 'Fish', subject_title: 'Geography', approved: true, difficulty: '3', user_id: 3},

                     # History Difficulty Level 1
                     {title: 'How many years did the Berlin Wall Stand?', rightAns: '28', wrongAns1: '27',
                      wrongAns2: '26', wrongAns3: '30', subject_title: 'History', approved: true, difficulty: '1', user_id: 2},
                     {title: 'On what date was Pearl Harbor bombed?', rightAns: 'December 7th, 1941', wrongAns1: 'December 24th, 1941',
                      wrongAns2: 'July 4th, 1941', wrongAns3: 'December 13th, 1941', subject_title: 'History', approved: true, difficulty: '1', user_id: 2},
                     {title: 'How long did the cold war last?', rightAns: '44 years', wrongAns1: '27 years',
                      wrongAns2: '13 years', wrongAns3: '33 days', subject_title: 'History', approved: true, difficulty: '1', user_id: 2},


                     # History Difficulty Level 2
                     {title: 'Who was the first Vice President to not become President later?', rightAns: 'Aaron Burr', wrongAns1: 'George Clinton',
                      wrongAns2: 'Elbridge Gerry', wrongAns3: 'Daniel D. Tompkins', subject_title: 'History', approved: true, difficulty: '2', user_id: 3},
                     {title: 'In June, 1994, Americans celebrated the 50th anniversary of what WWII event?', rightAns: 'D-Day', wrongAns1: 'VJ-Day',
                      wrongAns2: 'VE-Day', wrongAns3: 'Victory Day', subject_title: 'History', approved: true, difficulty: '2', user_id: 3},
                     {title: 'What war ended at the 11th hour of the 11th day of the 11th month?', rightAns: 'WWI', wrongAns1: 'WWII',
                      wrongAns2: 'The Korean War', wrongAns3: 'The Vietnam War', subject_title: 'History', approved: true, difficulty: '2', user_id: 3},

                     # History Difficulty Level 3
                     {title: 'Around what time was the human body first dissected by Hippocrates?', rightAns: '400 B.C.', wrongAns1: '500 B.C.',
                      wrongAns2: '300 B.C.', wrongAns3: '200 B.C.', subject_title: 'History', approved: true, difficulty: '3', user_id: 3},
                     {title: 'What Central American country did Britain grant self-government to in 1981?', rightAns: 'Belize', wrongAns1: 'Panama',
                      wrongAns2: 'El Salvador', wrongAns3: 'Nicaragua', subject_title: 'History', approved: true, difficulty: '3', user_id: 3},
                     {title: 'In what country did the first license plate appear?', rightAns: 'France', wrongAns1: 'United States',
                      wrongAns2: 'England', wrongAns3: 'Germany', subject_title: 'History', approved: true, difficulty: '3', user_id: 3},

                     # Science Difficulty Level 1
                     {title: 'What is the 3rd largest planet in our system?', rightAns: 'Uranus', wrongAns1: 'Jupiter',
                      wrongAns2: 'Saturn', wrongAns3: 'Earth', subject_title: 'Science', approved: true, difficulty: '1', user_id: 3},
                     {title: 'What is not a primary color?', rightAns: 'Green', wrongAns1: 'Red',
                      wrongAns2: 'Blue', wrongAns3: 'Yellow', subject_title: 'Science', approved: true, difficulty: '1', user_id: 3},
                     {title: 'What is not part of an atom?', rightAns: 'Plasitron', wrongAns1: 'Neutron',
                      wrongAns2: 'Electron', wrongAns3: 'Proton', subject_title: 'Science', approved: true, difficulty: '1', user_id: 3},

                     # Science Difficulty Level 2
                     {title: 'What is the fastest growing plant in the world?', rightAns: 'Bamboo', wrongAns1: 'Algae',
                      wrongAns2: 'Duckweed', wrongAns3: 'Giant Sequoia', subject_title: 'Science', approved: true, difficulty: '2', user_id: 3},
                     {title: 'What is ornitholigy a study of?', rightAns: 'Birds', wrongAns1: 'Insects',
                      wrongAns2: 'Plants', wrongAns3: 'Bacteria', subject_title: 'Science', approved: true, difficulty: '2', user_id: 3},
                     {title: 'What alloy is derived from copper and zinc?', rightAns: 'Brass', wrongAns1: 'Bronze',
                      wrongAns2: 'Billum', wrongAns3: 'Constatan', subject_title: 'Science', approved: true, difficulty: '2', user_id: 3},

                     # Science Difficulty Level 3
                     {title: 'How many miles are in an astronomical unit?', rightAns: '93 million', wrongAns1: '83 million',
                      wrongAns2: '73 million', wrongAns3: '63 million', subject_title: 'Science', approved: true, difficulty: '3', user_id: 3},
                     {title: 'What is the point where the moon is closest to Earth in orbit?', rightAns: 'Perigee', wrongAns1: 'Lagrangian',
                      wrongAns2: 'Libration', wrongAns3: 'Apogee', subject_title: 'Science', approved: true, difficulty: '3', user_id: 3},
                     {title: 'What is the chemical formula for Acetic Acid?', rightAns: 'HC2H3O2', wrongAns1: 'HC3H3O2',
                      wrongAns2: 'HC2H2O2', wrongAns3: 'H2C2H3O2', subject_title: 'Science', approved: true, difficulty: '3', user_id: 3},

                     # Sports Difficulty Level 1
                     {title: 'Who is quoted saying "Fly like a butterfly sting like a bee"?', rightAns: 'Muhammad Ali', wrongAns1: 'OJ Simpson',
                      wrongAns2: 'Rocky Marciano', wrongAns3: 'Joe Frazier', subject_title: 'Sports', approved: true, difficulty: '1', user_id: 3},
                     {title: 'What is the most popular sport in the world?', rightAns: 'Soccer', wrongAns1: 'Baseball',
                      wrongAns2: 'Boxing', wrongAns3: 'Volley Ball', subject_title: 'Sports', approved: true, difficulty: '1', user_id: 3},
                     {title: 'How many warm up pitches are allowed between warm up innings?', rightAns: '8', wrongAns1: '9',
                      wrongAns2: '7', wrongAns3: '6', subject_title: 'Sports', approved: true, difficulty: '1', user_id: 3},

                     # Sports Difficulty Level 2
                     {title: 'What Sport started in the USA in 1895?', rightAns: 'Volleyball', wrongAns1: 'Baseball',
                      wrongAns2: 'Basketball', wrongAns3: 'bowling', subject_title: 'Sports', approved: true, difficulty: '2', user_id: 3},
                     {title: 'Which country produces the second most Major League Baseball Players?', rightAns: 'Dominican Republic', wrongAns1: 'USA',
                      wrongAns2: 'Japan', wrongAns3: 'Canada', subject_title: 'Sports', approved: true, difficulty: '2', user_id: 3},
                     {title: 'Which athlete was voted MVP in hockey the most?', rightAns: 'Wayne Gretsky', wrongAns1: 'Alex Ovechkin',
                      wrongAns2: 'Mark Messier', wrongAns3: 'Sidney Crosby', subject_title: 'Sports', approved: true, difficulty: '2', user_id: 3},

                     # Sports Difficulty Level 3
                     {title: 'Where was the 1968 Summer Olympics held?', rightAns: 'Mexico City', wrongAns1: 'Munich',
                      wrongAns2: 'Montreal', wrongAns3: 'Moscow', subject_title: 'Sports', approved: true, difficulty: '3', user_id: 3},
                     {title: 'Where was the 1972 Summer Olympics held?', rightAns: 'Munich', wrongAns1: 'Montreal',
                      wrongAns2: 'Mexico City', wrongAns3: 'Moscow', subject_title: 'Sports', approved: true, difficulty: '3', user_id: 3},
                     {title: 'Where was the 1976 Summer Olympics held?', rightAns: 'Montreal', wrongAns1: 'Munich',
                      wrongAns2: 'Mexico City', wrongAns3: 'Moscow', subject_title: 'Sports', approved: true, difficulty: '3', user_id: 3},
                     {title: 'Where was the 1980 Summer Olympics held?', rightAns: 'Moscow', wrongAns1: 'Montreal',
                      wrongAns2: 'Mexico City', wrongAns3: 'Munich', subject_title: 'Sports', approved: true, difficulty: '3', user_id: 3},
                 ])

###########################  Automated Game creation for statistical purposes  ###########################

# Creates between 1 and 5 won and lost games per user
User.all.each do |user|
  unless user.name == 'Admin'
    user.with_lock do
      rand(1..3).times do
        opponent = Game.playable_users(user.id).shuffle.first
        opponent.with_lock do
          @game = Game.new(player1_id: user.id, player2_id: opponent.id, game_status: Game::GAME_OVER, winner_id: user.id)
          @game.save!
          opponent.save!
        end
      end
      rand(1..3).times do
        opponent = Game.playable_users(user.id).shuffle.first
        opponent.with_lock do
          @game = Game.new(player1_id: user.id, player2_id: opponent.id, game_status: Game::GAME_OVER, winner_id: opponent.id)
          @game.save!
          opponent.save!
        end
      end
      user.save!
    end
  end
end

# Creates GameStat object for each game
Game.all.each do |game|
  game.with_lock do
    @game_stat = GameStat.new(game_id: game.id)
    @game_stat.save!
    game.save!
  end
end

# Sets a random number of total and correct questions per subject in each GameStat object
GameStat.all.each do |gs|
  gs.with_lock do
    total_questions = rand(2..47)
    number_questions = [0, 0, 0, 0, 0, 0]
    subjects = Subject.subjects
    until total_questions == 0
      index = rand(0..number_questions.length-1)
      number_questions[index]+=1
      total_questions-=1
    end
    subjects_and_questions = Hash[subjects.zip(number_questions)]
    #puts "\nnumber_questions: " + number_questions.inspect
    #puts "\nsubjects_and_questions: " + subjects_and_questions.inspect

    art_total = subjects_and_questions.fetch(Subject::ART)
    art_correct = rand(0..art_total)

    ent_total = subjects_and_questions.fetch(Subject::ENTERTAINMENT)
    ent_correct = rand(0..ent_total)

    geo_total = subjects_and_questions.fetch(Subject::GEOGRAPHY)
    geo_correct = rand(0..geo_total)

    hist_total = subjects_and_questions.fetch(Subject::HISTORY)
    hist_correct = rand(0..hist_total)

    sci_total = subjects_and_questions.fetch(Subject::SCIENCE)
    sci_correct = rand(0..sci_total)

    sports_total = subjects_and_questions.fetch(Subject::SPORTS)
    sports_correct = rand(0..sports_total)
    gs.update_attributes!(art_total: art_total, art_correct: art_correct, ent_total: ent_total, ent_correct: ent_correct,
                          geo_total: geo_total, geo_correct: geo_correct, hist_total: hist_total, hist_correct: hist_correct,
                          sci_total: sci_total, sci_correct: sci_correct, sports_total: sports_total, sports_correct: sports_correct)
    gs.save!
  end
end

# Gets correct and total values from GameStat and sets them to each player
overall_art_c = GameStat.pluck(:art_correct).sum
overall_ent_c = GameStat.pluck(:ent_correct).sum
overall_geo_c = GameStat.pluck(:geo_correct).sum
overall_hist_c = GameStat.pluck(:hist_correct).sum
overall_sci_c = GameStat.pluck(:sci_correct).sum
overall_sports_c = GameStat.pluck(:sports_correct).sum
overall_art_t = GameStat.pluck(:art_total).sum
overall_ent_t = GameStat.pluck(:ent_total).sum
overall_geo_t = GameStat.pluck(:geo_total).sum
overall_hist_t = GameStat.pluck(:hist_total).sum
overall_sci_t = GameStat.pluck(:sci_total).sum
overall_sports_t = GameStat.pluck(:sports_total).sum
overall_correct = (overall_art_c + overall_ent_c + overall_geo_c + overall_hist_c + overall_sci_c + overall_sports_c)
overall_total = (overall_art_t + overall_ent_t + overall_geo_t + overall_hist_t + overall_sci_t + overall_sports_t)
total_games = Game.all.count

user1 = User.where(name: 'Bill').first
user2 = User.where(name: 'David').first

user1_art_c = rand(0..overall_art_c)
user1_ent_c = rand(0..overall_ent_c)
user1_geo_c = rand(0..overall_geo_c)
user1_hist_c = rand(0..overall_hist_c)
user1_sci_c = rand(0..overall_sci_c)
user1_sports_c = rand(0..overall_sports_c)
user1_art_t = rand(0..overall_art_t)
user1_ent_t = rand(0..overall_ent_t)
user1_geo_t = rand(0..overall_geo_t)
user1_hist_t = rand(0..overall_hist_t)
user1_sci_t = rand(0..overall_sci_t)
user1_sports_t = rand(0..overall_sports_t)
user1_total_questions = (user1_art_t + user1_ent_t + user1_geo_t + user1_hist_t + user1_sci_t + user1_sports_t)
user1_correct_questions = (user1_art_c + user1_ent_c + user1_geo_c + user1_hist_c + user1_sci_c + user1_sports_c)
user1_total_wins = Game.where(winner_id: user1.id).count
user1.update_attributes(art_correct_count: user1_art_c, entertainment_correct_count: user1_ent_c,
                        geography_correct_count: user1_geo_c, history_correct_count: user1_hist_c,
                        science_correct_count: user1_sci_c, sports_correct_count: user1_sports_c,
                        art_total_count: user1_art_t, entertainment_total_count: user1_ent_t,
                        geography_total_count: user1_geo_t, history_total_count: user1_hist_t,
                        science_total_count: user1_sci_t, sports_total_count: user1_sports_t,
                        total_wins: user1_total_wins, total_games: total_games,
                        correct_questions: user1_correct_questions, total_questions: user1_total_questions)
user1.save
user1.adjust_badges
user1.adjust_level

user2_art_c = overall_art_c - user1_art_c
user2_ent_c = overall_ent_c - user1_ent_c
user2_geo_c = overall_geo_c - user1_geo_c
user2_hist_c = overall_hist_c - user1_hist_c
user2_sci_c = overall_sci_c - user1_sci_c
user2_sports_c = overall_sports_c - user1_sports_c
user2_art_t = overall_art_t - user1_art_t
user2_ent_t = overall_ent_t - user1_ent_t
user2_geo_t = overall_geo_t - user1_geo_t
user2_hist_t = overall_hist_t - user1_hist_t
user2_sci_t = overall_sci_t - user1_sci_t
user2_sports_t = overall_sports_t - user1_sports_t
user2_total_questions = (user2_art_t + user2_ent_t + user2_geo_t + user2_hist_t + user2_sci_t + user2_sports_t)
user2_correct_questions = (user2_art_c + user2_ent_c + user2_geo_c + user2_hist_c + user2_sci_c + user2_sports_c)
user2_total_wins = Game.where(winner_id: user2.id).count
user2.update_attributes(art_correct_count: user2_art_c, entertainment_correct_count: user2_ent_c,
                        geography_correct_count: user2_geo_c, history_correct_count: user2_hist_c,
                        science_correct_count: user2_sci_c, sports_correct_count: user2_sports_c,
                        art_total_count: user2_art_t, entertainment_total_count: user2_ent_t,
                        geography_total_count: user2_geo_t, history_total_count: user2_hist_t,
                        science_total_count: user2_sci_t, sports_total_count: user2_sports_t,
                        total_wins: user2_total_wins, total_games: total_games,
                        correct_questions: user2_correct_questions, total_questions: user2_total_questions)
user2.save
user2.adjust_badges
user2.adjust_level

# Uncomment out the following for diagnostic print statements
=begin
puts "\n"
puts "user1.art_correct_count: " + user1.art_correct_count.to_s
puts "user2.art_correct_count: " + user2.art_correct_count.to_s
puts "user1.art_correct_count + user2.art_correct_count = " +
         (user1.art_correct_count + user2.art_correct_count).to_s +
         " overall_art_c = " + overall_art_c.to_s

puts "user1.entertainment_correct_count: " + user1.entertainment_correct_count.to_s
puts "user2.entertainment_correct_count: " + user2.entertainment_correct_count.to_s
puts "user1.entertainment_correct_count + user2.entertainment_correct_count = " +
         (user1.entertainment_correct_count + user2.entertainment_correct_count).to_s +
         " overall_ent_c = " + overall_ent_c.to_s

puts "user1.geography_correct_count: " + user1.geography_correct_count.to_s
puts "user2.geography_correct_count: " + user2.geography_correct_count.to_s
puts "user1.geography_correct_count + user2.geography_correct_count = " +
         (user1.geography_correct_count + user2.geography_correct_count).to_s +
         " overall_geo_c = " + overall_geo_c.to_s

puts "user1.history_correct_count: " + user1.history_correct_count.to_s
puts "user2.history_correct_count: " + user2.history_correct_count.to_s
puts "user1.history_correct_count + user2.history_correct_count = " +
         (user1.history_correct_count + user2.history_correct_count).to_s +
         " overall_hist_c = " + overall_hist_c.to_s

puts "user1.science_correct_count: " + user1.science_correct_count.to_s
puts "user2.science_correct_count: " + user2.science_correct_count.to_s
puts "user1.science_correct_count + user2.science_correct_count = " +
         (user1.science_correct_count + user2.science_correct_count).to_s +
         " overall_sci_c = " + overall_sci_c.to_s

puts "user1.sports_correct_count: " + user1.sports_correct_count.to_s
puts "user2.sports_correct_count: " + user2.sports_correct_count.to_s
puts "user1.sports_correct_count + user2.sports_correct_count = " +
         (user1.sports_correct_count + user2.sports_correct_count).to_s +
         " overall_sports_c = " + overall_sports_c.to_s

puts "user1.art_total_count: " + user1.art_total_count.to_s
puts "user2.art_total_count: " + user2.art_total_count.to_s
puts "user1.art_total_count + user2.art_total_count = " +
         (user1.art_total_count + user2.art_total_count).to_s +
         " overall_art_t = " + overall_art_t.to_s

puts "user1.entertainment_total_count: " + user1.entertainment_total_count.to_s
puts "user2.entertainment_total_count: " + user2.entertainment_total_count.to_s
puts "user1.entertainment_total_count + user2.entertainment_total_count = " +
         (user1.entertainment_total_count + user2.entertainment_total_count).to_s +
         " overall_ent_t = " + overall_ent_t.to_s

puts "user1.geography_total_count: " + user1.geography_total_count.to_s
puts "user2.geography_total_count: " + user2.geography_total_count.to_s
puts "user1.geography_total_count + user2.geography_total_count = " +
         (user1.geography_total_count + user2.geography_total_count).to_s +
         " overall_geo_t = " + overall_geo_t.to_s

puts "user1.history_total_count: " + user1.history_total_count.to_s
puts "user2.history_total_count: " + user2.history_total_count.to_s
puts "user1.history_total_count + user2.history_total_count = " +
         (user1.history_total_count + user2.history_total_count).to_s +
         " overall_hist_t = " + overall_hist_t.to_s

puts "user1.science_total_count: " + user1.science_total_count.to_s
puts "user2.science_total_count: " + user2.science_total_count.to_s
puts "user1.science_total_count + user2.science_total_count = " +
         (user1.science_total_count + user2.science_total_count).to_s +
         " overall_sci_t = " + overall_sci_t.to_s

puts "user1.sports_total_count: " + user1.sports_total_count.to_s
puts "user2.sports_total_count: " + user2.sports_total_count.to_s
puts "user1.sports_total_count + user2.sports_total_count = " +
         (user1.sports_total_count + user2.sports_total_count).to_s +
         " overall_sports_t = " + overall_sports_t.to_s

puts "user1.total_questions: " + user1.total_questions.to_s
puts "user2.total_questions: " + user2.total_questions.to_s
puts "user1_total_questions + user2_total_questions = " +
         (user1_total_questions + user2_total_questions).to_s +
         " overall_total = " + overall_total.to_s

puts "user1.correct_questions: " + user1.correct_questions.to_s
puts "user2.correct_questions: " + user2.correct_questions.to_s
puts "user1_correct_questions + user2_correct_questions = " +
         (user1_correct_questions + user2_correct_questions).to_s +
         " overall_correct = " + overall_correct.to_s

puts "user1.total_wins: " + user1.total_wins.to_s
puts "user2.total_wins: " + user2.total_wins.to_s
puts "user1_total_wins + user2_total_wins = " +
         (user1_total_wins + user2_total_wins).to_s +
         " total_games = " + Game.all.count.to_s
=end