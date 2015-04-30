module Library
  class Book
    attr_reader :title, :author

    def initialize(title, author)
      self.title = title
      self.author = author
    end

    def title=(newTitle)
      raise TypeError, 'Wrong title type' unless newTitle.kind_of?(String)
      raise ArgumentError, 'Title is required' if newTitle.empty?
      @title = newTitle
    end

    def author=(newAuthor)
      raise TypeError, 'Wrong author type' unless newAuthor.kind_of?(Author)
      @author = newAuthor
    end

    def ==(book)
      self.to_s == book.to_s
    end

    def to_s
      "#{@title}, Author: #{@author}"
    end
  end

  class Order
    attr_reader :book, :reader, :date

    def initialize(book, reader)
      self.book = book
      self.reader = reader
      @date = Time.new
    end

    def book=(newBook)
      raise TypeError, 'Wrong book type' unless newBook.kind_of?(Book)
      @book = newBook
    end

    def reader=(newReader)
      raise TypeError, 'Wrong reader type' unless newReader.kind_of?(Reader)
      @reader = newReader
    end

    def to_s
      "#{@book}, Reader: #{@reader}, Date: #{@date.strftime "%Y-%m-%d"}"
    end
  end

  class Reader
    attr_reader :name, :email, :city, :street, :house

    def initialize(name, email, city='', street='', house='')
      self.name = name
      self.email = email
      self.city = city
      self.street = street
      self.house = house
    end
    
    def name=(newName)
      raise TypeError, 'Wrong name type' unless newName.kind_of?(String)
      raise ArgumentError, 'Name is required' if newName.empty?
      @name = newName
    end

    def email=(newEmail)
      valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      raise TypeError, 'Wrong email type' unless newEmail.kind_of?(String)
      raise ArgumentError, 'Email is required' if newEmail.empty?
      raise TypeError, 'Wrong email format' unless newEmail =~ valid_email_regex
      @email = newEmail
    end

    def city=(newCity)
      raise TypeError, 'Wrong city type' unless newCity.kind_of?(String)
      @city = newCity
    end

    def street=(newStreet)
      raise TypeError, 'Wrong street type' unless newStreet.kind_of?(String)
      @street = newStreet
    end

    def house=(newHouse)
      raise TypeError, 'Wrong house type' unless newHouse.kind_of?(String)
      @house = newHouse
    end

    def to_s
      "#{@name} (E-mail: #{@email})"
    end
  end

  class Author
    attr_reader :name, :biography

    def initialize(name, biography='')
      self.name = name
      self.biography = biography
    end

    def name=(newName)
      raise TypeError, 'Wrong name type' unless newName.kind_of?(String)
      raise ArgumentError, 'Name is required' if newName.empty?
      @name = newName
    end

    def biography=(newBiography='')
      raise TypeError, 'Wrong biography type' unless newBiography.kind_of?(String)
      @biography = newBiography
    end

    def to_s
      "#{@name}"
    end
  end

  class Library
    attr_reader :books, :orders, :readers, :authors

    def initialize()
      @books = []
      @orders = []
      @readers = []
      @authors = []
    end

    def << (book)
      self.add_book(book)
    end

    def add_book (book)
      raise TypeError, 'Wrong book type' unless book.kind_of?(Book)
      @books << book
      @authors << book.author unless @authors.include?(book.author)
    end

    def order (book, reader)
      raise TypeError, 'Wrong reader type' unless reader.kind_of?(Reader)
      self.add_book(book) unless @books.include?(book)
      @orders << Order.new(book, reader)
      @readers << reader unless @readers.include?(reader)
    end

    def who_often_takes_the_book(book)
      raise TypeError, 'Wrong book type' unless book.kind_of?(Book)
      orders = @orders.select {|order| order.book == book}
      readers = orders.map {|order| order.reader}
      _most_common_value(readers)
    end

    def most_popular_book
      books = @orders.map(&:book)
      _most_common_value(books)
    end

    def how_many_people_ordered_one_of_three_most_popular_books
      selected_range = 0..2
      # Sort books by popularity
      books = @orders.group_by(&:book).sort_by{|item| item.last.size}.reverse!
      popular_books = books[selected_range].map(&:first)
      result = {}

      # Search unique readers for each book
      popular_books.each_with_index do |book, index|
        result[book] = books[index].last.uniq{|offer| offer.reader}.size
      end
      return result
    end

    def save (filename='library.bin')
      raise TypeError, 'String expected' unless filename.kind_of?(String)
      raw = Marshal.dump(self)
      File.write(filename, raw)
    end

    def self.load (filename='library.bin')
      raise TypeError, 'String expected' unless filename.kind_of?(String)
      unless File.exist? filename
        puts "File '#{filename}' not found. New library created."
        return Library.new
      end
      raw = File.read(filename)
      Marshal.load(raw)
    end

    private
    def _most_common_value(data)
      data.group_by do |item|
        item
      end.values.max_by(&:size).first
    end
  end
end
