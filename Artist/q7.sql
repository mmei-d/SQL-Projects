-- THIS CODE IS MY OWN WORK, IT WAS WRITTEN WITHOUT CONSULTING CODE WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES. Mei Deng

SET search_path TO artistdb;

DROP VIEW IF EXISTS NSNsongID;
DROP VIEW IF EXISTS NSNartistID;
DROP VIEW IF EXISTS CYEsongID;
DROP VIEW IF EXISTS CYEartistID;


-- Collaboration(song_id, artist1, artist2)
-- Song(song_id, title, songwriter_id)
-- BelongsToAlbum(song_id, album_id, track_no)
-- Album(album_id, title, artist_id, genre_id, year, sales)
-- Artist(artist_id, name, birthdate, nationality)


-- 'Never Say Never' song ID

CREATE VIEW NSNsongID AS(
SELECT song_ID, album_id
FROM Song NATURAL JOIN BelongsToAlbum
WHERE title = 'Never Say Never'
);

-- 'Never Say Never' artist ID

CREATE VIEW NSNartistID AS(
SELECT artist_ID
FROM NSNsongID NATURAL JOIN Album NATURAL JOIN Artist
);


-- 'Close Your Eyes' song ID

CREATE VIEW CYEsongID AS(
SELECT song_ID, album_id
FROM Song NATURAL JOIN BelongsToAlbum
WHERE title = 'Close Your Eyes'
);

-- 'Close Your Eyes' artist ID

CREATE VIEW CYEartistID AS(
SELECT artist_ID
FROM CYEsongID NATURAL JOIN Album NATURAL JOIN Artist
);


-- Justin Bieber listing other artist as guest collaborator on 'Never Say Never'

INSERT INTO Collaboration(song_id, artist1, artist2)(
SELECT song_ID, NSNartist_id as artist1, CYEartist_id as artist2
FROM NSNsongID, (SELECT artist_id AS NSNartist_id FROM NSNartistID) NSNartists, (SELECT artist_id AS CYEartist_id FROM CYEartistID) CYEartists
);


-- 'Close Your Eyes' artist listing Justin Bieber as guest collaborator

INSERT INTO Collaboration(song_id, artist1, artist2)(
SELECT song_ID, CYEartist_id as artist1, NSNartist_id as artist2
FROM CYEsongID, (SELECT artist_id AS CYEartist_id FROM CYEartistID) CYEartists, (SELECT artist_id AS NSNartist_id FROM NSNartistID) NSNartists
);


-- Now drop the views you created earlier

DROP VIEW IF EXISTS CYEartistID;
DROP VIEW IF EXISTS CYEsongID;
DROP VIEW IF EXISTS NSNartistID;
DROP VIEW IF EXISTS NSNsongID;
