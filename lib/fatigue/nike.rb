module Fatigue

  # NIKE
  # Nike grabs your runs from Nike
  class Nike

    # Public: Create a new Nike+ instance.
    #
    # id - Numeric Nike+ user ID (see readme.markdown for determining this)
    #
    # Returns a fresh Nike instance.
    def initialize(id)
      @id = id
    end

    # Public: Get all the runs for this user
    #
    # Returns an array of Fatigue::Run instances.
    def runs
      #structure = Nokogiri::XML(user_data_xml)
      #unit = structure.xpath('.//plusService/userOptions/distanceUnit').
      #          first.text
      structure = Nokogiri::XML(run_list_xml)
      structure.xpath('.//plusService/runList/run').inject([]) do |list,xml|
        run = Fatigue::Run.new
        run.service     = 'Nike+'
        run.unit        = 'km' # I think Nike+ hardcodes km
        run.name        = get_value('name',xml)
        run.distance    = get_value('distance',xml)
        run.duration    = get_value('duration',xml)
        run.started_at  = get_value('startTime',xml)
        run.calories    = get_value('calories',xml)
        run.description = get_value('description',xml)
        list << run
      end
    end


  # INTERNAL METHODS #########################################################
   

    # Builds the Nike+ XML url and retreives it.
    #
    # Returns a string of the list of your runs in XML format.
    def run_list_xml
      run_url  = 'http://nikerunning.nike.com/nikeplus/v1/services/widget/get_public_run_list.jsp?userID='
      run_url += @id.to_s
      open(run_url)
    end

    # Builds the Nike+ user XML url and retreives it. This has unit data.
    #
    # Returns a string of your account in XML format.
    def user_data_xml
      run_url  = 'http://nikerunning.nike.com/nikeplus/v1/services/widget/get_public_user_data.jsp?userID='
      run_url += @id.to_s
      open(run_url)
    end

    # Parses a line of XML for a given attribute.
    #
    # attribute - The node we are searching for.
    #       xml - The line of XML we should search in.
    #
    # Returns a scalar value of the attribute.
    def get_value(attribute,xml)
      xml.xpath(".//#{attribute}").first.content
    end

  end

end
