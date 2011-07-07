module DemeterMate

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def demeter_mate *associations
      cattr_accessor :associations
      cattr_accessor :method_finder
      self.associations ||= []
      self.associations.concat associations

      self.method_finder = MethodFinder.new associations.map(&:to_s)
    end
  end

  class MethodFinder
    @@assoc_methods = %w{
      push
      concat
      build
      create
      size
      length
      count
      sum
      clear
      delete
      delete_all
      destroy_all
      find
      find_first
      uniq
      reset
    }

    @@punc_assoc_methods = %w{
      create!
      empty?
      exists?
    }

    def initialize associations
      @valid_method_names = calculate_valid_method_names associations
    end

    def calculate_valid_method_names associations
      valid_method_names = {}

      associations.map do |association|
        @@assoc_methods.map do |assoc_method|
          inflected = [
            association.pluralize,
            association.singularize
          ]

          method_names = inflected.map do |inflection|
            [
              [assoc_method, inflection].join('_'),
              [inflection, assoc_method].join('_')
            ]
          end.flatten(1)
          
          method_names.each do |method_name|
            valid_method_names[method_name] = {
              :method => assoc_method,
              :association => association
            }
          end
        end
      end

      associations.map do |association|
        @@punc_assoc_methods.map do |punc_method|
          punctuation = punc_method[-1].chr
          sans_punctuation = punc_method[0..-2]

          inflected = [
            association.pluralize,
            association.singularize
          ]

          method_names = inflected.map do |inflection|
            [
              [sans_punctuation, inflection + punctuation].join('_'),
              [inflection, punc_method].join('_')
            ]
          end.flatten(1)
          
          method_names.each do |method_name|
            valid_method_names[method_name] = {
              :method => punc_method,
              :association => association
            }
          end
        end
      end

      valid_method_names
    end

    def method_name_valid? method_name
      @valid_method_names.include? method_name.to_s
    end

    def get_object_and_method method_name
      @valid_method_names[method_name.to_s]
    end
  end


  def method_missing method_name, *args, &block
    #this is a bit ugly but all I can think of for now
    if method_name == :method_finder
      return nil
    end
    if !self.method_finder
      return super
    end

    result = self.method_finder.get_object_and_method(method_name)
    if result
      #then delegate
      send(result[:association]).send(result[:method], *args, &block)
    else
      super
    end
  end

  def respond_to? method_name, include_private=false
    if !self.method_finder
      return super
    end

    result = self.method_finder.get_object_and_method(method_name)

    if self.method_finder.method_name_valid? method_name
      true
    else
      super
    end
  end
end
