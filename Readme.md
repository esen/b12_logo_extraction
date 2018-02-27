# Logo Extraction #

This script extracts logo image from given website. Following assumptions are considered:

- Logo image name contains 'logo' string
- Logo image may contain one ore more words of the page's title
- If an image does not contain 'logo' string but has some ancestors in a DOM tree which have *id*, *class* or *data_original_src* which contain 'logo' string,
it can be a logo image.
- The most relevant image is the one whose name contains the least number of symbols around 'logo' string
- If an image navigates to any other website on click, it's not considered as logo
- If screen size is 400x800, then logo image may not occupy more than 60000px area on screen

## Results ##

This script finds 40 correct results out of 45 given samples. But some sites take too long for navigation(up to 10 minutes). So I put 40 sedonds timeout for navigation. This makes some sites fail with timeout and the total number of correct results is 37-38 out of 45.


## Prerequisites ##

- *ruby 2.3.4*
- *Google Chrome 64.* (64-bit)
- *selenium-webdriver*
- *rspec* to run tests

## Installation ##

- Go to https://rvm.io/rvm/install and install rvm
- `rvm install 2.3.4` to install ruby
- `rvm gemset create b12` create separate gemset for the script
- `rvm gemset use b12`
- `gem install bundler`
- Extract this `b12.zip` package and go to the directory
- `bundle --deployment` install dependencies


## Run ##

You need to have *logo-extraction.txt* files with the list of urls in the same format as in the sample file given. (With leading headers row just like in sample)

- `ruby ./scrape.rb` to run the script.
- `rspec --format documentation` to run the tests.




