class TweetsController < ApplicationController

  get '/tweets' do
    if logged_in?
      @tweets = Tweet.all
      erb :'/tweets/tweets'
    else
      redirect to '/login'
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :'/tweets/new'
    else
      redirect to '/login'
    end
  end

  post '/tweets' do
    if params[:content].empty?
      redirect to '/tweets/new'
    elsif logged_in?
      @tweet = Tweet.find_or_create_by(:content => params[:content])
      @tweet.user_id = session[:user_id]
      @tweet.save
      redirect to "/tweets/#{@tweet.id}"
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    if logged_in? && current_user[:id] == @tweet.user_id
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/show_tweet'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do
    if !logged_in?
      redirect to '/login'
    else
      @tweet = Tweet.find(params[:id])
      erb :'tweets/edit_tweet'
    end
  end

  patch '/tweets/:id' do
    if !logged_in?
      redirect to '/login'
    elsif params[:content].empty?
      redirect to "/tweets/#{params[:id]}/edit"
    else
      @tweet = Tweet.find(params[:id])
      params.delete('_method')
      @tweet.update(params)
      redirect to "/tweets/#{@tweet.id}"
    end
  end

  delete '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    if logged_in? && current_user[:id] == @tweet.user_id
      @tweet.delete
      redirect to '/tweets'
    elsif logged_in?
      redirect to '/tweets'
    else
      redirect to '/login'
    end
  end

end
