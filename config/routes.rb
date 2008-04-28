ActionController::Routing::Routes.draw do |map|
  map.resources :attachments

  map.resources :dentists

  map.resources :doctors

  map.connect '/resources', :controller => 'resources', :action => 'index'

  map.resources :marks

  map.resources :photos, :member => { :raw => :get, :custom_size => :get, :set => :post }

  map.resources :users, :member => { :activate => :get }

  map.resources :positions

  map.resources :sessions

  map.resources :teams

  map.namespace(:hiring) do |hiring|
    hiring.resources :interviews, :has_many => [:comments, :interviewings]
    hiring.resources :candidates, :has_many => [:comments, :interviews, :screens, :homeworks]
    hiring.resources :screens,    :has_many => [:comments]
    hiring.resources :homeworks,  :has_many => [:comments]
    hiring.resources :comments
    hiring.root :controller => 'hiring', :action => 'overview'
  end

  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.reminder '/reminder', :controller => 'users', :action => 'reminder'
  map.reset '/reset/:id', :controller => 'users',:action => 'reset'

  map.with_options :controller => 'tags', :action => 'show' do |tag|
    tag.tag  'tags/:tag', :tag => nil
    tag.tags 'tags/*tags'
  end

  map.connect '/index.xml', :controller => 'users', :format => 'xml', :action => 'index'

  map.connect ':controller/:action/:id'
  map.connect '', :controller => 'users'
end
