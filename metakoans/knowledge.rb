class Module
  def attribute(name, &block)
    # Cranking hash
    return name.map {|key, value| attribute(key) {value}} if name.kind_of?(Hash)

    class_eval do
      attr_writer name.to_sym

      define_method (name + '?') do
        !!send(name)
      end

      # Attribute getter
      define_method (name) do
        if instance_variable_defined?('@' + name)
          instance_variable_get('@' + name)
        elsif block_given?          
          instance_eval(&block)
        end
      end

    end
  end
end
