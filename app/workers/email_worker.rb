class EmailWorker
  include Sidekiq::Worker

  def perform(contact_list)
    puts contact_list.inspect
    puts contact_list.class
    # contact_list = JSON.load(contact_list)
    contact_list['contact_list'].each do |contact|
      puts contact.inspect
      if contact['email'].present?
        UserMailer.invitation_mail(contact['name'], contact['email']).deliver_now
      else
        TwilioConnect.perform(contact['phone'], 'hello world')
      end
    end
  end
end
