require 'pry'

class Song
    attr_accessor :name
    attr_reader :artist, :genre
    @@all = []

    def initialize(name, artist = nil, genre = nil)
        @name = name
        self.artist = artist if artist
        self.genre = genre if genre
    end

    def self.all
        @@all 
    end

    def self.destroy_all 
        @@all.clear
    end

    def save 
        @@all << self
    end

    def self.create(name) 
        song = Song.new(name)
        song.save 
        song 
    end

    def artist=(artist)
        @artist = artist 
        artist.add_song(self)
    end

    def genre=(genre)
        @genre = genre
        if genre.songs.include?(self)
            puts "#{self} already exists within #{genre}."
        else
            genre.songs << self
        end 
    end

    def self.find_by_name(name)
        all.detect { |song| song.name == name }
    end

    def self.find_or_create_by_name(name)
        find_by_name(name) || create(name)
    end

    def self.new_from_filename(file)
        file_parsed = file.split(" - ")
        artist_name, song_name, genre_name = file_parsed[0], file_parsed[1], file_parsed[2].chomp(".mp3")
        
        artist = Artist.find_or_create_by_name(artist_name)
        genre = Genre.find_or_create_by_name(genre_name)
        Song.new(song_name, artist, genre)
    end

    def self.create_from_filename(file)
        new_from_filename(file).tap { |x| x.save }
    end

end