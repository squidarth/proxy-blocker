require "proxy_blocker/config"
require "proxy_blocker/block_ips"

module ProxyBlocker
  include ProxyBlocker::Config
  
  extend self  
 
  def configure
    yield Config 
    setup! 
  end

  def setup!
    ActionController.send(:include, ProxyBlocker::BlockIps) 
  end  
end
