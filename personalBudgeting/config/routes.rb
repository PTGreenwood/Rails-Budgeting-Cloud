Rails.application.routes.draw do
  get 'myBudget/:user', to: 'budget#show'
  #get 'budget/create', to: 'budget#create'
  #get 'budget/delete', to: 'budget#delete'
  resources :posts
  resources :budget

  post 'update_values' => 'budget#update_values'

  post 'myBudget/:user/new_expense', to: 'budget#new_expense'
  post 'myBudget/:user/new_income', to: 'budget#new_income'
  post 'myBudget/:user/update_income_row/:row', to: 'budget#update_income_row'
  post 'myBudget/:user/update_expense_row/:row', to: 'budget#update_expense_row'
  post 'myBudget/:user/remove_expense/:row', to: 'budget#remove_expense'
    post 'myBudget/:user/remove_income/:row', to: 'budget#remove_income'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'posts#index'
end
