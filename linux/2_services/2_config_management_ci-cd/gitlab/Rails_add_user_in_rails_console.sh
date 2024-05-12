his is quite a 'classic' problem and the immediate thought ("just do it mySQL") doesn't work here because of the need to have the rails piece that encodes a password that is entered.
So you need to actually use rails, something like this (this should all be happening in your local development environment which is the default when working locally):

You need to create a user.

Try this:

cd the_root_of_the_project

script/rails console

> User.create(:username => 'admin', 
  :password => 'abc123', 
  :password_confirmation => 'abc123') 
  # Add other fields, such as first_name, last_name, etc. 
  # as required by the user model validators.
  # Perhaps :admin => true
This assumes a few things (so change as required) such as an authentication system such as authLogic or devise, attribute and field names, etc, but you should be able to adjust to your needs. You can determine what these are by looking at a few things, specifically the database migration files in db/migrate, the model validations in user/model/user, any existing "seeds" filew for users in db/seeds.rb and the authentication system hooks.

As to 'where' to do this - obviously the console works but you might also want to use the seeds file for this. Whatever 'create' command you use in the console can be placed in here, then run with rake db:seed. The downside is that if you check this file into source control it's less secure. The seeds file is really useful for other tasks such as creating reference tables, initial categories, etc.

If you don't have the database actually created at all yet, you'll need to be aware of and use these tasks:

rake db:create 
# as it sounds, creates a database (but no application tables or columns), 
# using the config/database.yml file for the connection info.

rake db:migrate 
# Creates tables and columns using the db/migrate/ files.

rake db:seed 
# Runs commands in db/seeds.rb to create initial records for the application.