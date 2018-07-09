module StaleOptions
  module Backend
    protected

    # Usage:
    #
    #  class ItemsController < ApplicationController
    #    include StaleOptions::Backend
    #
    #    def index
    #      if_stale?(Item.all) do |items|
    #        render json: items
    #      end
    #    end
    #  end
    #
    def if_stale?(record, options = {})
      if stale?(StaleOptions.create(record, options))
        block_given? ? yield(record) : true
      end
    end

    def unless_stale?(record, options = {})
      unless stale?(StaleOptions.create(record, options))
        block_given? ? yield(record) : true
      end
    end
  end
end
