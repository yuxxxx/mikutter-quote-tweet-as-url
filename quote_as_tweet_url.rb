# -*- coding: utf-8 -*-
Plugin.create :quote_as_tweet_url do
  filter_command do |menu|
    menu[:quote_as_tweet_url] = {
      :slug => :quote_as_tweet_url,
      :name => 'ツイートのURLを引用',
      :condition => lambda{ |m| m.message.retweetable? },
      :exec => lambda{ |m|
        postboxes = Plugin.filtering(:main_postbox, nil).first
        postbox = Gtk::PostBox.new(Post.primary_service,
                                   postboxstorage: postboxes)
        widget = postbox.widget_post
        postboxes.pack_start(postbox).show_all.get_ancestor(Gtk::Window).set_focus(widget)
        widget.buffer.text = "https://twitter.com/#!/#{m.message.user[:idname]}/statuses/#{m.message[:id]}"
      },
      :visible => true,
      :role => :message }
    [menu]
  end
end
