-- THIS CODE IS MY OWN WORK, IT WAS WRITTEN WITHOUT CONSULTING CODE WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES. Mei Deng

SET search_path TO artistdb;

DROP VIEW IF EXISTS CoveredSongs;
DROP VIEW IF EXISTS CoveredSongName;


-- Artist(artist_id, name, birthdate, nationality)
-- Song(song_id, title, songwriter_id)
-- BelongsToAlbum(song_id, album_id, track_no)
-- Album(album_id, title, artist_id, genre_id, year, sales)


-- Covered songs means they appear in more than 1 album

CREATE VIEW CoveredSongs AS(
SELECT song_ID
FROM Song NATURAL JOIN BelongsToAlbum
GROUP BY song_id
HAVING count(album_id) > 1
);


-- Covered song name

CREATE VIEW CoveredSongName AS(
SELECT title AS song_name
FROM CoveredSongs NATURAL JOIN Song
);


-- Results

SELECT song_name, year, name AS artist_name
FROM CoveredSongs NATURAL JOIN CoveredSongName NATURAL JOIN BelongsToAlbum NATURAL JOIN Album NATURAL JOIN Artist
ORDER BY song_name ASC, year ASC, artist_name ASC;


-- Now drop the views you created earlier

DROP VIEW IF EXISTS CoveredSongName;
DROP VIEW IF EXISTS CoveredSongs;
