class Subdomain
  @position = Rails.env.staging? ? 2 : 1
  class << self
    attr_reader :position

    def matches?(request)
      request.subdomain.present? &&
        !['www', ''].include?(request.subdomain(@position))
    end

    def get_subdomain(request)
      request.subdomain(@position)
    end
  end
end
