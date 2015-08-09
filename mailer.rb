require 'mail'

options = { 
            :address              => "smtp.gmail.com",
            :port                 => 587,
            :user_name            => '<Your email>',
            :password             => '<password>',
            :authentication       => 'plain',
            :enable_starttls_auto => true  
}


Mail.defaults do
  delivery_method :smtp, options
end

module SendMail


    def SendMail.send_mail(content)

        Mail.deliver do
               to '<to who>'
             from '<your email>'
          subject 'Hey! Youbiker程式出了問題'
             body "#{content}"
        end

    end
end
