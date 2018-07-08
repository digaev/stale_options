module StaleOptions
  class ArrayOptions < AbstractOptions
    private

    def most_recent
      @most_recent ||= @record.max do |a, b|
        read_last_modified(a) <=> read_last_modified(b)
      end
    end

    protected

    def etag
      cache_by_itself? ? object_hash(@record) : collection_hash(@record)
    end

    def last_modified
      read_last_modified(most_recent) if most_recent
    end
  end
end
