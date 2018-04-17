class TransactionMailer < ApplicationMailer
  
  def send_info(user, statement)
  	@user = user
  	@statement = statement
    mail(to: user.email, subject: "Your statement is #{statement.status} ")
  end
end