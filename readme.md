# CSV File Cleaner and Restructurer

## Usage

### 1. Run the Main Script
- Open your Linux/Bash terminal.
- Execute the `cleanRestructure.sh` file using the command `./cleanRestructure.sh`.

### 2. Initial Prompt
- Upon execution, a welcome message will be displayed.
- You will be prompted to choose whether to clean and restructure the CSV file or not by pressing `y/n`.

### 3. Input File Specification
- If you choose 'y', you'll be prompted for the path and name of the CSV file.
- By default, the file is expected to be in the same directory and named `Hyscaler.csv`.

### 4. Automated Process
- The script will handle the following tasks automatically:
  1. **Cleaning**: The input file (`Hyscaler.csv`) will be cleaned, and the cleaned version will be saved inside the `cleaned_csv` folder.
  2. **JSON Generation**: A JSON file with the same name as the input file will be generated inside the `json_file` folder.
  3. **Web Interface**: The script will open `Table_page.html` in the browser.
  4. **Data Representation**: In the web interface, you can choose the JSON file generated, and it will display the CSV data as a table. URLs with the same prefixes will be grouped together, and their descriptions will be displayed under the respective columns.

## Example

For the following CSV data:

URL,Description
https://example.com/data/ai,Example AI Overview - Test
https://example.com/data/ai/campus,Example AI Campus - Test
https://example.com/data/ai/courses,Example AI Courses 2023-2024

The displayed table will show:
- `https://example.com/data/ai` in the URL column.
- The descriptions under their respective columns:
  - "Example AI Campus - Test" in the Campus column of the 'ai' URL.
  - "Example AI Courses 2023-2024" in the Courses column.
  - "Example AI Overview - Test" in the Overview column because there's no further route after 'ai'.

## Error Handling
- The script handles various errors gracefully:
  1. File not found.
  2. Empty CSV file.
  3. Incorrect file type (not ".csv").
  4. Removal of unknown characters from URLs or descriptions.

---

