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
      yield(record) if stale?(StaleOptions.create(record, options))
    end

    def unless_stale?(record, options = {})
      yield(record) unless stale?(StaleOptions.create(record, options))
    end
  end
end
