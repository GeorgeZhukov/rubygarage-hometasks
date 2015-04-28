# rb-library
Simple library written on ruby.

## Usage
    require './library'
    
    # Sample data
    
    # Library
    lib = Library::Library.new
    
    # Authors
    ayn_rand = Library::Author.new "Ayn Rand"
    
    # Books
    atlas_shrugged = Library::Book.new "Atlas Shrugged", ayn_rand
    we_the_living = Library::Book.new "We the living", ayn_rand
    anthem = Library::Book.new "Anthem", ayn_rand
    
    # Readers
    george = Library::Reader.new "George", "example1@gmail.com"
    mike = Library::Reader.new "Mike", "example2@gmail.com"
    niko = Library::Reader.new "Niko", "example3@gmail.com"
    michael = Library::Reader.new "Michael", "example4@gmail.com"
    
    lib.order(atlas_shrugged, george)
    lib.order(atlas_shrugged, michael)
    lib.order(we_the_living, mike)
    lib.order(we_the_living, george)
    lib.order(we_the_living, mike)
    lib.order(we_the_living, niko)
    lib.order(anthem, niko)
    
    puts lib.who_often_takes_the_book atlas_shrugged
    puts lib.most_popular_book
    data = lib.how_many_people_ordered_one_of_three_most_popular_books
    data.each do |book, readers|
    	puts "#{book} (#{readers} readers)"
    end	
