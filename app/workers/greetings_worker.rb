class GreetingsWorker
  include Sidekiq::Worker

  def perform(network_id)
    network = Network.find_by(id: network_id)
    network.users.each do |u|
      UserMailer.greetings_mail(u.email).deliver_now
    end
  end
end
