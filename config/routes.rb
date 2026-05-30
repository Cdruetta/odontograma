Rails.application.routes.draw do
  resources :patients do
    resources :odontograms, only: [:index, :show, :create] do
      member do
        post :update_tooth_state
        get  :update_tooth_state, to: redirect("/patients/%{patient_id}/odontograms/%{id}")
        post :create_new_version
        get  :create_new_version, to: redirect("/patients/%{patient_id}/odontograms/%{id}")
        post :undo_last_change
        get  :undo_last_change, to: redirect("/patients/%{patient_id}/odontograms/%{id}")
      end
    end
  end

  root "patients#index"
end
