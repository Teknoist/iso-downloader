import os
import re
import xml.etree.ElementTree as ET
import urllib.request

# 1. Komut satırı argümanlarını okuyun
import argparse
parser = argparse.ArgumentParser()
parser.add_argument('-d', '--distro', required=True)
args = parser.parse_args()

# 2. repo.xml dosyasını indirin ve ağaç yapısına dönüştürün
url = 'https://raw.githubusercontent.com/Teknoist/iso-downloader/main/repo.xml'
xml_data = urllib.request.urlopen(url).read()
root = ET.fromstring(xml_data)

# 3. Belirtilen dağıtımlar için güncel sürümleri indirin
distros = args.distro.split(',')
for distro in distros:
    file_name = f'{distro}.iso'
    package = root.find(f"package[name='{file_name}']")
    if package is not None:
        version = package.find('version').text
        download_url = package.find('download_url').text
        file_path = f'./download/{file_name}'
        urllib.request.urlretrieve(download_url, file_path)
        print(f'{file_name} version {version} has been downloaded.')
    else:
        print(f'{file_name} not found in the repository.')
