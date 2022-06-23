DROP SCHEMA IF EXISTS artistdb CASCADE;

CREATE SCHEMA artistdb;
SET search_path TO artistdb;

---------------------- ArtistDB Schema Creation ---------------------------
CREATE TABLE Artist(
artist_id integer PRIMARY KEY,
name varchar NOT NULL,
birthdate timestamp,
nationality varchar );

CREATE TABLE Role(
artist_id integer ,
role varchar NOT NULL,
PRIMARY KEY(artist_id,role ));

CREATE TABLE WasInBand (
artist_id integer NOT NULL REFERENCES Artist,
band_id integer NOT NULL REFERENCES Artist,
start_year integer,
end_year integer,
PRIMARY KEY (artist_id,band_id, start_year, end_year));

CREATE TABLE Genre (
genre_id integer PRIMARY KEY,
genre varchar NOT NULL);

CREATE TABLE Album (
album_id integer PRIMARY KEY,
title varchar NOT NULL,
artist_id integer NOT NULL REFERENCES Artist,
genre_id integer NOT NULL REFERENCES Genre,
year integer,
sales integer);

CREATE TABLE Song (
song_id integer PRIMARY KEY,
title varchar NOT NULL,
songwriter_id integer NOT NULL REFERENCES Artist);

CREATE TABLE BelongsToAlbum (
song_id integer NOT NULL REFERENCES Song,
album_id integer NOT NULL REFERENCES Album,
track_no integer);

CREATE TABLE RecordLabel (
label_id integer PRIMARY KEY,
label_name varchar,
country varchar);

CREATE TABLE ProducedBy (
album_id integer NOT NULL REFERENCES Album,
label_id integer NOT NULL REFERENCES RecordLabel,
PRIMARY KEY(album_id, label_id));

CREATE TABLE Collaboration (
song_id integer NOT NULL REFERENCES Song,
artist1 integer NOT NULL REFERENCES Artist,
artist2 integer NOT NULL REFERENCES Artist
);
------------------------------------------------------------------------


------------------- ArtistDB Data Loading -------------------------------
-- The following commands will load (copy) the data from a public URL
-- that points to a public Google Bucket with a sample dataset for this homework.
-- Learn more about Google Storage Buckets here:
-- https://cloud.google.com/storage/docs/creating-buckets

-- Tip: Execute the copy statements one by one and verify that the data has been
-- successfully loaded every time (no error messages appear and table tuples are
-- populated successfully!)
\copy Artist from PROGRAM 'curl https://storage.googleapis.com/psql_bucket/tablesfolder/Artist.csv' DELIMITER ',' CSV;
\copy Role from PROGRAM 'curl https://storage.googleapis.com/psql_bucket/tablesfolder/Role.csv' DELIMITER ',' CSV;
\copy  WasInBand from PROGRAM 'curl https://storage.googleapis.com/psql_bucket/tablesfolder/WasInBand.csv' DELIMITER ',' CSV;
\copy Genre from PROGRAM 'curl https://storage.googleapis.com/psql_bucket/tablesfolder/Genre.csv' DELIMITER ',' CSV;
\copy Album from PROGRAM 'curl https://storage.googleapis.com/psql_bucket/tablesfolder/Album.csv' DELIMITER ',' CSV;
\copy Song from PROGRAM 'curl https://storage.googleapis.com/psql_bucket/tablesfolder/Song.csv' DELIMITER ',' CSV;
\copy BelongsToAlbum from PROGRAM 'curl https://storage.googleapis.com/psql_bucket/tablesfolder/BelongsToAlbum.csv' DELIMITER ',' CSV;
\copy RecordLabel from PROGRAM 'curl https://storage.googleapis.com/psql_bucket/tablesfolder/RecordLabel.csv' DELIMITER ',' CSV;
\copy ProducedBy from PROGRAM 'curl https://storage.googleapis.com/psql_bucket/tablesfolder/ProducedBy.csv' DELIMITER ',' CSV;
\copy Collaboration from PROGRAM 'curl https://storage.googleapis.com/psql_bucket/tablesfolder/Collaboration.csv' DELIMITER ',' CSV;
------------------------------------------------------------------------
