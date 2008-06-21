class Notification < ActionMailer::Base
    
  def new_comment(comment)
    subject    "[Ozark] New comment on '#{comment.article.name}'"
    recipients Configurator[:notification_email]
    from       "Ozark Sender <noreply@#{host}>"
    sent_on    Time.now
    body       :comment => comment
  end

  def new_comment_in_thread(email, comment)
    subject    "[#{blog_name}] New comment on '#{comment.article.name}'"
    recipients email
    from       "Ozark Sender <noreply@#{host}>"
    sent_on    Time.now
    body       :comment => comment, :host => host, :email => email
  end
  
  def blog_name
    Configurator[:site, :title]
  end
  
  def host
    ActionMailer::Base.default_url_options[:host]
  end

end
