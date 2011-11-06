module Fatigue
  
  # RUN
  # An individual run knows about its distance, time, and other fun.
  class Run

    # Public: The name of the service used for this run.
    #
    # service: The name of the service used for this run.
    attr_writer :service

    # Public: The name of the service used for this run.
    attr_reader :service


    # Public: The name of the run.
    #
    # name: The name of the run used.
    attr_writer :name

    # Public: The name of the run.
    attr_reader :name

    # Public: The formatted name of the run. Includes service name.
    def formatted_name
      "#{service}#{name.strip == '' ? '' : ': '+name}"
    end


    # Public: The distance of the run.
    #
    # distance: The String unitless distance run.
    attr_writer :distance

    # Public: The distance of the run.
    attr_reader :distance
    
    
    # Public: The distance unit.
    #
    # unit: The string value of the unit. Permitted: "mi", "km".
    attr_writer :unit

    # Public: the full name of the distance unit.
    def unit
      case @unit
      when 'mi' then 'Miles'
      when 'km' then 'Kilometers'
      end
    end

    # Public: The duration of the run.
    #
    # duration: The String number of milliseconds the run took.
    attr_writer :duration

    # Public: The Integer duration of the run.
    def duration
      @duration.to_i
    end

    # Public: The number of seconds in the run (reduced).
    def seconds
      (duration / 1000) % 60
    end

    # Public: The number of minutes in the run (reduced).
    def minutes
      (duration / 1000 / 60) % 60
    end

    # Public: The number of hours in the run (reduced).
    def hours
      (duration / 1000 / 60 / 60)
    end


    # Public: The pace of the run.
    #
    # speed: The String pace of the run in minutes per mile (mmm:ss).
    def pace 
      pace_f = (duration.to_f / 1000 / 60) / distance_to_mi
      mins = pace_f.to_i
      secs = (pace_f - mins) * 60
      p = "%d:%02d" % [mins, secs]
      puts p
      p
    end


    # Public: The time the run was started.
    #
    # started_at: The String time in ISO 8601.
    attr_writer :started_at

    # Public: The time the run was started.
    def started_at
      Time.iso8601 @started_at
    end


    # Public: The number of calories burned in the run.
    #
    # calories: The String number of calories.
    attr_writer :calories

    # Public: The number of calories burned in the run.
    attr_reader :calories


    # Public: The description of the run.
    #
    # description: The String details of the run.
    attr_writer :description

    # Public: The description of the run.
    attr_reader :description


  # INTERNAL METHODS #########################################################

    # Private: The distance of the run in miles.
    def distance_to_mi
      case @unit
      when 'mi' then distance.to_f
      when 'km' then distance.to_f * 0.621371192
      end
    end

  end

end
