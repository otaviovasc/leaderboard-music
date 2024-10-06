class Artist < ApplicationRecord
  has_many :artist_stats
  has_many :users, through: :artist_stats
end
