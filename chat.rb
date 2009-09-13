%w(rubygems sinatra activerecord erb sanitize).each do |lib|
  require lib
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

ActiveRecord::Base.establish_connection({:adapter => 'mysql', :database => 'chat', :host => 'localhost', :username => 'root'})

class Message < ActiveRecord::Base
  before_save :sanatize_all
  
  def self.delete_old
    find(:all, :conditions => ['created_at < ?', Time.now - 10.minuites ])
  end
  
  private
  
  def sanatize_all
    self.body = Sanitize.clean(self.body)
    self.name = Sanitize.clean(self.name)    
  end
end

enable :sessions

get "/" do
  erb :index
end


get "/messages" do
  session[:message_cursor] ||= Message.last.id
  result = ''
  loop do
    messages = Message.find(:all, :conditions => ['id > ?', session[:message_cursor]])
    unless messages.empty?
      messages.each do |message|
        result << "<div class='message'><span class='name'>#{h message.name}</span> <span class='body'>#{h message.body}</span><span class='time'>#{Time.now.strftime('%I:%M %p %d/%h')}</div>"
      end
      session[:message_cursor] = messages.last.id
      break       
    else
      sleep(1)
    end
  end
  result
end

post "/messages" do  
  m=Message.new(params[:message])
  
  if m.save    
    'okay'    
  else
    'not okay'
  end
end
