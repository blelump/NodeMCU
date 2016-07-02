Rails.application.routes.draw do
  match "data"  => "application#data", via: :post
end
