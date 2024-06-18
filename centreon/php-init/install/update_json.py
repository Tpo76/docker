import os
import json

# Get the directory of the Python script
script_dir = os.path.dirname(os.path.realpath(__file__))

# Construct the absolute path to the database.json file
database_file = os.path.join(script_dir, 'configuration', 'database.json')

# Read the JSON file
with open(database_file, 'r') as file:
    data = json.load(file)

# Get environment variables
mysql_root_password = os.getenv('MYSQL_ROOT_PASSWORD')
centreon_db_password = os.getenv('CENTREON_DB_PASSWORD')

# Update the JSON data
if mysql_root_password is not None:
    data['root_password'] = mysql_root_password
if centreon_db_password is not None:
    data['db_password'] = centreon_db_password
    data['db_password_confirm'] = centreon_db_password

# Write the updated data back to the JSON file
with open(database_file, 'w') as file:
    json.dump(data, file, indent=2)