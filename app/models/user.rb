# id                        integer       not null, unique
# active                    boolean       default(false)
# admin                     boolean       default(false)
# current_period_end        date          default(previous day)
# email                     string        not null, unique
# name                      string        not null
# stripe_customer_id        string        not null, unique
# stripe_subscription_id    string

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :stripe_customer_id, unless: :admin
  validates_uniqueness_of :stripe_customer_id

  scope :admins, -> { where('admin = true').order('name asc') }
  scope :active_members, -> { where('active = true').order('name asc') }
  scope :inactive_members, -> { where('active = false').order('name asc') }

  before_create :set_default_current_period_end

  def initialize(args = nil)
    super(args)
    set_stripe_customer_id unless is_admin?
  end

  def membership_active?
    # TODO: since changed to datetime, allow for
    # access through whole day, even if time has passed
    # TODO: make tests for different time zones, ensure they have access in their time
    return false unless current_period_end
    self.current_period_end.to_date >= Time.zone.today
  end

  def is_admin?
    self.admin
  end

  def set_end_date(event)
    if event.respond_to?(:current_period_end)
      # Upon stripe subscription object
      # byebug
      sub_end = Time.zone.at(event.current_period_end)
    else
      # Webhook object returned by Stripe on invoice.payment_succeeded
      sub_end = Time.zone.at(event.data.object.period_end)
    end

    self.current_period_end = sub_end
    self.save
  end

  def subscribe
    raise 'Already subscribed' if subscribed?

    @stripe_subscription = Stripe::Subscription.create({
      customer: self.stripe_customer_id,
      items: [{plan: stripe_plan.id}]
    })

    set_end_date(@stripe_subscription)
    set_active

    self.stripe_subscription_id = @stripe_subscription.id
    self.save
  end

  def cancel
    stripe_subscription.delete(at_period_end: true)

    self.active = false
    self.save
  end

  def add_payment_method(token)
    new_payment_method = stripe_customer.sources.create({source: token})
    stripe_customer.default_source = new_payment_method.id

    # REVIEW: doesn't this need a writer method
    @default_payment_method = new_payment_method
  end

  def re_activate
    raise 'Subscription already active' if subscribed?

    stripe_subscription.items = [{
        id: stripe_subscription.items.data[0].id,
        plan: stripe_plan.id,
    }]
    stripe_subscription.save

    self.active = true
    self.save
    # REVIEW: do I need to call .save each time?
  end

  def default_payment_method
    return unless stripe_customer
    @default_payment_method ||= stripe_customer.sources.retrieve(stripe_customer.default_source)
  end

  def payment_methods
    return unless stripe_customer
    stripe_customer.sources.list.data
  end

  def subscribed?
    active && membership_active?
  end

  private
    def set_stripe_customer_id
      begin
        self.stripe_customer_id = Stripe::Customer.create.id
      rescue
        self.stripe_customer_id = nil
      end
    end

    def set_default_current_period_end
      self.current_period_end = Date.today - 1
    end

    def stripe_customer
      raise "Cannot get stripe_customer when customer id not set" unless self.stripe_customer_id

      begin
        @stripe_customer ||= Stripe::Customer.retrieve(self.stripe_customer_id)
      rescue
        @stripe_customer = nil
      end
    end

    def stripe_subscription
      raise "Subscription doesn't exist" unless self.stripe_subscription_id

      begin
        @stripe_subscription ||= Stripe::Subscription.retrieve(self.stripe_subscription_id)
      rescue
        @stripe_subscription ||= nil
      end
    end

    def stripe_subscription_active?
      stripe_subscription.status == 'active'
    end

    def stripe_plan
      @stripe_plan ||= Stripe::Plan.retrieve('basic')
    end

    def set_active
      raise "Cannot set membership as active" unless membership_active?

      self.active = true
      self.save
    end

    def set_default_current_period_end
      self.current_period_end = Time.zone.today - 1
    end
end
