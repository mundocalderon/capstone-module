json.array! (@thing_types) do |tt|
	json.extract! tt, :id, :name, :description, :created_at, :updated_at
end