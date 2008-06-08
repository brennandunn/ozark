# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def header_for(object, type = nil)
    str  = object.new_record? ? 'New' : 'Edit'
    str += " #{type}" if type
    str
  end

end
