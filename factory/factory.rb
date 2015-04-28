module Factory
  class Factory
    def Factory.new(*fields, &block)

      instance = Class.new do
        define_method :initialize do |*instance_fields|
          @data = {}
          fields.each_with_index do |field, index|
            if index < instance_fields.length
              @data[field] = instance_fields[index]
            end
          end
        end

        fields.each do |field|
          define_method field do
            @data[field]
          end
        end

        def [](key)
          if key.kind_of?(Symbol)
            @data[key]
          elsif key.kind_of?(String)
            @data[key.to_sym]
          elsif key.kind_of?(Integer)
            data_array = @data.to_a
            if key < data_array.size 
              data_array[key].last
            end
          end
        end

      end

      # Add methods to class
      instance.class_eval &block if block_given?

      return instance
    end
  end
end