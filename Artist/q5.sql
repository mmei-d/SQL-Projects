-- THIS CODE IS MY OWN WORK, IT WAS WRITTEN WITHOUT CONSULTING CODE WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES. Mei Deng

SET search_path TO artistdb;

DROP VIEW IF EXISTS CanadianFirstAlbum;
DROP VIEW IF EXISTS FirstIndie;
DROP VIEW IF EXISTS CanadianNotFirstAlbum;
DROP VIEW IF EXISTS SignedAmerican;


-- Artist(artist_id, name, birthdate, nationality)
-- Album(album_id, title, artist_id, genre_id, year, sales)
-- ProducedBy(album_id, label_id)
-- RecordLabel(label_id, label_name, country)


-- All Canadian artists and their first albums

CREATE VIEW CanadianFirstAlbum AS(
SELECT artist_id, album_id
FROM Artist NATURAL JOIN Album
WHERE nationality = 'Canada' AND year IN (SELECT min(year) FROM Album GROUP BY artist_id)
);


-- First album released as an indie artist --> RESULT #1

CREATE VIEW FirstIndie AS(
SELECT artist_id, album_id
FROM CanadianFirstAlbum
WHERE album_id IN ((SELECT album_id FROM CanadianFirstAlbum) EXCEPT (SELECT album_id FROM ProducedBy))
);


-- Canadian artists and later (not first) albums

CREATE VIEW CanadianNotFirstAlbum AS(
SELECT artist_id, album_id
FROM Artist NATURAL JOIN Album
WHERE nationality = 'Canada' AND album_id NOT IN (SELECT album_id FROM FirstIndie)
);


-- Later albums signed by record label based in America --> RESULT #2

CREATE VIEW SignedAmerican AS(
SELECT artist_id
FROM CanadianNotFirstAlbum NATURAL JOIN ProducedBy NATURAL JOIN RecordLabel
WHERE country = 'America'
);


-- Results (RESULT #1 AND RESULT #2 combined)

SELECT DISTINCT name AS artist_name
FROM Artist NATURAL JOIN ((SELECT artist_id FROM FirstIndie) INTERSECT (SELECT artist_id FROM SignedAmerican)) ArtistResults
ORDER BY artist_name ASC;


-- Now drop the views you created earlier

DROP VIEW IF EXISTS SignedAmerican;
DROP VIEW IF EXISTS CanadianNotFirstAlbum;
DROP VIEW IF EXISTS FirstIndie;
DROP VIEW IF EXISTS CanadianFirstAlbum;
