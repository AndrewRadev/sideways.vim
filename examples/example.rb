link_to 'Something', user_registration_path

link_to 'Something', user_registration_path do |x|
  # ...
end

foo = (link_to 'Something', user_registration_path)

link_to "So#mething", user_registration_path # foo

# TODO Not working yet
if (one and two) or three
  three
end
