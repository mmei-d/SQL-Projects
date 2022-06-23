-- THIS CODE IS MY OWN WORK, IT WAS WRITTEN WITHOUT CONSULTING CODE WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES. Mei Deng

SET search_path TO artistdb;

DROP VIEW IF EXISTS AlbumCollabs;
DROP VIEW IF EXISTS AvgCollabSales;
DROP VIEW IF EXISTS AlbumWOCollab;

-- Artist(artist_id, name, birthdate, nationality)
-- Album(album_id, title, artist_id, genre_id, year, sales)
-- Collaboration(song_id, artist1, artist2)
-- BelongsToAlbum(song_id, album_id, track_no)


-- Albums with collaborations

CREATE VIEW AlbumCollabs AS(
SELECT album_id
FROM Collaboration NATURAL JOIN BelongsToAlbum
);


-- Average collab album sales

CREATE VIEW AvgCollabSales AS(
SELECT artist_id, avg(sales) AS avg_collab_sales
FROM AlbumCollabs NATURAL JOIN Album
GROUP BY artist_id
);


-- Albums without collaborations

CREATE VIEW AlbumWOCollab AS(
SELECT artist_id, album_id, sales
FROM ((SELECT artist_id, album_id, sales FROM Album) EXCEPT (SELECT artist_id, album_id, sales FROM AlbumCollabs NATURAL JOIN Album)) AlbumsWithoutCollab
);


-- Results

SELECT name AS artists, avg_collab_sales
FROM AvgCollabSales NATURAL JOIN Artist
WHERE avg_collab_sales > ANY (SELECT sales FROM AlbumWOCollab NATURAL JOIN Artist WHERE AlbumWOCollab.artist_id = AvgCollabSales.artist_id)
ORDER BY artists ASC;


-- Now drop the views you created earlier

DROP VIEW IF EXISTS AlbumWOCollab;
DROP VIEW IF EXISTS AvgCollabSales;
DROP VIEW IF EXISTS AlbumCollabs;
