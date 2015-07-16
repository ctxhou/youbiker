require "csv"
require "json"
require "open-uri"
require "net/http"
require "slop"
require "timers"
require 'fileutils'

class Crawl

    def initialize(options)
        @options = options
        @error = false
        @time = Time.now.strftime("%Y%m%d %T")
        @file_path = @options[:destination] ? "#{@options[:destination]}/youbike-#{@time}" :  "youbike-#{@time}"

        get_file
    end

    def loop_file
        @now = []
        @station = []
        unless @error # if no json parse error, select; else direct write the complete file
            @youbike_json.each do |data|
                if @options[:now]
                    @now << data.select { |key, value| ["iid", "sno", "sna", "sbi"].include?(key) }
                end
                if @options[:station]
                    @station << data.select { |key, value| ["iid", "sna", "sno", "tot", "sarea", "lat", "lng", "ar", "saraen", "snaen", "aren", "nbcnt", "bemp", "act"].include?(key)  }
                end
            end
            if @options[:now]
                self.to_json
            end

            if @options[:station]
                self.to_station_info
            end

        else @error
            self.to_error
        end

    end


    def to_station_info
        puts "Saving station information - #{@file_path}_station"

        File.open("#{@file_path}_station.json", "wb") do |file|
            file << conver_json(@station)
        end
    end


    def to_json
        puts "Saving exist situation - #{@file_path}"

        File.open("#{@file_path}.json", "wb") do |file|
            file << conver_json(@now)
        end
    end 

    def to_error
        puts "Saving error file"
        FileUtils.mkdir_p 'error'
        File.open("error/youbike_#{@time}.json", "wb") do |file|
            file << @youbike_json
        end
    end


    private

    def get_file
        youbike_data = Net::HTTP.get(URI.parse("http://opendata.dot.taipei.gov.tw/opendata/gwjs_cityhall.json"))

        begin
            @youbike_json = JSON.parse(youbike_data)
            @youbike_json = @youbike_json['retVal']
        rescue JSON::ParserError => e
            @youbike_json = youbike_data
            p "JSON parse error: #{e}"
            @error = true
        end
    end

    def conver_json(json)
        begin
            return json.to_json
        rescue
            p "JSON encoding error parse error"
            return json.to_json.force_encoding("ISO-8859-1").encode("UTF-8")
        end

    end

end


# main
opts = Slop.parse do |o|
    o.bool '-w', '--watch', '[boolean] enable crawl every 10 minutes', default: false
    o.bool '-n', '--now', '[boolean] get existing now', default: true
    o.bool '-s', '--station', '[boolean] get station info', default: false
    o.string '-d', '--destination', '[string] data destination; ex: ruby main.rb -d data; then save data in `data` folder'
    o.on '--help' do
      puts o
      exit
    end
end
opts = opts.to_hash
crawl = Crawl.new(opts)
crawl.loop_file
if opts[:watch]
    timers = Timers::Group.new
    five_second_timer = timers.every(600) {
        p 'Get new'
        crawl = Crawl.new(opts)
        crawl.loop_file
        p '==================='
    }
    loop { timers.wait }
end

