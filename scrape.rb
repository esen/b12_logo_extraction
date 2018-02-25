require './lib/helpers/url_helper'
require './lib/helpers/relevance_calculator'
require './lib/browser'
require './lib/browsers/google_chrome_browser'
require './lib/html_node'
require './lib/html_nodes/google_chrome_html_node'
require 'csv'

input_file = './logo-extraction.txt'
csv = CSV.parse(File.read(input_file))
csv.shift
urls = csv.map(&:first).reject(&:nil?)

browser = GoogleChromeBrowser.new

urls.each do |url|
  print url + ' => '

  browser.scan(url)
  if browser.best_node
    print browser.best_node.logo_url.to_s
  else
    print browser.error || 'No Logo'
  end

  puts
end

browser.close
