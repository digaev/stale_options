module StaleOptions
  class AbstractOptions
    def initialize(record, options = {})
      @record = record
      @options = {
        cache_by: :updated_at,
        last_modified: :updated_at
      }.merge!(options)
    end

    def to_h
      { etag: etag, last_modified: nil }.tap do |h|
        unless last_modified_opt.nil?
          h[:last_modified] = StaleOptions.time?(last_modified_opt) ? last_modified_opt : last_modified
          h[:last_modified] = h[:last_modified]&.utc
        end
      end
    end

    private

    def cache_by_opt
      @options[:cache_by]
    end

    def cache_by_itself?
      cache_by_opt.to_s == 'itself'
    end

    def read_cache_by(obj)
      value = obj.public_send(cache_by_opt)

      StaleOptions.time?(value) ? value.to_f : value
    end

    def last_modified_opt
      @options[:last_modified]
    end

    def read_last_modified(obj)
      obj.public_send(last_modified_opt)
    end

    def object_hash(obj)
      Digest::MD5.hexdigest(Marshal.dump(obj))
    end

    def collection_hash(collection)
      object_hash(collection.map { |obj| read_cache_by(obj) })
    end

    protected

    def etag
      raise NotImplementedError
    end

    def last_modified
      raise NotImplementedError
    end
  end
end
