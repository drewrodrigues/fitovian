module BillingControllerTestHelper
  def subscribe
    post subscribe_path(StripeMock.create_test_helper.generate_card_token)
  end

  def run_stripe_mock
    StripeMock.start
    StripeMock.create_test_helper.create_plan(id: 'basic', amount: 1999, interval: 'month')

    yield

    StripeMock.stop
  end
end
