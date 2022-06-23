-- THIS CODE IS MY OWN WORK, IT WAS WRITTEN WITHOUT CONSULTING CODE WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES. Mei Deng

SET search_path TO artistdb;

DROP VIEW IF EXISTS AlbumsOneWriter;


-- Artist(artist_id, name, birthdate, nationality)
-- Album(album_id, title, artist_id, genre_id, year, sales)
-- Song(song_id, title, songwriter_id)
-- BelongsToAlbum(song_id, album_id, track_no)


-- Albums with only one songwriter (if there's more than one songwriter, the max songwriter_id won't equal the min songwriter_id)

CREATE VIEW AlbumsOneWriter AS(
SELECT album_id, max(songwriter_id) AS songwriter_id
FROM BelongsToAlbum NATURAL JOIN Song
GROUP BY album_id
HAVING max(songwriter_id) = min(songwriter_id)
);


-- Results

SELECT name AS artist_name, title AS album_name
FROM AlbumsOneWriter NATURAL JOIN Album NATURAL JOIN Artist
WHERE artist_id = songwriter_id
ORDER BY artist_name ASC, album_name ASC;


-- Now drop the views you created earlier

DROP VIEW IF EXISTS AlbumsOneWriter;
