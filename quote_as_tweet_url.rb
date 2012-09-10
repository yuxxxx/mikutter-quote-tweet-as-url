# -*- coding: utf-8 -*-
Plugin.create :quote_tweet_as_url do
  is_quotable = Proc.new {|message|
    message.message.retweetable? || message.message.from_me? 
  }
  filter_command do |menu|
    menu[:quote_tweet_as_url] = {
      :slug => :quote_tweet_as_url,
      :name => 'ツイートのURLを引用',
      :condition => lambda{ |messages| messages.any?(&is_quotable) },
      :exec => lambda{ |messages|
        postboxes = Plugin.filtering(:main_postbox, nil).first
        postbox = Gtk::PostBox.new(Post.primary_service,
                                   postboxstorage: postboxes)
        widget = postbox.widget_post
        postboxes.pack_start(postbox).show_all.get_ancestor(Gtk::Window).set_focus(widget)
        messages.keep_if(&is_quotable).each{ |quoted_message|
          widget.buffer.text += "http://twitter.com/#{quoted_message.message[:user][:idname]}/statuses/#{quoted_message.message[:id]} "
        }
      },
      :visible => true,
      :role => :messages }
    [menu]
  end
end
