#!/bin/bash

# Function to check if a file is empty
is_file_empty() {
    if [ -s "$1" ]; then
        return 1  # Not empty
    else
        return 0  # Empty
    fi
}

# Function to handle errors and ask for input until a valid file is provided
handle_errors() {
    while true; do
        read -p "Enter the path to the CSV file: " csv_path
        if [[ $csv_path == *.csv ]]; then
            if [ -f "$csv_path" ]; then
                if is_file_empty "$csv_path"; then
                    read -p "CSV file is empty. Do you want to continue? (y/n): " choice
                    case $choice in
                        [Yy]* ) continue;;
                        [Nn]* ) exit;;
                        * ) echo "Please enter 'y' for Yes or 'n' for No.";;
                    esac
                else
                    break
                fi
            else
                read -p "File not found. Do you want to continue? (y/n): " choice
                case $choice in
                    [Yy]* ) continue;;
                    [Nn]* ) exit;;
                    * ) echo "Please enter 'y' for Yes or 'n' for No.";;
                esac
            fi
        else
            echo "Not a CSV file. Please provide a CSV file."
            read -p "Do you want to continue? (y/n): " choice
            case $choice in
                [Yy]* ) continue;;
                [Nn]* ) exit;;
                * ) echo "Please enter 'y' for Yes or 'n' for No.";;
            esac
        fi
    done
}

# Function to sanitize URL
sanitize_url() {
    local url="$1"
    # Removes unknown characters from URL
    sanitized_url=$(echo "$url" | sed 's/[^a-zA-Z0-9\/:.-]//g')
    echo "$sanitized_url"
}

# Function to sanitize title
sanitize_title() {
    local title="$1"
    echo "$title"
}

# Function to get category from URL
get_category() {
    local url="$1"
    # Extracts the common prefixes to determine the category
    category=$(echo "$url" | awk -F'/' '{print $4}')
    echo "$category"
}

# Function to sanitize and restructure the CSV data
sanitize_and_restructure_csv() {
    local input_csv="$1"
    local output_csv="./cleaned_csv/$(basename "$input_csv")"

    # Create cleaned_csv folder if it doesn't exist
    if [ ! -d "./cleaned_csv" ]; then
        mkdir -p "./cleaned_csv"
    fi

    # Checks if input CSV file exists or not
    if [ ! -f "$input_csv" ]; then
        echo "Error: Input CSV file not found."
        exit 1
    fi

    # Creates an output CSV file with headers
    echo "Category,URL,Title" > "$output_csv"

    # Reads input CSV file line by line
    while IFS=, read -r url title; do
        # Sanitize URL and title
        sanitized_url=$(sanitize_url "$url")
        sanitized_title=$(sanitize_title "$title")

        # Get category from URL
        category=$(get_category "$sanitized_url")

        # Write the sanitized data into the  output CSV file
        echo "$category,$sanitized_url,\"$sanitized_title\"" >> "$output_csv"
    done < "$input_csv"

    echo "Sanitized and restructured data saved to $output_csv."
}

# Displays welcome message
echo "Welcome to CSV Cleaner and Categorizer"

# Asks whether to clean and categorize the CSV file or not
while true; do
    read -p "Do you want to clean and categorize the CSV file? (y/n): " choice
    case $choice in
        [Yy]* ) handle_errors; break;;
        [Nn]* ) exit;;
        * ) echo "Please enter 'y' for Yes or 'n' for No.";;
    esac
done

# Only runs sanitize_and_restructure_csv function if the CSV file is not empty
if ! is_file_empty "$csv_path"; then
    sanitize_and_restructure_csv "$csv_path"
    python cleanRestructure.py "$csv_path"

    # Checks if output JSON file was generated successfully
    json_dir="./json_file"
    output_json_path="$json_dir/$(basename "$csv_path" .csv).json"  # Creates an  output JSON file path inside the ./json_file directory
    if [ -f "$output_json_path" ]; then
        echo "JSON file created successfully: $output_json_path"
        
        start Table_Page.html
    else
        echo "Error: JSON file not created."
    fi
fi
