class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      define_method(name) do
        ivar = "@#{name}"
        instance_variable_get(ivar)
      end

      define_method("#{name}=") do |value|
        ivar = "@#{name}"
        instance_variable_set(ivar, value) 
      end
    end



  end
end
