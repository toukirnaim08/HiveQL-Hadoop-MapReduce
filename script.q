DROP TABLE IF EXISTS usersRawData;
DROP TABLE IF EXISTS ratingsRawData;
DROP TABLE IF EXISTS moviesRawData;
DROP TABLE IF EXISTS userRatingData;
DROP TABLE IF EXISTS userMovieCountData;
DROP TABLE IF EXISTS userMovieMaxCountData;
DROP TABLE IF EXISTS ageMaxMovieidData;
DROP TABLE IF EXISTS ageMaxMovieidNameData;


CREATE TABLE usersRawData (UserID INT, n1 STRING, Gender STRING, n2 STRING, Age INT, n3 STRING, Occupation INT, n4 STRING, Zipcode STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ':';

CREATE TABLE ratingsRawData (UserID INT, r1 STRING, MovieID INT, r2 STRING, Rate INT, r3 STRING, Time INT, r4 STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ':';

CREATE TABLE moviesRawData (MovieID INT, m1 STRING, Name STRING, m2 STRING, Genere STRING, m3 STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ':';

LOAD DATA INPATH '/user/cloudera/prac08/input/huser/users.dat'
OVERWRITE INTO TABLE usersRawData; 

LOAD DATA INPATH '/user/cloudera/prac08/input/hmovie/movies.dat'
OVERWRITE INTO TABLE moviesRawData; 

LOAD DATA INPATH '/user/cloudera/prac08/input/hrating/ratings.dat'
OVERWRITE INTO TABLE ratingsRawData; 

create table userRatingData as select Age,MovieID,Rate from usersRawData, ratingsRawData where usersRawData.UserID = ratingsRawData.UserID;


create table userMovieCountData as SELECT Age,MovieID,count(MovieID) as Count FROM userRatingData GROUP BY Age, MovieID;


create table userMovieMaxCountData as select age as ages, max(count) as time from userMovieCountData group by age;


create table ageMaxMovieidData as select age,movieid as mid,count from userMovieCountData, userMovieMaxCountData where userMovieCountData.count = userMovieMaxCountData.time and userMovieCountData.age = userMovieMaxCountData.ages;

create table ageMaxMovieidNameData as select Age,mid,Name from ageMaxMovieidData, moviesRawData where ageMaxMovieidData.mid = moviesRawData.MovieID;
SELECT * FROM ageMaxMovieidNameData;

















