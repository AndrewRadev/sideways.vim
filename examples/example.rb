link_to 'Something', user_registration_path

link_to 'Something', user_registration_path do |x|
  # ...
end

link_to 'Something Else', user_registration_path

foo = (link_to 'Something', user_registration_path)

link_to "So#mething", user_registration_path # foo

# TODO Not working yet
if (one and two) or three
  three
end
