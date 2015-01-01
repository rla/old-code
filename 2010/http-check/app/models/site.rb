require "uri"

class Site < ActiveRecord::Base
  validates_presence_of :name, :url, :expression
  validates_uniqueness_of :name
  
  validate :expression_is_regex
  validate :url_is_ok
  
  cattr_reader :per_page
  @@per_page = 10
  
  
  def is_failed
    return !last_ok
  end
  
  def error_string
    if last_error.nil?
      "-"
    else
      last_error
    end
  end
  
  protected
  def expression_is_regex
    begin
      Regexp.new expression
    rescue Exception => e
      errors.add :expression, "is invalid: " + e.to_s
    end
  end
  
  def url_is_ok
    begin
      URI.parse url
    rescue Exception => e
      errors.add :url, "is invalid: " + e.to_s
    end
  end
end