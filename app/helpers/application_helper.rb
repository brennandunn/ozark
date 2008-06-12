# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def header_for(object, type = nil)
    str  = object.new_record? ? 'New' : 'Edit'
    str += " #{type}" if type
    str
  end
  
  def status_of(object)
    if object.respond_to?(:published?)
      object.published? ? '' : 'unpublished'
    else
      ''
    end + ' '
  end
  
  def web_path(object)
    permalink = object.route.display_permalink
    (object.respond_to?(:published?) and !object.published?) ? permalink : link_to(permalink, permalink)
  end
  
  def errors_for(*objects)
    output = objects.map do |o|
      o.errors.map do |attr, msg|
        content_tag(:li, "#{attr.titleize} #{msg}")
      end.join("\n")
    end.join("\n")
  end

end
