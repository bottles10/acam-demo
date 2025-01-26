class SubdomainConstraint
  def self.matches?(request)
    subdomain = request.subdomain
    subdomain.present? && subdomain != "www"
  end
end
