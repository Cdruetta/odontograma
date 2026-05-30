class MakeToothStateNullableInStateHistories < ActiveRecord::Migration[7.2]
  def change
    change_column_null :state_histories, :tooth_state_id, true
  end
end
