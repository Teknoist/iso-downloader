import os
import re
import xml.etree.ElementTree as ET
import urllib.request

# 1. repo.xml dosyasını indirin ve ağaç yapısına dönüştürün
url = 'https://github.com/Teknoist/iso-downloader/blob/main/repo.xml'
xml_data = urllib.request.urlopen(url).read()
root = ET.fromstring(xml_data)

# 2. ISO dosyalarını bulun ve güncel sürümlerini indirin
iso_files = [f for f in os.listdir('./Medicat') if re.match(r'.*\.iso$', f)]
download_urls = {}
for iso_file in iso_files:
    # 3. ISO dosyasının sürüm numarasını bulun
    file_path = f'./Medicat/{iso_file}'
    version = os.path.splitext(iso_file)[0].split('-')[-1]
    
    # 4. repo.xml dosyasındaki verideki version öğesiyle karşılaştırın
    package = root.find(f"package[name='{iso_file}']")
    if package is not None:
        latest_version = package.find('version').text
        if version < latest_version:
            # 5. Eğer güncel sürüm varsa, indirin
            download_url = package.find('download_url').text
            urllib.request.urlretrieve(download_url, file_path)
            download_urls[iso_file] = download_url

# 6. İşlem tamamlandıktan sonra, indirilen ISO dosyalarının listesi
print(f'Updated ISO files: {download_urls.keys()}')
