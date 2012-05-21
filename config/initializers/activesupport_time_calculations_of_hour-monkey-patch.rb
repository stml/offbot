require 'active_support/core_ext/time/calculations'

unless Time.method_defined?(:beginning_of_hour)
  class Time
    # Returns a new Time representing the start of the hour (x:00)
    def beginning_of_hour
      change(:min => 0)
    end
    alias :at_beginning_of_hour :beginning_of_hour
    
    # Returns a new Time representing the end of the hour, x:59:59.999999 (.999999999 in ruby1.9)
    def end_of_hour
      change(
        :min => 59,
        :sec => 59,
        :usec => 999999.999
      )
    end
  end
end

require 'active_support/core_ext/date_time/calculations'

unless DateTime.method_defined?(:beginning_of_hour)
  class DateTime
  # Returns a new DateTime representing the start of the hour (hh:00:00)
    def beginning_of_hour
      change(:min => 0)
    end
    alias :at_beginning_of_hour :beginning_of_hour
    
    # Returns a new DateTime representing the end of the hour (hh:59:59)
    def end_of_hour
      change(:min => 59, :sec => 59)
    end
  end
end
