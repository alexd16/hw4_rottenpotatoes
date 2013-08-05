
# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "Given I uncheck the following ratings: PG, G, R"
#  "Given I check the following ratings: G"

Given /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list = rating_list.split(',')
  rating_list.each do |rating|
    rating = "ratings_#{rating}"
    uncheck ? uncheck(rating) : check(rating)
  end
end


# Make sure that it shows all the movies

Then /I should see all of the movies/ do
  all("table#movies tbody tr").size.should == Movie.count
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  (page.body =~ /#{e1}.*#{e2}/m).should_not == nil
end

Then /I should see all movies sorted by (.*)/ do |order_by|
  sorted_movies = Movie.order(order_by)
  sorted_movies.each_cons(2) do |m1,m2|
    step "Then I should see \"#{m1.title}\" before \"#{m2.title}\""
  end
end

Then /the director of "(.*)" should be "(.*)"/ do |movie_title,movie_director|
  movie = Movie.find_by_title(movie_title)
  movie.director.should == movie_director
end

