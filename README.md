This is a library for blocking arbitrary IP addresses on arbitary 
controller actions.

The ProxyBlocker gem provides a method in ActionController that by
the default is included in a before_filter on all requests.

The list of IPs can either be passed in a text file, or if you prefer
to include it in some other format (XML,JSON, or YAML), feel free
to include your own function that returns an array of IP addresses
as part of the object.

Right now, we use Redis to store the IP addresses in memory, so on 
every request Redis is queried to see if the IP Address is listed in 
the list of queries.

If you don't have plans on using Redis in your stack, right now we also
support (but discourage) using memory to store the array of IPs.

The gem can be configured as follows:


ProxyBlocker.congure do |config|
  config.block_behavior = lambda { raise Exception |}
  config.redis = Redis.connect("redis://blahblah.com:6739")
  config.list = "#{Rails.root}/config/blocked_ips.txt"
end


Alternatively, you can call it without the list as a text file as
follows:

ProxyBlocker.configure do |config|
  config.block_behavior = lambda {raise Exception }
  config.list_aggregator = lambda { JSON.parse("#{Rails.root}/config/blocked_ips.json")["data"]}
end

The default block_behavior is raise Exception to cause a 404. If no redis
is provided, we store the list in memory,and if no list is provided, we look
for "#{Rails.root}"/config/blocked_ips.txt" for a list of IPs. If you would
just like to use these defaults, feel free to simply call ProxyBlocker.setup!


After this configuration is done, simply use the block_ips method in 
the before_filter of any controller action as follows:

class PublicController < ActionController
  before_filter :block_ips

  def home
    ...
  end

  ...
end

If you would like this filter to be called on all actions, you can include
this in the configuration as follows:

ProxyBlocker.configure do |config|
  config.use_on_all_controllers = true
end

Thank you for using this gem!
