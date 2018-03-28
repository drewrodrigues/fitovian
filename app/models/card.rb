# default           boolean           not null, default(false)
# id                integer           not null, unique
# last4             string            not null
# stripe_id         string            not null

class Card < ApplicationRecord
  belongs_to :user

  validates_presence_of :last4
  validates_presence_of :stripe_id
  validates_presence_of :user

  before_save :ensure_only_default_payment_method

  def self.add_payment_method(token)
    # we don't catch the possible stripe error, so the
    # controller can catch it and display its message
    new_payment_method = self.user.stripe_customer.sources.create(source: token)
    stripe_customer.default_source = new_payment_method.id
    self.last4 = new_payment_method.last4
    set_default_payment_method
    self.save
  end

  private

    def set_default_payment_method
      self.user.cards.each {|c| c.update_attribute(default: false)}
      self.default = true
    end

    def ensure_only_default_payment_method
      count = self.user.cards.where(default: true).count
      throw :abort if count > 1
    end
end
