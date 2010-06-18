# Put your extension routes here.
map.root :controller => "static_content", :action => "index"

map.namespace :admin do |admin|
  admin.resources :pages
  admin.new_sub '/admin/pages/new_sub/:id', :controller => 'pages', :action => 'new_sub' 
end

map.static '/static/*path', :controller => 'static_content', :action => 'show'
