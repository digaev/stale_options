require 'active_record'
require 'active_support/time'

require 'backend/backend'

module StaleOptions
  autoload :AbstractOptions, 'stale_options/abstract_options'
  autoload :ArrayOptions, 'stale_options/array_options'
  autoload :ObjectOptions, 'stale_options/object_options'
  autoload :RelationOptions, 'stale_options/relation_options'

  def self.create(record, options = {})
    klass =
      case record
      when ActiveRecord::Relation
        RelationOptions
      when Array
        ArrayOptions
      else
        ObjectOptions
      end

    klass.new(record, options).to_h
  end

  def self.time?(obj)
    case obj
    when ActiveSupport::TimeWithZone, DateTime, Time
      true
    else
      false
    end
  end
end
