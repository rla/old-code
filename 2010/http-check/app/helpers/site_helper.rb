require "net/http"
require "net/https"
require "uri"

class Net::HTTP
  alias_method :old_initialize, :initialize
  def initialize(*args)
    old_initialize(*args)
    @ssl_context = OpenSSL::SSL::SSLContext.new
    @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
end

module SiteHelper
  
  # Pulls all sites from the database and
  # runs checking procedure for all of them.
  
  def self.check_sites
    sites = Site.find :all
    
    sites.each { |site|
      check_site site
    }
  end
  
  private
  def self.check_site site
    start = Time.now
    site.last_ok = true
    
    begin
      contents = fetch site.url
      exp = Regexp.new site.expression
      unless exp.match contents then
        site.last_error = "Expression does not match contents"
        site.last_ok = false
      end
    rescue Exception => e
      site.last_error = e.message
      site.last_ok = false
    end
    site.time_taken = Time.now.to_f - start.to_f
    
    site.save
  end
  
  private
  def self.fetch(uri_string, limit_redirect = 20, read_timeout = 10, open_timeout = 10)
    raise ArgumentError, "HTTP redirect too deep" if limit_redirect == 0
    
    uri = URI.parse uri_string
    req = Net::HTTP::Get.new(uri.request_uri)
    
    port = uri.port
    if uri.scheme == "https"
      port = 443
    end
    
    http = Net::HTTP.new(uri.host, port)
    
    if uri.scheme == "https"
      http.use_ssl = true
    end
    
    http.read_timeout = read_timeout
    http.open_timeout = open_timeout
    
    res = http.start { |server|
      server.request(req)
    }
    
    case res
      when Net::HTTPSuccess then res.body
      when Net::HTTPRedirection then fetch(res["location"], limit_redirect - 1, read_timeout, open_timeout)
    else
      raise StandardError, res.error
    end
  end
end