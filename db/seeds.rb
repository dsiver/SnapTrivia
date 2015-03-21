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
                    {subject_title: "Art"},
                    {subject_title: "Entertainment"},
                    {subject_title: "History"},
                    {subject_title: "Geography"},
                    {subject_title: "Science"},
                    {subject_title: "Sports"},
                    {subject_title: "Bonus"},
                ])

### Creates Users ###
# Deletes all users in users table
User.delete_all
# Creates users in users table
User.create!([
                 {name: 'Admin', email: 'admin@admin.com', password: '12345678', password_confirmation: '12345678', admin: true, reviewer: true},
                 {name: 'Bill', email: 'noone@home.com', password: 'password', password_confirmation: 'password', admin: true, reviewer: true},
                 {name: 'Bob', email: 'bob@beer.org', password: 'password', password_confirmation: 'password', admin: false, reviewer: false},
                 {name: 'Doug', email: 'doug@beer.org', password: 'password', password_confirmation: 'password', admin: false, reviewer: false},
                 {name: 'Raphael', email: 'raphael@tmnt.org', password: 'password', password_confirmation: 'password', admin: false, reviewer: false},
                 {name: 'Michelangelo', email: 'michelangelo@tmnt.org', password: 'password', password_confirmation: 'password', admin: false, reviewer: false},
                 {name: 'Donatello', email: 'donatello@tmnt.org', password: 'password', password_confirmation: 'password', admin: false, reviewer: false},
                 {name: 'Leonardo', email: 'Leonardo@tmnt.org', password: 'password', password_confirmation: 'password', admin: false, reviewer: false},
             ])


#### Deletes all questions in table #####
Question.delete_all
### Adds Questions to table ###
#
# EXAMPLE ENTRY:
# {title: '', rightAns: '', wrongAns1: '', wrongAns2: '', wrongAns3: '', subject_title: '', approved: true, difficulty: ''},
#
Question.create!([
                     {title: 'Who did not paint the Sistine Chapel?', rightAns: 'Pablo Picasso', wrongAns1: 'Pietro Perugino',
                      wrongAns2: 'Sandro Botticelli', wrongAns3: 'Michelangelo', subject_title: 'Art', approved: true, difficulty: '1'},
                     {title: 'What 19th century french artist is known for ballerinas and cafe life?', rightAns: 'Edgar Degas', wrongAns1: 'Pablo Picasso',
                      wrongAns2: 'Leonardo DaVinci', wrongAns3: 'Odoardo Toscani', subject_title: 'Art', approved: true, difficulty: '3'},
                     {title: 'Define Ranaissance', rightAns: 'Rebirth', wrongAns1: 'Learning',
                      wrongAns2: 'Growth', wrongAns3: 'Birth', subject_title: 'Art', approved: true, difficulty: '1'},
                     {title: 'What movie character was named after the film cutting machine?', rightAns: 'R2D2', wrongAns1: 'C3PO',
                      wrongAns2: 'SID 6.7', wrongAns3: 'ED 209', subject_title: 'Entertainment', approved: true, difficulty: '2'},
                     {title: 'What was the last song played at Woodstock?', rightAns: 'The Star Spangled Banner', wrongAns1: 'Purple Haze',
                      wrongAns2: 'Amazing Grace', wrongAns3: 'Oh Happy Day', subject_title: 'Entertainment', approved: true, difficulty: '2'},
                     {title: 'When was sound introduced to films', rightAns: '1927', wrongAns1: '1929',
                      wrongAns2: '1920', wrongAns3: '1917', subject_title: 'Entertainment', approved: true, difficulty: '1'},
                     {title: 'How many years did the Berlin Wall Stand?', rightAns: '28', wrongAns1: '27',
                      wrongAns2: '26', wrongAns3: '30', subject_title: 'History', approved: true, difficulty: '1'},
                     {title: 'On what date was Pearl Harbor bombed?', rightAns: 'December 7th, 1941', wrongAns1: 'December 24th, 1941',
                      wrongAns2: 'July 4th, 1941', wrongAns3: 'December 13th, 1941', subject_title: 'History', approved: true, difficulty: '1'},
                     {title: 'How long did the cold war last?', rightAns: '44 years', wrongAns1: '27 years',
                      wrongAns2: '13 years', wrongAns3: '33 days', subject_title: 'History', approved: true, difficulty: '1'},
                     {title: 'Highest point east of the Mississippi is found in which state?', rightAns: 'North Carolina', wrongAns1: 'New York',
                      wrongAns2: 'Georgia', wrongAns3: 'Virginia', subject_title: 'Geography', approved: true, difficulty: '2'},
                     {title: 'What is the 5th largest country by landmass?', rightAns: 'Brazil', wrongAns1: 'Russia',
                      wrongAns2: 'United States of America', wrongAns3: 'Australia', subject_title: 'Geography', approved: true, difficulty: '1'},
                     {title: 'Which lake contains 1/5th of all the worlds fresh water?', rightAns: 'Lake Baikal', wrongAns1: 'Tanganyika',
                      wrongAns2: 'Lake Michigan', wrongAns3: 'Lake Superior', subject_title: 'Geography', approved: true, difficulty: '3'},
                     {title: 'What is the 3rd largest planet in our system?', rightAns: 'Uranus', wrongAns1: 'Jupiter',
                      wrongAns2: 'Saturn', wrongAns3: 'Earth', subject_title: 'Science', approved: true, difficulty: '1'},
                     {title: 'What is not a primary color?', rightAns: 'Green', wrongAns1: 'Red',
                      wrongAns2: 'Blue', wrongAns3: 'Yellow', subject_title: 'Science', approved: true, difficulty: '1'},
                     {title: 'What is not part of an atom?', rightAns: 'Plasitron', wrongAns1: 'Neutron',
                      wrongAns2: 'Electron', wrongAns3: 'Proton', subject_title: 'Science', approved: true, difficulty: '1'},
                     {title: 'What Sport started in the USA in 1895?', rightAns: 'Volleyball', wrongAns1: 'Baseball',
                      wrongAns2: 'Basketball', wrongAns3: 'bowling', subject_title: 'Sports', approved: true, difficulty: '2'},
                     {title: 'Which country produces the second most Major League Baseball Players?', rightAns: 'Dominican Republic', wrongAns1: 'USA',
                      wrongAns2: 'Japan', wrongAns3: 'Canada', subject_title: 'Sports', approved: true, difficulty: '2'},
                     {title: 'Who is quoted saying "Fly like a butterfly sting like a bee"?', rightAns: 'Muhammad Ali', wrongAns1: 'OJ Simpson',
                      wrongAns2: 'Ricky Marciano', wrongAns3: 'Joe Frazier', subject_title: 'Sports', approved: true, difficulty: '1'},

                 ])