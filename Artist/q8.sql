-- THIS CODE IS MY OWN WORK, IT WAS WRITTEN WITHOUT CONSULTING CODE WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES. Mei Deng

SET search_path TO artistdb;

DROP VIEW IF EXISTS ThrillerAlbumSongs;
DROP VIEW IF EXISTS CoverAlbums;
DROP VIEW IF EXISTS ThrillerLabel;
DROP TABLE IF EXISTS StoredLabelAndSongs;


-- Album(album_id, title, artist_id, genre_id, year, sales)
-- Song(song_id, title, songwriter_id)
-- BelongsToAlbum(song_id, album_id, track_no)
-- RecordLabel(label_id, label_name, country)
-- ProducedBy(album_id, label_id)
-- Collaboration(song_id, artist1, artist2)


-- All songs in 'Thriller' Album

CREATE VIEW ThrillerAlbumSongs AS(
SELECT album_id, song_id
FROM Album NATURAL JOIN BelongsToAlbum
WHERE title = 'Thriller'
);


-- Cover albums of any 'Thriller' songs

CREATE VIEW CoverAlbums AS(
SELECT album_id
FROM BelongsToAlbum
WHERE song_id IN (SELECT song_id FROM ThrillerAlbumSongs) AND album_id NOT IN (SELECT album_id FROM ThrillerAlbumSongs)
);


-- Record labels of 'Thriller' albums (not responsible for removing record labels that produced covers of 'Thriller' album's songs)

CREATE VIEW ThrillerLabel AS(
SELECT label_id
FROM ThrillerAlbumSongs NATURAL JOIN ProducedBy
);


-- Table to store label_id and song_id's of 'Thriller' album

CREATE TABLE StoredLabelAndSongs (
label_id integer,
song_id integer
);


-- Insert label_id and song_id's into table StoredLabelAndSongs

INSERT INTO StoredLabelAndSongs(label_id, song_id)(
SELECT label_id, song_id
FROM ThrillerAlbumSongs NATURAL JOIN ProducedBy
);


-- Delete collaborations

DELETE FROM Collaboration
WHERE song_id IN (SELECT song_id FROM ThrillerAlbumSongs);


-- Delete from ProducedBy

DELETE FROM ProducedBy
WHERE album_id IN (SELECT album_id FROM ThrillerAlbumSongs);


-- Delete record label that produced 'Thriller'

DELETE FROM RecordLabel
WHERE label_id IN (SELECT label_id FROM StoredLabelAndSongs);


-- Delete cover albums if any (from BelongsToAlbum)

DELETE FROM BelongsToAlbum
WHERE album_id IN (SELECT album_id FROM CoverAlbums);


-- Delete actual cover albums (from Album)

DELETE FROM Album
WHERE album_id IN (SELECT album_id FROM CoverAlbums);


-- Delete 'Thriller' album songs (from BelongsToAlbum)

DELETE FROM BelongsToAlbum
WHERE album_id IN (SELECT album_id FROM ThrillerAlbumSongs);


-- Delete 'Thriller' album songs

DELETE FROM Song
WHERE song_id IN (SELECT song_id FROM StoredLabelAndSongs);


-- Delete 'Thriller' album

DELETE FROM Album
WHERE album_id IN (SELECT album_id FROM Album WHERE title = 'Thriller');


-- Now drop the views you created earlier

DROP TABLE IF EXISTS StoredLabelAndSongs;
DROP VIEW IF EXISTS ThrillerLabel;
DROP VIEW IF EXISTS CoverAlbums;
DROP VIEW IF EXISTS ThrillerAlbumSongs;
