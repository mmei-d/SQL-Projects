-- THIS CODE IS MY OWN WORK, IT WAS WRITTEN WITHOUT CONSULTING CODE WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES. Mei Deng

SET search_path TO artistdb;

DROP VIEW IF EXISTS TotalSales;
DROP VIEW IF EXISTS LeastPopGen;
DROP VIEW IF EXISTS Musicians;


-- Artist(artist_id, name, birthdate, nationality)
-- Album(album_id, title, artist_id, genre_id, year, sales)
-- Genre(genre_id, genre)
-- Role(artist_id, role)


-- Total sales for each genre

CREATE VIEW TotalSales AS(
SELECT sum(sales) AS sales, genre_id
FROM Album NATURAL JOIN Genre
GROUP BY genre_id
);


-- Least popular genre in terms of total sales from all albums in it

CREATE VIEW LeastPopGen AS(
SELECT genre_id
FROM TotalSales
WHERE sales = (SELECT min(sales) FROM TotalSales)
);


-- Musicians who have only performed in albums categorizes as least popular genre

CREATE VIEW Musicians AS(
SELECT name AS musician
FROM Artist NATURAL JOIN Role NATURAL JOIN Album
WHERE role = 'Musician' AND genre_id = ALL (SELECT genre_id FROM LeastPopGen)
);


-- Results

SELECT musician, genre
FROM Musicians, (LeastPopGen NATURAL JOIN Genre)
ORDER BY musician ASC;


-- Now drop the views you created earlier

DROP VIEW IF EXISTS Musicians;
DROP VIEW IF EXISTS LeastPopGen;
DROP VIEW IF EXISTS TotalSales;
