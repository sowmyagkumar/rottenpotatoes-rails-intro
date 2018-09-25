class Movie < ActiveRecord::Base
    def self.rate
      Movie.pluck(:rating)
    end
end
