# rb-struct-factory
Ruby core struct analog.

## Usage:
    
    require './factory'

    User = Factory::Factory.new(:name, :city)
    
    george = User.new "George", "NC"
    puts george.name
    puts george.city
    puts george[0]
