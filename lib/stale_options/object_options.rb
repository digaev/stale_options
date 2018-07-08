module StaleOptions
  class ObjectOptions < AbstractOptions
    protected

    def etag
      object_hash(read_cache_by(@record)) if @record
    end

    def last_modified
      read_last_modified(@record) if @record
    end
  end
end
