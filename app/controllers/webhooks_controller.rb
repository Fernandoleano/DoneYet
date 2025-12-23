class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret)

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError
      render json: { error: "Invalid payload" }, status: 400
      return
    rescue Stripe::SignatureVerificationError
      render json: { error: "Invalid signature" }, status: 400
      return
    end

    # Handle the event
    case event.type
    when "checkout.session.completed"
      handle_checkout_completed(event.data.object)
    when "customer.subscription.updated"
      handle_subscription_updated(event.data.object)
    when "customer.subscription.deleted"
      handle_subscription_deleted(event.data.object)
    when "invoice.payment_failed"
      handle_payment_failed(event.data.object)
    end

    render json: { message: "success" }
  end

  private

  def handle_checkout_completed(session)
    workspace_id = session.metadata.workspace_id
    workspace = Workspace.find(workspace_id)

    subscription = Stripe::Subscription.retrieve(session.subscription)

    workspace.update(
      stripe_subscription_id: subscription.id,
      subscription_status: :active,
      plan_type: :pro
    )

    Rails.logger.info "Subscription activated for workspace #{workspace.id}"
  end

  def handle_subscription_updated(subscription)
    workspace = Workspace.find_by(stripe_subscription_id: subscription.id)
    return unless workspace

    status = case subscription.status
    when "active"
      :active
    when "past_due"
      :past_due
    when "canceled", "unpaid"
      :canceled
    else
      :trial
    end

    workspace.update(subscription_status: status)
    Rails.logger.info "Subscription updated for workspace #{workspace.id}: #{status}"
  end

  def handle_subscription_deleted(subscription)
    workspace = Workspace.find_by(stripe_subscription_id: subscription.id)
    return unless workspace

    workspace.update(
      subscription_status: :canceled,
      plan_type: :free
    )

    Rails.logger.info "Subscription canceled for workspace #{workspace.id}"
  end

  def handle_payment_failed(invoice)
    workspace = Workspace.find_by(stripe_customer_id: invoice.customer)
    return unless workspace

    workspace.update(subscription_status: :past_due)
    Rails.logger.warn "Payment failed for workspace #{workspace.id}"
  end
end
