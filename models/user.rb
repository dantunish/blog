class User < ActiveRecord::Base
    has_many :blog
end