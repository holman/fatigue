require File.join(File.dirname(__FILE__), *%w[helper])

context "Run" do

  setup do
    @run = Fatigue::Run.new
  end
  
  test "basic setters" do
    @run.duration = 5
    assert_equal 5, @run.duration

    @run.distance = 7
    assert_equal 7, @run.distance

    @run.unit = 'km'
    assert_equal 'Kilometers', @run.unit

    @run.calories = 100
    assert_equal 100, @run.calories
  end

  test "date conversion" do
    @run.started_at = '2009-03-17T04:02:43+00:00'
    assert_equal @run.started_at, Time.parse('Tue Mar 17 04:02:43 UTC 2009')
  end

  test "formatted name" do
    @run.service = 'Nike+'
    @run.name = 'I ran this while drunk'
    assert_equal @run.formatted_name, 'Nike+: I ran this while drunk'
  end

  test "seconds" do
    @run.duration = '1000000'
    assert_equal 40, @run.seconds
  end

  test "minutes" do
    @run.duration = 1000000
    assert_equal 16, @run.minutes
  end

  test "hours" do
    @run.duration = 5000000
    assert_equal 1, @run.hours
  end

  test "distance conversion" do
    @run.distance = '1'
    @run.unit = 'km'
    assert_in_delta 0.621, @run.distance_to_mi, 0.001
  end

  test "pace" do
    @run.distance = 14.484096 
    @run.unit = 'km'
    @run.duration = 5400000 
    assert_equal '10:00', @run.pace
  end

end
