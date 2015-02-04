module Scrapers
  PARSE_URL = 'https://ru.wikipedia.org/wiki/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA_%D1%83%D0%BB%D0%B8%D1%86_%D0%9C%D0%B8%D0%BD%D1%81%D0%BA%D0%B0'.freeze

  class Base
    def self.mechanize
      @mechanize ||= Mechanize.new do |agent|
        agent.user_agent_alias = 'Linux Firefox'
      end
    end
  end

  class Streets < Base
    class << self
      def scrapes
        street_array = []

        table_rows.each do |row|
          row_cells = row.css('td')
          address_array = prepare_homes(row_cells[4].text)

          row_cells[3].text.split(' ').each do |district|
            district = district.gsub(/[^А-Яа-я]/, '')
            if address_array.empty?
              street_array << {
                  type: row_cells[1].text,
                  name: row_cells[0].text,
                  district: district,
                  home: 1,
                  corps: nil
              }
            else
              address_array.each do |address|
                street_array << {
                    type: row_cells[1].text,
                    name: row_cells[0].text,
                    district: district,
                    home: address[:home],
                    corps: address[:corps]
                }
              end
            end
          end
        end
        street_array
      end

      private

      def prepare_homes(str_homes)
        address_array = []

        str_homes.split(', ').each do |home|
          home, corp_chr, corp_num = home.partition(/[А-Я]/)
          address_array << {
              home: home.to_i,
              corps: corp_chr + corp_num
          }
        end
        address_array
      end

      def table_rows
        page = page_content
        page.parser.css('table').first.css('tr')[1..-1]
      end

      def page_content
        mechanize.get(PARSE_URL)
      end
    end
  end
end
