function DisplayTable() {
  const fileInput = document.getElementById("jsonFile");
  const table = document.getElementById("dataTable");

  const reader = new FileReader();
  reader.onload = function (event) {
    const jsonData = JSON.parse(event.target.result);

    for (let i = 0; i < jsonData.length; i++) {
      const row = jsonData[i];
      const url = row["URL"];
      const descKeys = Object.keys(row).filter((key) => key !== "URL");

      // Finds the row in the table corresponding to the URL
      let urlRow;
      for (let j = 1; j < table.rows.length; j++) {
        if (table.rows[j].cells[0].textContent === url) {
          urlRow = table.rows[j];
          break;
        }
      }
      if (!urlRow) {
        // If the row does not exist, insert a new row
        urlRow = table.insertRow();
        urlRow.insertCell().textContent = url;
      }

      // Fills in data under the corresponding columns
      for (let j = 1; j < table.rows[0].cells.length; j++) {
        const columnName = table.rows[0].cells[j].textContent.toLowerCase();
        for (let k = 0; k < descKeys.length; k++) {
          const descKey = descKeys[k].toLowerCase();
          if (columnName === descKey) {
            urlRow.insertCell().textContent = row[descKeys[k]];
            break;
          }
        }
        if (urlRow.cells.length === j) {
          // If no data found for the column then insert an empty cell
          urlRow.insertCell();
        }
      }
    }
  };

  const file = fileInput.files[0];
  reader.readAsText(file);
}

// Function to display the file name when selected
function displayFileName() {
  const fileInput = document.getElementById("jsonFile");
  const fileNameDisplay = document.getElementById("fileName");
  if (fileInput.files.length > 0) {
    fileNameDisplay.textContent = fileInput.files[0].name;
  } else {
    fileNameDisplay.textContent = "";
  }
}

// Function to deselect the the file
function clearFile() {
  const fileInput = document.getElementById("jsonFile");
  fileInput.value = "";
  displayFileName();
}


//Function to clear the table
function clearTable() {
  const table = document.getElementById("dataTable");
  if (table.rows.length > 1) {
    while (table.rows.length > 1) {
      table.deleteRow(1);
    }
  }
}
