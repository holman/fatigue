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

    # Public: posts a new Run to your logged-in Garmin account.
    #
    # run - A Fatigue::Run instance.
    #
    # Returns true if success, false if failure. Requires #login to be called
    # prior to execution.
    def post_run(run)
      manual_run = @agent.get('http://connect.garmin.com/activity/manual')
      form = manual_run.form('manualActivityForm')
      form.activityBeginDate = run.started_at.strftime('%m/%d/%Y')
      form.activityBeginTime = run.started_at.strftime('%I:%M %p')
      form.field_with(:name => 'activityTimeZoneDecoration:activityTimeZone').
        options.select { |option|
          # select option where our timezones are equal (-07:00, etc)
          zone = run.started_at.getlocal.strftime('%z').gsub('+','\+')
          option.text.gsub(':','') =~ /#{zone}/
        }.first.select
      form['activityNameDecoration:activityName'] = run.formatted_name
      form.field_with(:name => 'activityTypeDecoration:activityType').
        options.select { |option| option.value == 'running' }.
        first.select
      form['speedPaceContainer:activitySummarySumDuration'] = run.hours
      form['speedPaceContainer:activitySummarySumDurationMinute'] = run.minutes
      form['speedPaceContainer:activitySummarySumDurationSecond'] = run.seconds
      form['speedPaceContainer:activitySummarySumDistanceDecoration:activitySummarySumDistance'] = run.distance
      form.field_with(:name => 'speedPaceContainer:activitySummarySumDistanceDecoration:distanceUnit').
        options.select { |option| option.text == run.unit }.first.select
      form['descriptionDecoration:description'] = run.description
      form['calories'] = run.calories
      form['AJAXREQUEST'] = '_viewRoot'
      form['saveButton'] = 'saveButton'
      
      resp = @agent.submit(form, form.buttons_with(:name => 'saveButton').first)

      verify_response(resp.body)
    end

    # Public: Posts a collection of Runs to your logged-in Garmin account.
    #
    # runs - An Array of Fatigue::Run instances.
    #
    # Returns the number of runs successfully posted to the Garmin account.
    # Requires #login to be called prior to execution.
    def post_runs(runs)
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
