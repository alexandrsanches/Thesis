import os
import re
import requests
from bs4 import BeautifulSoup
from zipfile import ZipFile

# URL of the FTP server
url_ftp = "https://ftp.ibge.gov.br/Precos_Indices_de_Precos_ao_Consumidor/IPCA/Resultados_por_Subitem/"

# Fetch the folder structure from the FTP server
response = requests.get(url_ftp)
soup = BeautifulSoup(response.text, "html.parser")

# Extract folder and file links
ftp_content = [
    link.get("href") for link in soup.find_all("a")
    if re.match(r"^[^http].*/$|\.zip$", link.get("href"))
]

# Filter to get available years
years = [re.sub(r"/$", "", link) for link in ftp_content if re.match(r"^.*/$", link)]

# Process each year
for year in years:
    # Create a directory for the year if it doesn't exist
    dir_name = os.path.join("Dados", year)
    os.makedirs(dir_name, exist_ok=True)

    # Get the list of files for the current year
    dir_url = f"{url_ftp}{year}/"
    response = requests.get(dir_url)
    soup = BeautifulSoup(response.text, "html.parser")
    file_links = [
        link.get("href") for link in soup.find_all("a")
        if link.get("href").endswith(".zip")
    ]

    # Download each file
    for file in file_links:
        file_url = f"{dir_url}{file}"
        dest_path = os.path.join(dir_name, file)
        with requests.get(file_url, stream=True) as r:
            with open(dest_path, "wb") as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)

# Unzip files and remove zip files
for root, dirs, files in os.walk("Dados"):
    for file in files:
        if file.endswith(".zip"):
            zip_path = os.path.join(root, file)
            with ZipFile(zip_path, "r") as zip_ref:
                zip_ref.extractall(root)
            os.remove(zip_path)
