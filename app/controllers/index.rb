get '/' do

  erb :index
end


get '/:username' do

  @twitter_user = TwitterUser.find_or_create_by(username: params['username'])
  last_tweet = @twitter_user.tweets.last

  if last_tweet.still_valid?
    @tweets = @twitter_user.tweets.all
  else
    @twitter_user.tweets.destroy_all
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