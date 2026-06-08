import re
import os

files = ['lib/modules/home/widgets/category_content_widgets.dart', 'lib/modules/home/widgets/product_grid_widget.dart']
images = set()

for f in files:
    with open(f, 'r', encoding='utf-8') as file:
        content = file.read()
        matches = re.findall(r'image:\s*"([^"]+)"', content)
        for m in matches:
            if m.startswith('assets/images/products/'):
                images.add(m)

print('Total images:', len(images))
for img in list(images):
    print(img)
