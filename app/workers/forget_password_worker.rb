class ForgetPasswordWorker
  include Sidekiq::Worker

  def perform(user_id)
  	user = User.find(user_id)
    user.send_reset_password_instructions
  end
end