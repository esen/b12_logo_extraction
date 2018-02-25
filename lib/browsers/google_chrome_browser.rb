require 'selenium-webdriver'
require 'json'
require 'timeout'

class GoogleChromeBrowser < Browser
  WIDTH = 400
  HEIGHT = 800
  PIXEL_RATIO = 1
  TOUCH = false
  NAVIGATION_TIMEOUT = 40 # in seconds

  attr_accessor :error

  def navigate(url)
    @host = parse_url(url).host
    @error = nil

    begin
      Timeout::timeout(NAVIGATION_TIMEOUT) { driver.get(url) }
    rescue => ex
      @error = ex.message

      # Chromedriver doesn't let to stop navigation. Any command while navigation is in progress is ignored.
      # This is a workaround which just kills the chromedriver and starts a new one
      kill_driver
    end
  end

  def html_root_node
    GoogleChromeHtmlNode.new(driver.find_elements(:xpath => '*').first, self)
  end

  def title
    driver.title
  end

  def close
    driver.quit
  end


  private

  def driver
    return @driver if @driver

    options = Selenium::WebDriver::Chrome::Options.new()
    options.add_argument('--headless')
    options.add_emulation(device_metrics: {width: WIDTH, height: HEIGHT, pixelRatio: PIXEL_RATIO, touch: TOUCH})
    @driver = Selenium::WebDriver.for(:chrome, options: options, driver_opts: {log_path: '/Users/esen/mine/b12/log/chromedriver.log'})

    @driver
  end

  def kill_driver
    main_pid = Process.pid.to_s
    pids = `ps -eo pid,ppid | grep #{main_pid} | grep -iv grep`

    pids.split("\n").map do |pid_str|
      pid = pid_str.strip.split(/\s/).first
      next if pid == main_pid

      `kill #{pid} 2>&1 >/dev/null`
    end

    @driver = nil
  end
end