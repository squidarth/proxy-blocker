module ProxyBlocker
  module BlockIps
    def block_ips
      if ProxyBlocker.is_blocked_ip?(request.remote_ip)
        ProxyBlocker.block_behavior
      end
    end
  end
end
