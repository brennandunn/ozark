class CommentObserver < ActiveRecord::Observer

  def after_create(comment)
    Notification.deliver_new_comment(comment) if Configurator[:notification_email]
    (comment.observers - [comment.email]).each do |email|
      Notification.deliver_new_comment_in_thread(email, comment)
    end
  end

end
