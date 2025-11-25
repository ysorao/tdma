class NotificationCreditsWorker
  include Sidekiq::Worker

  def perform(id)
  	client = Client.find(id)
    EmailDocumentation.notice_credits_client(client).deliver_now
  end
end