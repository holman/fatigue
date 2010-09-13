require File.join(File.dirname(__FILE__), *%w[helper])

context "Garmin" do

  setup do
    @garmin = Fatigue::Garmin.new('username','password')
  end
  
  test "verify response" do
    error = @garmin.verify_response('<span id="ErrorContainer">An Error</span>')
    assert_equal false, error

    error = @garmin.verify_response('<span id="ErrorContainer"></span>')
    assert_equal true, error

    error = @garmin.verify_response('')
    assert_equal true, error
  end
end
