module Fatigue

  # GARMIN
  # A class used to access Garmin Connect.
  class Garmin

    # Public: Create a new Garmin instance.
    #
    # username - The String of the Garmin Connect username.
    # password - The String of the Garmin Connect password.
    #
    # Returns a new Fatigue::Garmin instance.
    def initialize(username, password)
      @username = username
      @password = password
    end

    # Public: logs the instance into Garmin Connect.
    #
    # Returns true if successful login, false if unsuccessful.
    def login
      @agent = Mechanize.new
      login_page = @agent.get('https://connect.garmin.com/signin')
      form = login_page.form('login')
      form['login:loginUsernameField'] = @username
      form['login:password'] = @password
      page = @agent.submit(form, form.buttons.first)
      page.inspect =~ /Dashboard for/ ? true : false
    end

    # Public: logs the instance out of Garmin Connect.
    #
    # This is pretty important since Garmin hates multi-logins. Apparently?
    #
    # Returns true if successful logout, false if unsuccessful.
    def logout
      page = @agent.get('http://connect.garmin.com/dashboard')
      page.link_with(:text => 'Sign Out').click
      page.inspect =~ /aren't signed in/ ? true : false
    end

    # Public: gets the number, time and date formats from the settings page
    #
    # IF the user has different settings from the default, the form may return 
    # errors when trying to post runs
    #
    def get_formats
      page = @agent.get('http://connect.garmin.com/settings')
      html = Nokogiri::HTML(page.body)
      scr = html.css("script").select { |s| s.text =~ /(DATE_FORMAT)/ }.first.text

      date_value   = scr.match(/DATE_FORMAT = '(.+)'/)[1]
      time_value   = scr.match(/TIME_FORMAT = '(.+)'/)[1]
      number_value = scr.match(/NUMBER_FORMAT = '(.+)'/)[1]
      
      @date_format    = date_value.gsub('yyyy', '%Y').gsub('dd', '%d').gsub('MM', '%m')
      @time_format    = (time_value == 'twenty_four' ? '%H:%M' : '%I:%M %p' )
      @decimal_format = (number_value == 'decimal_comma' ? ',' : '.')
    end
    
    # Public: posts a new Run to your logged-in Garmin account.
    #
    # run - A Fatigue::Run instance.
    #
    # Returns true if success, false if failure. Requires #login to be called
    # prior to execution.
    def post_run(run)
      begin
        manual_run = @agent.get('http://connect.garmin.com/activity/manual')
        form = manual_run.form('manualActivityForm')
        form.activityBeginDate = run.started_at.strftime(@date_format)
        form.activityBeginTime = run.started_at.strftime(@time_format)
        form.field_with(:name => 'activityTimeZoneDecoration:activityTimeZone').
          options.select { |option|
            # select option where our timezones are equal (-07:00, etc)
            zone = run.started_at.getlocal.strftime('%z').gsub('+','\+').gsub('0000', '\(GMT\)')
            option.text.gsub(':','') =~ /#{zone}/
          }.first.select
        form['activityNameDecoration:activityName'] = run.formatted_name
        form.field_with(:name => 'activityTypeDecoration:activityType').
          options.select { |option| option.value == 'running' }.
          first.select
        form['speedPaceContainer:activitySummarySumDuration'] = run.hours
        form['speedPaceContainer:activitySummarySumDurationMinute'] = run.minutes
        form['speedPaceContainer:activitySummarySumDurationSecond'] = run.seconds
        form['speedPaceContainer:activitySummarySumDistanceDecoration:activitySummarySumDistance'] = run.distance.to_s.gsub('.', @decimal_format)
        form.field_with(:name => 'speedPaceContainer:activitySummarySumDistanceDecoration:distanceUnit').
          options.select { |option| option.text == run.unit }.first.select
        form['descriptionDecoration:description'] = run.description
        form['calories'] = run.calories
        form['AJAXREQUEST'] = '_viewRoot'
        form['saveButton'] = 'saveButton'
      
        resp = @agent.submit(form, form.buttons_with(:name => 'saveButton').first)
        verify_response(resp.body)
      rescue NoMethodError => e
        puts "Darn!\nGarmin logged us out while attempting to post a run on #{run.started_at.strftime(@date_format)}. Logging back in!"
        if login
          post_run(run)
        else
          puts "Couldn't log back in. Aborting."
          exit
        end
      end
    end

    # Public: Posts a collection of Runs to your logged-in Garmin account.
    #
    # runs - An Array of Fatigue::Run instances.
    #
    # Returns the number of runs successfully posted to the Garmin account.
    # Requires #login to be called prior to execution.
    def post_runs(runs)
      get_formats 
      progress = ProgressBar.new("  status", runs.size)
      runs.each do |run|
        post_run(run)
        progress.inc
      end
      progress.finish
      runs.size
    end


  # INTERNAL METHODS #########################################################

    # Verifies whether the response returned is successful or not. For some
    # reason Garmin isn't spitting out a redirect to the newly-created run, so
    # instead we hackishly check if an error <span> is filled.
    #
    # Returns a Boolean value for whether the response was successful or not.
    def verify_response(html_body)
      html = Nokogiri::HTML(html_body)
      html.css('#ErrorContainer').text.strip == ''
    end


  end

end
