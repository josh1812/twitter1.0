get '/' do

  erb :index
end


get '/:username' do

  @twitter_user = TwitterUser.find_or_create_by(username: params['username'])
  @tweets = @twitter_user.tweets
  if @tweets.empty?
    @tweets = $client.user_timeline(params[:username])
    @tweets.each do |tweet|
      @twitter_user.tweets.create(text: tweet.text)
    end
  elsif @tweets.last.still_valid?
      @tweets
  else
    @tweets = $client.user_timeline(params[:username])
    @tweets.each do |tweet|
      @twitter_user.tweets.create(text: tweet.text)
    end
  end

  erb :index
end


post '/' do
  redirect "/#{params[:username]}"
end