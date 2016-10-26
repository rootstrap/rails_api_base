json.user do
  json.partial! 'info', user: current_user
end
