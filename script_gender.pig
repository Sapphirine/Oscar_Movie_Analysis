%Load ratings
ratings = LOAD 'PATH-TO-ratings.csv' as (userID:int,movieID:int,rating13:int,rating5:int);

%Find good movies(rating=5)
goodMovies = FILTER ratings BY rating5 == 5;
%Remove rating13
goodMovies = FOREACH goodMovies GENERATE userID, movieID, rating5;


%Load movie profile
movieProfile = LOAD 'PATH-TO-movie_name.txt' USING PigStorage(',') as (movieID:int, movieName:chararray);

%Join movieProfile and ratings on movieID
movie_ratings = JOIN movieProfile BY movieID, goodMovies BY movieID;
%Remove duplicate columns
movie_ratings = FOREACH movie_ratings GENERATE movieProfile::movieID, movieProfile::movieName, goodMovies::rating5, goodMovies::userID;
%Rename viriables
movie_ratings = FOREACH movie_ratings GENERATE movieProfile::movieID as movieID, movieProfile::movieName as movieName, goodMovies::rating5 as rating5, goodMovies::userID as userID;


%Load user profile
userProfile = LOAD 'PATH-TO-user_profile.txt' USING PigStorage(',') as (userID:int, birth:int, gender:chararray);

%Join userProfile and movie_ratings
movie_ratings_user = JOIN movie_ratings BY userID, userProfile BY userID;
%Remove duplicate column(userID)
movie_ratings_user = FOREACH movie_ratings_user GENERATE movie_ratings::movieID as movieID, movie_ratings::movieName as movieName, movie_ratings::rating5 as rating5, movie_ratings::userID as userID, userProfile::birth as birth, userProfile::gender as gender;

% movie_ratings_user is the most important table for this project!!!!!


%male's top list
maleRatings = FILTER movie_ratings_user BY gender == 'm';

male_temp = GROUP maleRatings BY movieName;

male_count = FOREACH male_temp GENERATE group as movieName, COUNT(maleRatings) as count;

male_ranking = ORDER male_count BY count DESC;

%dump male_ranking
store male_ranking into 'PATH-TO-male_results';



%female's ratings
femaleRatings = FILTER movie_ratings_user BY gender == 'f';

female_temp = GROUP femaleRatings BY movieName;

female_count = FOREACH female_temp GENERATE group as movieName, COUNT(femaleRatings) as count;

female_ranking = ORDER female_count BY count DESC;

%dump female_ranking
store female_ranking into 'PATH-TO-female_results';
