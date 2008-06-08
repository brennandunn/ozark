class Comment < ActiveRecord::Base
  include Renderable
  include Tags::Base
  
  belongs_to :article
  
end
