require "resend"

class ResendDeliveryMethod
  def initialize(settings)
    @settings = settings
    Resend.api_key = settings[:api_key]
  end

  def deliver!(mail)
    # Extract content
    html_content = mail.html_part&.body&.decoded
    text_content = mail.text_part&.body&.decoded || mail.body&.decoded

    # Fallback if only one part exists
    html_content ||= text_content if mail.mime_type == "text/html"
    text_content ||= html_content if mail.mime_type == "text/plain"

    params = {
      from: mail.from.first,
      to: mail.to,
      subject: mail.subject,
      html: html_content,
      text: text_content,
      cc: mail.cc,
      bcc: mail.bcc,
      reply_to: mail.reply_to
    }

    # Remove nil values
    params.compact!
    params.delete_if { |k, v| v.nil? || v.empty? }

    puts "Sending via Resend API: #{params.except(:html, :text)}"
    Resend::Emails.send(params)
  end
end
