require 'spec_helper'

results = [
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/autoglassforyou.com/images/logo-change.gif",
    "",
    "",
    "",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/smileesthetics.com/wp-content/themes/customtheme/images/logo2.png",
    "",
    "http://catchmyparty.com/images/sprite.png",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/cabinfeverart.net/sitebuildercontent/sitebuilderpictures/GIFS/CABIN_FEVER_PENGUIN.gif",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/drejayejohnson.com/wp-content/uploads/2015/09/footer-logo.png",
    "",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/bjmweb.com/templates/bjmweb.com/images/shared/logo.png",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/bikeseeker.com/bikeseeker.png",
    "",
    "http://static1.squarespace.com/static/563ba927e4b0db9c22bf293a/t/5641385ce4b07ea8de566167/1478117464989/?format=1500w",
    "",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/searchforcloud.com/wp-content/uploads/2015/11/s4c.png",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/www.paintnsip.com/sites/default/files/banner2.png",
    "",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/www.actori.de/fileadmin/template/images/logo.png",
    "https://cdn.shopify.com/s/files/1/0942/7326/t/2/assets/logo.png?18364418680927880043",
    "http://zapgroup.co.il/img/0247/926.png?sitetimestamp=636136921870000000",
    "",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/thingks.nl/media/logo_thingks_wit.png",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/www.thechicagotherapist.com/dimg/websitetitle657638907headerbgheaderfg.gif",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/fitnessbycory.com/GYM_0/logo0-1352.gif",
    "",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/deaundrametzger.com/img/deedeelogo.gif",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/jsoul.io/img/icon.svg",
    "http://demo.misom.com/wp-content/uploads/2015/10/MainLogo_Black.png",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/handigekasten.nl/wp-content/uploads/2016/03/logo-nieuw.png",
    "https://www.glassetcher.com/wp-content/uploads/2015/04/custom-glass-etching-logo-without-crystal-award.png",
    "http://www.interconnectionelectric.com/images/logotype.jpg",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/www.linwoodcenter.org/wp-content/themes/linwood_theme/images/linwood_logo.gif",
    "https://boersenspiel.tradity.de/wp-content/uploads/2014/05/logo1-300x85.png",
    "http://travelstellar.com/wp-content/uploads/2016/04/travelstellar-logo-full.png",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/ptfitnesspros.com/assets/asset-1442581069484.png?v=0.6473335966147986",
    "",
    "https://cdn.shopify.com/s/files/1/0081/1222/t/71/assets/pure-cycles-logo-retina.png?268379148581693968",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/www.uquote.io/uploads/6/3/0/9/63094003/uquote-design-logo-v10-full-lb-clr.png",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/www.madonnaphillipsgroup.com/wp-content/uploads/2016/11/header-logo-3.png",
    "",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/www.hcapitaladvisors.com/wp-content/uploads/2014/05/hca-logo-colored1.png",
    "http://www.spazara.com/images/logo.png",
    "https://tablelocate.files.wordpress.com/2016/07/barelogotablelocate100pxhigh.png",
    "http://ground-truth-data.s3-website-us-east-1.amazonaws.com/amcfloors.com/wp-content/uploads/2013/07/header_logo.png",
    "https://www.whosampled.com/static/images/logos/logo-mobile.svg",
    "https://bitcoin.org/img/icons/logotop.svg"
]

files_dir = './spec/fixtures'
browser = JsonBrowser.new

describe 'samples' do
  Dir.foreach(files_dir) do |item|
    next if item == '.' or item == '..' or item == 'unit_test_fixture.json'
    rindex = item[0..1].to_i - 2

    it "should find #{results[rindex] || 'No Logo'}" do
      browser.scan("#{files_dir}/#{item}")

      logo_url = browser.best_node ? browser.best_node.logo_url.to_s : ''
      expect(logo_url).to eq(results[rindex])
    end
  end
end