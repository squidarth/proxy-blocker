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

  def block_behavior
    if Config.block_behavior.present?
      Config.block_behavior.call
    else
      raise Exception #TODO: find the name of ActionRouter exception for 404s 
    end
  end
end
