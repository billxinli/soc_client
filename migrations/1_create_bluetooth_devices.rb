Sequel.migration do
  up do
    create_table(:bluetooth_devices) do
      primary_key :id
      String :bdaddr, null: false
      String :description
    end
  end

  down do
    drop_table(:bluetooth_devices)
  end
end
