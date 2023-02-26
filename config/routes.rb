Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "birds#index"
  get '/birds/random', to: 'birds#random'
  get '/birds/appledore', to: 'birds#appledore'
  get '/birds/appledore/random', to: 'birds#appledore_random'

end
