require 'slack/incoming/webhooks'

class Notifier
  def notify(urls, game_name:)
    Slack::Incoming::Webhooks.new(Environment.fetch(:SLACK_WEBHOOK_URL)).post <<~EOS
      New build available for *#{game_name}*
      #{urls.map { |url| "<#{url}>" }.join("\n")}
    EOS
  end
end
