require 'nokogiri'
require 'fileutils'
require 'uri'
require 'open-uri'

begin
    # FileUtils.cp(ARGV[0], ARGV[0]+".bak")
    File.open(ARGV[0]) do |file|
        file.each_line do |labmen|
            if md = labmen.match(/repo\s?=\s?'(.*)'/)
                uri = URI('https://github.com/' + md[1])
                charset = nil
                html = open(uri) do |f|
                    charset = f.charset
                    f.read
                end
                doc = Nokogiri::HTML.parse(html, nil, charset)
                doc.xpath('//span[@itemprop="about"]').each do |node|
                    description = node.text
                    if md = description.match(/([a-zA-Z\s]+)/)
                        puts md[0]
                    end
                end
            end
        end
    end
rescue
end

