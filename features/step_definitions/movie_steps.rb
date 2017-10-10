# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    print "Movies = #{movie}"
    Movie.create!(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  #puts "In WHEN, Arg1 = #{arg1}, arg1.class = #{arg1.class}"
  categories = arg1.split(", ")
  #puts "Categories : #{categories}"
  puts "Checkbox Count = #{all("#ratings_form > input[type='checkbox']").count}"
  all("#ratings_form > input[type='checkbox']").each {|ch| uncheck(ch[:id]) }
  categories.each do |rating|
    check('ratings_'+rating)
  end 
  #check('ratings_PG')
  click_button 'ratings_submit'
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  #puts "In THEN, Arg1 = #{arg1}, arg1.class = #{arg1.class}"
  result1=true
  finalResult=false
  categories = arg1.split(", ")
  all('#movies tr > td:nth-child(2)').each do |td|
    #puts "TD = #{td.text}"
    if categories.rindex(td.text) == nil
        result1 = false
        break
    end
  end
  
  dbCount = Movie.where(:rating => categories).count
  rowCount = all('#movies tr').count - 1
  
  puts "dbCount:#{dbCount}, rowCount:#{rowCount}"
  
  if result1 && (dbCount == rowCount)
      finalResult = true
  end
  expect(finalResult).to be_truthy
end

Then /^I should see all of the movies$/ do
  #puts "In THEN, Arg1 = #{arg1}, arg1.class = #{arg1.class}"
  result=true
  #categories = ["G", "PG", "PG-13", "R", "NC-17"]
  #puts "Size of Table = #{all('#movies tr').length}"
  #if all('#movies tr').length > 1
  #  all('#movies tr > td:nth-child(2)').each do |td|
  #      #puts "TD = #{td.text}"
  #      if categories.rindex(td.text) == nil
  #          result = false
  #          break
  #      end
  #  end
  #end
  puts "Movie Count = #{Movie.count}"
  #puts "Size of Table = #{all('#movies tr').length}"
  if all('#movies tr').length - 1 != Movie.count
      result = false
  end
  expect(result).to be_truthy
end

When /I click on Movie Title/ do
    click_link('title_header')
end

Then /^I should see movie "(.*?)" before movie "(.*?)"$/ do |movie1, movie2|
    number1 = 0
    number2 = 0
    result = false
    i = 0
    puts "Inside sort by title"
    if all('#movies tr').length > 1
        all('#movies tr > td:nth-child(1)').each do |td|
            #puts "TD = #{td.text}"
            if td.text == movie1
                number1 = i
            end
            if td.text == movie2
                number2 = i
            end
            i += 1
        end
    end
    if number1 < number2
        result = true
    end
    expect(result).to be_truthy
end

When /I click on Release Date/ do
    click_link('release_date_header')
end

Then /^I should see release_date "(.*?)" before release_date "(.*?)"$/ do |releaseDate1, releaseDate2|
    number1 = 0
    number2 = 0
    result = false
    i = 0
    if all('#movies tr').length > 1
        all('#movies tr > td:nth-child(3)').each do |td|
            #puts "TD = #{td.text}"
            if td.text == releaseDate1
                number1 = i
            end
            if td.text == releaseDate2
                number2 = i
            end
            i += 1
        end
    end
    puts "Number1=#{number1}, Number2=#{number2}"
    if number1 < number2
        result = true
    end
    expect(result).to be_truthy
end