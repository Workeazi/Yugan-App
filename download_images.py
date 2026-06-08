import os
import re
import urllib.request
import ssl

ssl._create_default_https_context = ssl._create_unverified_context

images = set()
files = ['lib/modules/home/widgets/category_content_widgets.dart', 'lib/modules/home/widgets/product_grid_widget.dart']

for f in files:
    with open(f, 'r', encoding='utf-8') as file:
        content = file.read()
        matches = re.findall(r'image:\s*"([^"]+)"', content)
        for m in matches:
            if m.startswith('assets/images/products/'):
                images.add(m)

os.makedirs('assets/images/products', exist_ok=True)

for img in images:
    if os.path.exists(img):
        continue
    
    filename = os.path.basename(img)
    name_without_ext = os.path.splitext(filename)[0]
    
    # Handle interpolated dynamic variables like premium_${categoryName.toLowerCase()}_1
    if '${' in name_without_ext:
        name_without_ext = name_without_ext.replace('${categoryName.toLowerCase()}', 'all')
        img = img.replace('${categoryName.toLowerCase()}', 'all')
        if os.path.exists(img):
            continue

    words = name_without_ext.replace('_', ' ').split()
    # Filter out common filler words and numbers
    meaningful_words = [w for w in words if w not in ('premium', 'essential', 'luxury', '1', '2', '3')]
    keyword = meaningful_words[-1] if meaningful_words else 'product'
    
    # Sometimes keyword might be generic, let's use the last two words if possible
    if len(meaningful_words) >= 2:
        search_query = f"{meaningful_words[-2]},{meaningful_words[-1]}"
    else:
        search_query = keyword
        
    url = f"https://loremflickr.com/400/400/{search_query},product"
    
    try:
        urllib.request.urlretrieve(url, img)
        print(f"Downloaded {img} using keyword: {search_query}")
    except Exception as e:
        print(f"Failed to download {img}: {e}")
