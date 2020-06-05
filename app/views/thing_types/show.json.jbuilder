json.array! (@things) do |thing|
	json.extract! thing, :id, :name
end