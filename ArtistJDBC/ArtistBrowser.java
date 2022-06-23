import java.util.ArrayList;
import java.sql.*;
import java.util.Collections;

public class ArtistBrowser {

	/* A connection to the database */
	private Connection connection;

	/**
	 * Constructor loads the JDBC driver. No need to modify this.
	 */
	public ArtistBrowser() {
		try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e) {
			System.err.println("Failed to locate the JDBC driver.");
		}
	}

	/**
	* Establishes a connection to be used for this session, assigning it to
	* the private instance variable 'connection'.
	*
	* @param  url       the url to the database
	* @param  username  the username to connect to the database
	* @param  password  the password to connect to the database
	* @return           true if the connection is successful, false otherwise
	*/
	public boolean connectDB(String url, String username, String password) {
		try {
			this.connection = DriverManager.getConnection(url, username, password);
			return true;
		} catch (SQLException se) {
			System.err.println("SQL Exception! <Message>: " + se.getMessage());
			return false;
		}
	}

	/**
	* Closes the database connection.
	*
	* @return true if the closing was successful, false otherwise.
	*/
	public boolean disconnectDB() {
		try {
			this.connection.close();
		return true;
		} catch (SQLException se) {
			System.err.println("SQL Exception! <Message>: " + se.getMessage());
			return false;
		}
	}

	/**
	 * Returns a sorted list of the names of all musicians who were part of a band
	 * at some point between a given start year and an end year (inclusive).
 	 *
	 * Returns an empty list if no musicians match, or if the given timeframe is invalid.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *		Use prepared statements.
	 *
	 * @param startYear
	 * @param endYear
	 * @return  a sorted list of artist names
	 */
	
	// Artist(artist_id, name, birthdate, nationality)
	// Role(artist_id, role)
	// WasInBand(artist_id, band_id, start_year, end_year)

	// SELECT DISTINCT name
	// FROM Artist NATURAL JOIN Role NATURAL JOIN WasInBand
	// WHERE role = 'Musician' AND (start_year >= startYear AND start_year <= endYear) OR (end_year >= startYear AND end_year <= endYear) OR (start_year <= startYear AND end_year >= endYear)
	// ORDER BY name ASC;
	public ArrayList<String> findArtistsInBands(int startYear, int endYear) {
		String queryString;
		PreparedStatement ps;
		ResultSet rs;
		ArrayList<String> names = new ArrayList<String>();

		try{
			queryString = "SELECT DISTINCT name FROM Artist NATURAL JOIN Role NATURAL JOIN WasInBand WHERE role = 'Musician' AND (start_year >= " + startYear + " AND start_year <= " + endYear + ") OR (end_year >= " + startYear + " AND end_year <= " + endYear + ") OR (start_year <= " + startYear + " AND end_year >= " + endYear + ") ORDER BY name ASC";
			ps = connection.prepareStatement(queryString);
			rs = ps.executeQuery();

			while(rs.next()){
				names.add(rs.getString(1));
			}

			rs.close();
			ps.close();

			Collections.sort(names);   
			return names;
		} catch (SQLException se){
			System.err.println("SQL Exception." + "<Message>: " + se.getMessage());
		}
		return null;
	}


	/**
	 * Returns a sorted list of the names of all musicians and bands
	 * who released at least one album in a given genre.
	 *
	 * Returns an empty list if no such genre exists or no artist matches.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *		Use prepared statements.
	 *
	 * @param genre  the genre to find artists for
	 * @return       a sorted list of artist names
	 */

	// Artist(artist_id, name, birthdate, nationality)
	// Role(artist_id, role)
	// WasInBand(artist_id, band_id, start_year, end_year)
	// Album(album_id, title, artist_id, genre_id, year, sales)
	// Genre(genre_id, genre)

	// SELECT name
	// FROM Artist NATURAL JOIN ((SELECT artist_id, genre FROM WasInBand NATURAL JOIN Album NATURAL JOIN Genre) UNION (SELECT artist_id, genre FROM Role NATURAL JOIN Album NATURAL JOIN Genre)) as artistIDs
	// WHERE genre = genreJava
	// ORDER BY name ASC;
	public ArrayList<String> findArtistsInGenre(String genre) {
		String queryString;
		PreparedStatement ps;
		ResultSet rs;
		ArrayList<String> names = new ArrayList<String>();

		try{
			queryString = "SELECT name FROM Artist NATURAL JOIN ((SELECT artist_id, genre FROM WasInBand NATURAL JOIN Album NATURAL JOIN Genre) UNION (SELECT artist_id, genre FROM Role NATURAL JOIN Album NATURAL JOIN Genre)) as artistIDs WHERE genre = \'" + genre + "\' ORDER BY name ASC;";
			ps = connection.prepareStatement(queryString);
			rs = ps.executeQuery();

			while(rs.next()){
				names.add(rs.getString(1));
			}

			rs.close();
			ps.close();

			Collections.sort(names);   
			return names;
		} catch (SQLException se){
			System.err.println("SQL Exception." + "<Message>: " + se.getMessage());
		}
		return null;
	}


	/**
	 * Returns a sorted list of the names of all collaborators
	 * (either as a main artist or guest) for a given artist.
	 *
	 * Returns an empty list if no such artist exists or the artist
	 * has no collaborators.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *		Use prepared statements.
	 *
	 * @param artist  the name of the artist to find collaborators for
	 * @return        a sorted list of artist names
	 */

	// Artist(artist_id, name, birthdate, nationality)
	// Collaboration(song_id, artist1, artist2)

	// artist IDs of guest collaborators
	// CREATE VIEW GuestCollabID AS(
	// SELECT artist2 as artist_id
	// FROM (SELECT artist_id FROM Artist WHERE name = artistJava) as artistJava NATURAL JOIN (SELECT artist1 as artist_id, artist2 FROM Collaboration) as collabs
	// );

	// artist IDs of main collaborators
	// CREATE VIEW MainCollabID AS(
	// SELECT artist1 as artist_id
	// FROM (SELECT artist_id FROM Artist WHERE name = artistJava) as artistJava NATURAL JOIN (SELECT artist1, artist2 as artist_id FROM Collaboration) as collabs
	// );

	// SELECT name
	// FROM Artist NATURAL JOIN ((SELECT * FROM GuestCollabID) UNION (SELECT * FROM MainCollabID)) as collabIDs
	// ORDER BY name ASC;
	public ArrayList<String> findCollaborators(String artist) {
		String queryString;
		PreparedStatement ps;
		ResultSet rs;
		ArrayList<String> names = new ArrayList<String>();

		try{
			queryString = "DROP VIEW if exists GuestCollabID;";
			ps = connection.prepareStatement(queryString);
			int result = ps.executeUpdate();

			queryString = "DROP VIEW if exists MainCollabID;";
			ps = connection.prepareStatement(queryString);
			result = ps.executeUpdate();

			queryString = "CREATE VIEW GuestCollabID AS(SELECT artist2 as artist_id FROM (SELECT artist_id FROM Artist WHERE name = \'" + artist + "\') as artistJava NATURAL JOIN (SELECT artist1 as artist_id, artist2 FROM Collaboration) as collabs);";
			ps = connection.prepareStatement(queryString);
			result = ps.executeUpdate();

			queryString = "CREATE VIEW MainCollabID AS(SELECT artist1 as artist_id FROM (SELECT artist_id FROM Artist WHERE name = \'" + artist + "\') as artistJava NATURAL JOIN (SELECT artist1, artist2 as artist_id FROM Collaboration) as collabs);";
			ps = connection.prepareStatement(queryString);
			result = ps.executeUpdate();

			queryString = "SELECT name FROM Artist NATURAL JOIN ((SELECT * FROM GuestCollabID) UNION (SELECT * FROM MainCollabID)) as collabIDs ORDER BY name ASC;";
			ps = connection.prepareStatement(queryString);
			rs = ps.executeQuery();

			queryString = "DROP VIEW if exists GuestCollabID;";
			ps = connection.prepareStatement(queryString);
			result = ps.executeUpdate();

			queryString = "DROP VIEW if exists MainCollabID;";
			ps = connection.prepareStatement(queryString);
			result = ps.executeUpdate();

			while(rs.next()){
				names.add(rs.getString(1));
			}

			rs.close();
			ps.close();

			Collections.sort(names);   
			return names;
		} catch (SQLException se){
			System.err.println("SQL Exception." + "<Message>: " + se.getMessage());
		}
		return null;
	}


	/**
	 * Returns a sorted list of the names of all songwriters
	 * who wrote songs for a given artist (the given artist is excluded).
	 *
	 * Returns an empty list if no such artist exists or the artist
	 * has no other songwriters other than themself.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *
	 * @param artist  the name of the artist to find the songwriters for
	 * @return        a sorted list of songwriter names
	 */

	// Artist(artist_id, name, birthdate, nationality)
	// Album(album_id, title, artist_id, genre_id, year, sales)
	// Song(song_id, title, songwriter_id)
	// BelongsToAlbum(song_id, album_id, track_no)

	// songwriter IDs
	// CREATE VIEW SongWriterIDs AS(
	// SELECT songwriter_id as artist_id
	// FROM BelongsToAlbum NATURAL JOIN (SELECT song_id, songwriter_id FROM Song) as songs NATURAL JOIN Album NATURAL JOIN Artist
	// WHERE name = artistJava AND artist_id != songwriter_id
	// );

	// SELECT name
	// FROM Artist NATURAL JOIN SongWriterIDs
	// ORDER BY name ASC;
	public ArrayList<String> findSongwriters(String artist) {
		String queryString;
		PreparedStatement ps;
		ResultSet rs;
		ArrayList<String> names = new ArrayList<String>();

		try{
			queryString = "DROP VIEW if exists SongWriterIDs;";
			ps = connection.prepareStatement(queryString);
			int result = ps.executeUpdate();

			queryString = "CREATE VIEW SongWriterIDs AS(SELECT songwriter_id as artist_id FROM BelongsToAlbum NATURAL JOIN (SELECT song_id, songwriter_id FROM Song) as songs NATURAL JOIN Album NATURAL JOIN Artist WHERE name = \'" + artist + "\' AND artist_id != songwriter_id);";
			ps = connection.prepareStatement(queryString);
			result = ps.executeUpdate();

			queryString = "SELECT name FROM Artist NATURAL JOIN SongWriterIDs ORDER BY name ASC;";
			ps = connection.prepareStatement(queryString);
			rs = ps.executeQuery();

			queryString = "DROP VIEW if exists SongWriterIDs;";
			ps = connection.prepareStatement(queryString);
			result = ps.executeUpdate();

			while(rs.next()){
				names.add(rs.getString(1));
			}

			rs.close();
			ps.close();

			Collections.sort(names);   
			return names;
		} catch (SQLException se){
			System.err.println("SQL Exception." + "<Message>: " + se.getMessage());
		}
		return null;
	}

	/**
	 * Returns a sorted list of the names of all common acquaintances
	 * for a given pair of artists.
	 *
	 * Returns an empty list if either of the artists does not exist,
	 * or they have no acquaintances.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *
	 * @param artist1  the name of the first artist to find acquaintances for
	 * @param artist2  the name of the second artist to find acquaintances for
	 * @return         a sorted list of artist names
	 */
	public ArrayList<String> findCommonAcquaintances(String artist1, String artist2) {
		ArrayList<String> names = new ArrayList<String>();
		ArrayList<String> a1Names = new ArrayList<String>();
		ArrayList<String> a1Collab = new ArrayList<String>();
		ArrayList<String> a1Songwriter = new ArrayList<String>();
		ArrayList<String> a2Names = new ArrayList<String>();
		ArrayList<String> a2Collab = new ArrayList<String>();
		ArrayList<String> a2Songwriter = new ArrayList<String>();

		a1Collab = findCollaborators(artist1);
		a1Names.addAll(a1Collab);
		a1Songwriter = findSongwriters(artist1);
		a1Names.addAll(a1Songwriter);
		
		a2Collab = findCollaborators(artist2);
		a2Names.addAll(a2Collab);
		a2Songwriter = findSongwriters(artist2);
		a2Names.addAll(a2Songwriter);

		for(int m = 0; m < a1Names.size(); m++){
			for(int n = 0; n < a2Names.size(); n++){
				if(a1Names.get(m).equals(a2Names.get(n))){
					names.add(a1Names.get(m));
				}
			}
		}

		Collections.sort(names);   
		return names;
	}

	/**
	 * Returns a sorted list of the names of record labels whose
	 * total album sales increased consistently every year, when
	 * considering all consecutive years in the dataset that appear
	 * for a given label. If a label has a year in the middle with 0
	 * revenue (i.e., no produced albums or all albums had 0 sales),
	 * it doesn't satisfy the criteria and shouldn't be included here.
	 *
	 * Returns an empty list if no such labels fit the criteria.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *
	 * @return         a sorted list of record label names
	 */

	// Album(album id, title, artist id, genre id, year, sales)
	// ProducedBy(album_id, label_id)
	// RecordLabel(label_id, label_name, country)

	// SELECT label_name, year, avg(sales) as avg_sales
	// FROM Album NATURAL JOIN ProducedBy NATURAL JOIN RecordLabel
	// GROUP BY label_name, year
	// ORDER BY label_name;
	public ArrayList<String> findRisingLabels() {
		String queryString;
		PreparedStatement ps;
		ResultSet rs;
		ArrayList<String> labelNames = new ArrayList<String>();
		ArrayList<Integer> years = new ArrayList<Integer>();
		ArrayList<Integer> sales = new ArrayList<Integer>();
		ArrayList<String> names = new ArrayList<String>();
		ArrayList<String> deleteNames = new ArrayList<String>();

		try{
			queryString = "SELECT label_name, year, avg(sales) as avg_sales FROM Album NATURAL JOIN ProducedBy NATURAL JOIN RecordLabel GROUP BY label_name, year ORDER BY label_name;";
			ps = connection.prepareStatement(queryString);
			rs = ps.executeQuery();

			while(rs.next()){
				labelNames.add(rs.getString(1));
				years.add(rs.getInt(2));
				sales.add(rs.getInt(3));
			}

			int i = 0;
			while(i < labelNames.size() - 1){
				// if the avg sales increases from one consecutive year to the next, add the label name to the array list
				if(labelNames.get(i).equals(labelNames.get(i+1)) && years.get(i) == (years.get(i + 1) - 1) && sales.get(i) < sales.get(i + 1)){
					names.add(labelNames.get(i));
				// if later, the sales are not increasings, delete all existing instances of the label name in the array list (by adding to deleteNames array list)
				} else if (labelNames.get(i).equals(labelNames.get(i+1)) && years.get(i) == (years.get(i + 1) - 1) && sales.get(i) >= sales.get(i + 1)){
					deleteNames.add(labelNames.get(i));
				// if later, the years are not consecutive, delete all existing instances of the label name in the array list (by adding to deleteNames array list)
				} else if (labelNames.get(i).equals(labelNames.get(i+1)) && years.get(i) != (years.get(i + 1) - 1)){
					deleteNames.add(labelNames.get(i));
				}
				i++;
			}
			// actually delete all names that violate conditions
			names.removeAll(deleteNames);

			rs.close();
			ps.close();

			Collections.sort(names);   
			return names;
		} catch (SQLException se){
			System.err.println("SQL Exception." + "<Message>: " + se.getMessage());
		}
		return null;
	}


	public static void main(String[] args) {

		if( args.length < 2 ){
			System.out.println("Usage: java ArtistBrowser <userName> <password>");
			return;
		}

		String user = args[0];
		String pass = args[1];

		ArtistBrowser a3 = new ArtistBrowser();

		String url = "jdbc:postgresql://localhost:5432/postgres?currentSchema=artistDB";
		a3.connectDB(url, user, pass);

		System.err.println("\n----- ArtistsInBands -----");
    	ArrayList<String> res = a3.findArtistsInBands(1990,1999);
    	for (String s : res) {
      	  System.err.println(s);
    	}

		System.err.println("\n----- ArtistsInGenre -----");
    	res = a3.findArtistsInGenre("Rock");
    	for (String s : res) {
    	  System.err.println(s);
    	}

		System.err.println("\n----- Collaborators -----");
		res = a3.findCollaborators("Usher");
		for (String s : res) {
		  System.err.println(s);
		}

		System.err.println("\n----- Songwriters -----");
	        res = a3.findSongwriters("Justin Bieber");
		for (String s : res) {
		  System.err.println(s);
		}

		System.err.println("\n----- Common Acquaintances -----");
		res = a3.findCommonAcquaintances("Jaden Smith", "Miley Cyrus");
		for (String s : res) {
		  System.err.println(s);
		}

		System.err.println("\n----- Rising Record Labels -----");
		res = a3.findRisingLabels();
		for (String s : res) {
		  System.err.println(s);
		}

		a3.disconnectDB();
	}
}
