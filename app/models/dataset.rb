class Dataset < ActiveRecord::Base
  attr_accessible :id, :guid, :name, :title, :format, :notes, :challenge_id
  belongs_to :challenge
  validates_uniqueness_of :guid

  def tokenizer_hash
    data = { id: guid, title: title }
    data
  end
end
