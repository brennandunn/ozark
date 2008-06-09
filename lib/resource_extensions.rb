module ResourceExtensions
  
  def binary?
    content_type =~ /$text/
  end
  
  def content_type
    case self.extname
    when '.html'          : 'text/html'
    when '.js'            : 'text/javascript'
    when '.css'           : 'text/css'
    when '.png'           : 'image/png'
    when '.jpg', '.jpeg'  : 'image/jpeg'
    when '.gif'           : 'image/gif'
    when '.swf'           : 'application/x-shockwave-flash'      
    end
  end
  
end

Pathname.send :include, ResourceExtensions