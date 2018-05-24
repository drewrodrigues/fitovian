class CompletionHandler
  class << self
    def complete(user, resource) 
      return true if self.complete?(user, resource)
      user.completions.create(completable: resource) 
    end

    def complete?(user, resource)
      user.completions.find_by(completable: resource)
    end

    def incomplete(user, resource)
      return true unless self.complete?(user, resource)
      user.completions.find_by(completable: resource)&.destroy
    end
  end
end
