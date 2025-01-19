# Load required packages
library(rvest)
library(httr)

# Get folders structure
url_ftp <- "https://ftp.ibge.gov.br/Precos_Indices_de_Precos_ao_Consumidor/IPCA/Resultados_por_Subitem/"

ftp_content <- GET(url_ftp) |> 
  content(as = "text") |>
  read_html() |>
  html_nodes("a") |>
  html_attr("href") |>
  (\(x) x[grepl("^[^http].*/$|\\.zip$", x)][-1])()

# Download files outside any folder
current_year <- ftp_content |>
  (\(x) sub(".*_(\\d{4}).*", "\\1", x[grepl("\\.zip$", x)][-1]))() |>
  unique()

# Check all available years and download zip
years <- c(gsub("/", "", ftp_content[grepl("^.*/$", ftp_content)]), current_year)

for (year in years) {
  # Create folder for the year if it doesn't exist
  dir_name <- paste0("Data/", as.character(year))
  if (!dir.exists(dir_name)) {
    dir.create(dir_name)
  }
  
  # Get list of files for the current year
  dir_url <- if (year == current_year) {
    url_ftp
  } else {
    paste0(url_ftp, year, "/")
  }
  
  file_links <- GET(dir_url) |> 
    content(as = "text") |> 
    read_html() |> 
    html_nodes("a") |> 
    html_attr("href") |>
    (\(x) x[grepl("\\.zip$", x)])()
  
  # Download each file
  for (file in file_links) {
    file_url <- if (year == current_year) {
      paste0(url_ftp, file)
    } else {
      paste0(url_ftp, year, "/", file)
    }
    
    dest_path <- file.path(dir_name, file)
    
    # Download the file
    download.file(
      url = file_url,
      destfile = dest_path,
      mode = "wb"
    )
  }
}

# Unzip files
year_folders <- dir("Data", full.names = TRUE)

for (year_folder in year_folders) {
  if (dir.exists(year_folder)) {
    zip_files <- dir(year_folder, pattern = "\\.zip$", full.names = TRUE)
    for (zip_file in zip_files) {
      unzip(zip_file, exdir = year_folder)
      file.remove(zip_file)
    }
  }
}
