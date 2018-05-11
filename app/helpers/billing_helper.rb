module BillingHelper
  def membership_status
    if current_user.membership_active? && current_user.active
      content_tag('span', "Active (next payment: #{current_user.current_period_end.to_date})")
    elsif current_user.membership_active? && !current_user.active
      content_tag('span', "Cancel (you have access through: #{current_user.current_period_end.to_date})")
    else
      content_tag('span', 'In-active')
    end
  end

  def subscription_status
    if current_user.active?
      content_tag('span', 'Standard ') +
        button_to('Unsubscribe', cancel_subscription_path, method: :delete, class: 'btn btn-danger')
    else
      content_tag('span', 'Standard ') +
        button_to('Subscribe', subscribe_path, class: 'btn btn-success')
    end
  end

  def card_details
    if current_user.last4
      content_tag('span', "Last 4 of card: #{current_user.last4}")
    else
      content_tag('span', 'No card on file')
    end
  end

  def subscription_buttons_path
    if current_user.active
      'cancel_button'
    else
      'reactivate_button'
    end
  end
end
