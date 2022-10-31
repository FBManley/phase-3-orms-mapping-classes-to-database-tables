class Song

  attr_accessor :name, :album, :id
  # instance attributes 
  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end
# "map" our class to a database table, we will create a table with the same name, pluralized, as our class, and give that table column names that match the attr_accessors of our class.
# we created a class method, .create_table, that crafts a SQL statement to create a songs table and give that table column names that match the attributes of an individual instance of Song
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?)
    SQL

    # insert the song
    DB[:conn].execute(sql, self.name, self.album)

    # get the song ID from the database and save it to the Ruby instance
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    # return the Ruby instance
    self
  end

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end

end