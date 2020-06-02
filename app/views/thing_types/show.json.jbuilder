json.array! (@things) do |thing|
	json.extract! thing, :id, :name, :description, :created_at, :updated_at
end