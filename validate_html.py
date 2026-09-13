from html.parser import HTMLParser
import sys

class HTMLValidator(HTMLParser):
    def __init__(self):
        super().__init__()
        self.stack = []
        self.errors = []
        self.line = 1
        self.col = 0
    
    def handle_starttag(self, tag, attrs):
        # 忽略自闭合标签
        if tag not in ['br', 'hr', 'img', 'input', 'meta', 'link', 'source']:
            self.stack.append(tag)
    
    def handle_endtag(self, tag):
        if not self.stack:
            self.errors.append(f"Line {self.line}: Found closing tag </{tag}> without matching opening tag")
            return
        
        last_tag = self.stack.pop()
        if last_tag != tag:
            self.errors.append(f"Line {self.line}: Mismatched tags: expected </{last_tag}>, got </{tag}>")
    
    def error(self, message):
        self.errors.append(f"Line {self.line}: {message}")
    
    def feed(self, data):
        for char in data:
            if char == '\n':
                self.line += 1
                self.col = 0
            else:
                self.col += 1
            super().feed(char)
    
    def validate(self):
        if self.stack:
            for tag in self.stack:
                self.errors.append(f"Line {self.line}: Found opening tag <{tag}> without matching closing tag")
        
        return self.errors

# 读取HTML文件
if len(sys.argv) < 2:
    print("Usage: python validate_html.py <html_file>")
    sys.exit(1)

file_path = sys.argv[1]
try:
    with open(file_path, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    # 创建验证器并验证
    validator = HTMLValidator()
    validator.feed(html_content)
    errors = validator.validate()
    
    if errors:
        print("HTML validation errors found:")
        for error in errors:
            print(f"  {error}")
        sys.exit(1)
    else:
        print("HTML validation successful! No errors found.")
        sys.exit(0)
        
except FileNotFoundError:
    print(f"Error: File '{file_path}' not found.")
    sys.exit(1)
except Exception as e:
    print(f"Error reading file: {e}")
    sys.exit(1)