import re
import os

def to_snake_case(name):
    return name.lower().replace(' ', '_').replace('-', '_')

def process_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    def replace_match(m):
        name = m.group(1)
        snake_name = to_snake_case(name)
        # return the same string but with image updated
        return f'ProductModel(name: "{name}",{m.group(2)}image: "assets/images/products/{snake_name}.png"'

    # Regex to match ProductModel creation
    pattern = r'ProductModel\(name:\s*"([^"]+)",(.*?)image:\s*"[^"]+"'
    new_content = re.sub(pattern, replace_match, content, flags=re.DOTALL)
    
    if new_content != content:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {path}")

files = [
    r'd:\kartly_e_commerce_v4\lib\modules\home\widgets\category_content_widgets.dart',
    r'd:\kartly_e_commerce_v4\lib\modules\home\widgets\product_grid_widget.dart',
    r'd:\kartly_e_commerce_v4\lib\modules\home\widgets\sub_category_widget.dart'
]

for f in files:
    if os.path.exists(f):
        process_file(f)
