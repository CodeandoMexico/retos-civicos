class Dataset < ActiveRecord::Base
  belongs_to :challenge
  validates_uniqueness_of :guid

  def tokenizer_hash
    data = { id: guid, title: title }
    data
  end
end
