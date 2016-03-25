require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    class_name.underscore + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    name = name.to_s
    default = {
      foreign_key: "#{name}_id".to_sym,
      primary_key: "id".to_sym,
      class_name: "#{name.singularize.camelcase}"
    }
    options = default.merge(options)
    self.foreign_key = options[:foreign_key]
    self.primary_key = options[:primary_key]
    self.class_name = options[:class_name]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    name = name.to_s
    default = {
      foreign_key: "#{self_class_name.underscore}_id".to_sym,
      primary_key: "id".to_sym,
      class_name: "#{name.singularize.camelcase}"
    }
    options = default.merge(options)
    self.foreign_key = options[:foreign_key]
    self.primary_key = options[:primary_key]
    self.class_name = options[:class_name]
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})

    define_method(name) do
      options = BelongsToOptions.new(name, options)
      foreign_key = self.class.find(id).id
      model = options.model_class
      model.where(options.primary_key => foreign_key).first
    end

  end

  def has_many(name, options = {})

    define_method(name) do

    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
