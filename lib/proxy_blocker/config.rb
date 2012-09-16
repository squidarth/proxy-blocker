module ProxyBlocker

  module Config
    extend self

    {
      block_behavior: ["Proc", "Lambda"],
      redis: ["Redis"]
    }.each do |k,v|
      define_method "#{k}=" do |arg|
        raise ArgumentError unless v.include?(arg.class)
        instance_variable_set("@#{k}", arg)
      end
      
      define_method k do 
        self.instance_variable_get("@#{k}")
      end 
    end

    def aggregate_method=(meth)
      raise ArgumentError unless ["Proc", "Lambda"].include?(meth.class)
      list = meth.call 
      raise ArgumentError unless list.class = "Array" 
      set_ip_list(list) 
    end
  
  
    def set_ip_list(list)
      if self.instance_variable_get("@redis")
        write_list_to_redis(list)
      else
       instance_variable_set("@ip_list", list)
      end
    end 
  
    def write_list_to_redis(list)
      self.redis.write(list)
    end 
  end
end
