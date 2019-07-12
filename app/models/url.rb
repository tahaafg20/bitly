require 'uri'
class Url < ActiveRecord::Base
    belongs_to :user
    validates :link, url: true
end