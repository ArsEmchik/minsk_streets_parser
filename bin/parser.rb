#!/usr/bin/env ruby

require 'mechanize'
require 'open-uri'
require 'translit'
require 'csv'

Dir[File.expand_path('../../lib/**.rb', __FILE__)].each { |f| require(f) }

#################################################
#street:
  # type
  # name
  # district
  # home
  # corps
#################################################
streets = Scrapers::Streets.scrapes
#################################################


#################################################
# to CSV
#################################################
CSV.open("streets.csv", "wb") do |csv|
  csv << %w(street_name home corps district_name district_short district_latin)
  streets.each do |s|
    csv << ["#{s[:type]} #{s[:name]}", s[:home], s[:corps], s[:district], s[:district][0..2],
            Translit.convert(s[:district][0..2].force_encoding("UTF-8"), :english)]
  end
end
#################################################
