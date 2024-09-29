
#   ___ _   _ ____ _____ ____  _   _  ____ _____ ___ ___  _   _ 
#  |_ _| \ | / ___|_   _|  _ \| | | |/ ___|_   _|_ _/ _ \| \ | |
#   | ||  \| \___ \ | | | |_) | | | | |     | |  | | | | |  \| |
#   | || |\  |___) || | |  _ <| |_| | |___  | |  | | |_| | |\  |
#  |___|_| \_|____/ |_| |_| \_\\___/ \____| |_| |___\___/|_| \_|
                                                              

# 1. Save the script in the root directory of your project.
# 2. Make the script executable using the command:
#       chmod +x setup_project_file_structure.sh
# 3. Run the script using the command: 
#       ./setup_project_file_structure.sh


#   ____   ____ ____  ___ ____ _____ 
#  / ___| / ___|  _ \|_ _|  _ \_   _|
#  \___ \| |   | |_) || || |_) || |  
#   ___) | |___|  _ < | ||  __/ | |  
#  |____/ \____|_| \_\___|_|    |_|  
                                                                        

#!/bin/bash

# Define the directories to create
directories=(
  "config"
  "middlewares"
  "models"
  "services"
  "controllers"
)

# Loop through the directories array and create each folder with an index.js file
for dir in "${directories[@]}"; do
  # Create the directory if it doesn't exist (-p ensures no error if it exists)
  mkdir -p "$dir"

  # Create the index.js file inside the directory if it doesn't exist
  if [ ! -f "$dir/index.js" ]; then
    touch "$dir/index.js"
    echo "// index.js for $dir" > "$dir/index.js"
    echo "Created $dir with index.js"
  else
    echo "$dir/index.js already exists, skipping creation."
  fi
done

# Create the root index.js file if it doesn't exist
if [ ! -f "index.js" ]; then
  touch index.js
  echo "// Main entry point" > index.js
  echo "Created root index.js"
else
  echo "Root index.js already exists, skipping creation."
fi

# Create .env file in the config directory if it doesn't exist
if [ ! -f "config/.env" ]; then
  touch config/.env
  echo "# Environment variables" > config/.env
  echo "Created config/.env"
else
  echo "config/.env already exists, skipping creation."
fi

echo "Setup complete!"


