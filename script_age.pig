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


%users of 1950s
user1950s = FILTER movie_ratings_user BY birth>=1950 AND birth<1960;
%users of 1960s
user1960s = FILTER movie_ratings_user BY birth>=1960 AND birth<1970;
%users of 1970s
user1970s = FILTER movie_ratings_user BY birth>=1970 AND birth<1980;
%users of 1980s
user1980s = FILTER movie_ratings_user BY birth>=1980 AND birth<1990;
%users of 1990s
user1990s = FILTER movie_ratings_user BY birth>=1990 AND birth<2000;


%top list of 1950s
user1950s_temp = GROUP user1950s BY movieName;

user1950s_count = FOREACH user1950s_temp GENERATE group as movieName, COUNT(user1950s) as count;

user1950s_ranking = ORDER user1950s_count BY count DESC;

%store user1950s_ranking
store user1950s_ranking into 'PATH-TO-1950s';


%top list of 1960s
user1960s_temp = GROUP user1960s BY movieName;

user1960s_count = FOREACH user1960s_temp GENERATE group as movieName, COUNT(user1960s) as count;

user1960s_ranking = ORDER user1960s_count BY count DESC;

%store user1960s_ranking
store user1960s_ranking into 'PATH-TO-1960s';


%top list of 1970s
user1970s_temp = GROUP user1970s BY movieName;

user1970s_count = FOREACH user1970s_temp GENERATE group as movieName, COUNT(user1970s) as count;

user1970s_ranking = ORDER user1970s_count BY count DESC;

%store user1970s_ranking
store user1970s_ranking into 'PATH-TO-1970s';


%top list of 1980s
user1980s_temp = GROUP user1980s BY movieName;

user1980s_count = FOREACH user1980s_temp GENERATE group as movieName, COUNT(user1980s) as count;

user1980s_ranking = ORDER user1980s_count BY count DESC;

%store user1980s_ranking
store user1980s_ranking into 'PATH-TO-1980s';


%top list of 1990s
user1990s_temp = GROUP user1990s BY movieName;

user1990s_count = FOREACH user1990s_temp GENERATE group as movieName, COUNT(user1990s) as count;

user1990s_ranking = ORDER user1990s_count BY count DESC;

%store user1990s_ranking
store user1990s_ranking into 'PATH-TO-1990s';














