-- THIS CODE IS MY OWN WORK, IT WAS WRITTEN WITHOUT CONSULTING CODE WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES. Mei Deng

SET search_path TO artistdb;

DROP VIEW IF EXISTS FirstAlbumStep;

-- Artist(artist_id, name, birthdate, nationality)
-- Album(album_id, title, artist_id, genre_id, year, sales)
-- Role(artist_id, role)


-- Year of the first album released by Steppenwolf

CREATE VIEW FirstAlbumStep AS(
SELECT min(year) AS year
FROM Artist NATURAL JOIN Album
WHERE name = 'Steppenwolf'
);


-- Results

SELECT DISTINCT name, nationality
FROM Artist NATURAL JOIN Role, FirstAlbumStep
WHERE Extract(year from birthdate) = year AND role != 'Band'
ORDER BY name ASC;


-- Now drop the views you created earlier

DROP VIEW IF EXISTS FirstAlbumStep;
