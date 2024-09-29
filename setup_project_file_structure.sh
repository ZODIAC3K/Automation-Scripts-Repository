
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

# Function to check if jq is installed
check_jq() {
  if ! command -v jq &> /dev/null; then
    echo "jq is not installed."
    echo "Please install jq to proceed."

    # Check the OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
      echo "You can install jq using Homebrew with the following command:"
      echo "brew install jq"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      echo "You can install jq using the following command:"
      echo "sudo apt-get install jq" # For Debian-based systems
      echo "or"
      echo "sudo yum install jq"     # For Red Hat-based systems
    else
      echo "Please install jq manually."
    fi

    exit 1
  fi
}

# Function to create directories and files for CommonJS
create_commonjs_structure() {
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

  # Initialize npm for CommonJS
  npm init -y

  # Install nodemon globally
  npm install -g nodemon

  # Add scripts to package.json
  jq '.scripts += {"start": "node index.js", "dev": "nodemon index.js"}' package.json > tmp.json && mv tmp.json package.json
  echo 'Scripts for CommonJS added to package.json.'

  echo "CommonJS setup complete!"
}

# Function to create directories for ES modules
create_es_structure() {
  # Define the directories to create
  directories=(
    "config"
    "middlewares"
    "models"
    "services"
    "controllers"
  )

  # Loop through the directories array and create each folder
  for dir in "${directories[@]}"; do
    # Create the directory if it doesn't exist (-p ensures no error if it exists)
    mkdir -p "$dir"
    echo "Created $dir"
  done

  # Create the root index.js file if it doesn't exist
  if [ ! -f "index.js" ]; then
    touch index.js
    echo "// Main entry point" > index.js
    echo "Created root index.js"
  else
    echo "Root index.js already exists, skipping creation."
  fi

  # Initialize npm and add type to package.json
  npm init -y

  # Set type to module in package.json
  # Get the existing package.json and insert type: "module" after "main"
  jq '. + {type: "module"} | .main = "index.js" | .type = "module"' package.json > tmp.json && mv tmp.json package.json
  echo 'Type set to "module" in package.json.'

  # Install nodemon globally
  npm install -g nodemon

  # Add scripts to package.json
  jq '.scripts += {"start": "node index.js", "dev": "nodemon index.js"}' package.json > tmp.json && mv tmp.json package.json
  echo 'Scripts for ES Modules added to package.json.'

  echo "ES module setup complete!"
}

# Check if jq is installed
check_jq

# Prompt user for the module type
echo "Select the module system:"
echo "1) CommonJS"
echo "2) ES Modules"
read -p "Press Enter for ES Modules (or type 1/2): " module_type

# Set default to ES if no input is provided
if [ -z "$module_type" ]; then
  module_type="2"
fi

case "$module_type" in
  "1")
    create_commonjs_structure
    ;;
  "2")
    create_es_structure
    ;;
  *)
    echo "Invalid option. Please select '1' for CommonJS or '2' for ES Modules."
    ;;
esac

echo "Setup process finished!"