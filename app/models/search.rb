require 'textacular/searchable'
class Search < ActiveRecord::Base

  # We want to reference various models
  belongs_to :searchable, :polymorphic => true

  # Search.new('query') to search for 'query'
  # across searchable models
  def self.new(query)
    query = query.to_s
    return [] if query.empty?
    search_results = self.fuzzy_search(query).preload(:searchable).uniq.limit(5)
    return search_results
  end

  # Search records are never modified
  def readonly?; true; end

  # Our view doesn't have primary keys, so we need
  # to be explicit about how to tell different search
  # results apart; without this, we can't use :include
  # to avoid n + 1 query problems
  def hash; [searchable_id].hash; end
  def eql?(result)
    searchable_id == result.searchable_id
  end

end