module StaleOptions
  class RelationOptions < AbstractOptions
    protected

    def etag
      cache_by_itself? ? object_hash(@record.to_a) : collection_hash(@record)
    end

    def last_modified
      # FIXME: ActiveRecord#maximum ignores order,
      # so we can't just say `@record.maximum(last_modified_opt)`.
      # See: https://stackoverflow.com/questions/23243828/rails-activerecord-maximumcolumn-ignores-order

      @record.pluck(last_modified_opt).max
    end
  end
end
