json.extract! thing, :id, :name, :description, :created_at, :updated_at
json.notes thing.notes   unless restrict_notes? thing.user_roles
json.url thing_url(thing, format: :json)
json.thing_type_id thing.thing_type_id unless restrict_type? thing.user_roles
json.user_roles thing.user_roles    unless thing.user_roles.empty?
