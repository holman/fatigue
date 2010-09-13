require File.join(File.dirname(__FILE__), *%w[helper])

context "Nike" do

  setup do
    @nike = Fatigue::Nike.new(1)
  end
  
  test "runs" do
    mock(@nike).run_list_xml  { fixture('runs.xml') }
    #mock(@nike).user_data_xml { fixture('user.xml') }
    runs = @nike.runs

    assert_equal runs.size,                     2
    assert_equal runs.first.distance,           '3'
    assert_equal runs.last.duration,            1000000
  end

end
