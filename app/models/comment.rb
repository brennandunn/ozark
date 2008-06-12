class Comment < ActiveRecord::Base
  include Renderable
  include Tags::Base, Tags::Shared
  
  belongs_to :article
  
end
