# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

Then /I should see movies sorted by "(.*)"/ do |field|
  movies_ordered = Movie.all.order("#{field} ASC")
  idx = 0
  while idx < movies_ordered.length - 1 do
    m1, m2 = movies_ordered[idx], movies_ordered[idx + 1]
    msg = "I should see \"#{m1.title}\" before \"#{m2.title}\""
    step(msg)
    idx += 1
  end

end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  idx1 = page.body.index(e1)
  idx2 = page.body.index(e2)

  expect(idx1 < idx2).to eq(true) 
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(", ").each do |rating|  
    msg = "I #{uncheck}check \"#{rating}\""
    step(msg)
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |movie|
    msg = "I should see \"#{movie.title}\""
    step(msg)
  end
end
