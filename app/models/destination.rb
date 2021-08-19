class Destination < ApplicationRecord
  belongs_to :purchase
  extend ActiveBase::Associations::ActiveRecordExtensions
  belongs_to :prefecture
end
