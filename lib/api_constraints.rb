class ApiConstraints

  MIME_TYPE_BASE = "application/vnd.marketplace"

  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(request)
    @default || request.headers['Accept'].include?("#{MIME_TYPE_BASE}.v#{@version}")
  end

end