class UserMailer < Devise::Mailer
  include SendGrid
  sendgrid_category :use_subject_lines
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  default from: Figaro.env.mailer_sender
  
  def welcome_email user
    begin
      puts "INSide WELCOME EMAIL CALLED #{user}"
      @user = user
      puts "EMAIL: #{@user.email}"
      mail(to: @user.email, subject: 'Big Earth account confirmed!')
    rescue Exception => error
      puts "ERROR: #{error}"
      puts error
      puts error.message
    end
  end
end
