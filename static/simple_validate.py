# 简单的HTML标签匹配验证器
html_file = "payment/self recharge.html"

try:
    with open(html_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 移除HTML注释，避免影响标签匹配
    import re
    content = re.sub(r'<!--.*?-->', '', content, flags=re.DOTALL)
    
    # 提取所有标签
    tags = re.findall(r'<(/?[a-zA-Z][a-zA-Z0-9]*?)\b', content)
    
    # 验证标签匹配
    stack = []
    errors = []
    for i, tag in enumerate(tags):
        if tag.startswith('/'):
            # 闭合标签
            closing_tag = tag[1:]
            if not stack:
                errors.append(f"错误: 找到闭合标签 </{closing_tag}>，但没有匹配的开始标签")
            else:
                last_tag = stack.pop()
                if last_tag != closing_tag:
                    errors.append(f"错误: 标签不匹配 - 预期 </{last_tag}>，但找到 </{closing_tag}>")
        else:
            # 开始标签，跳过自闭合标签
            if tag not in ['br', 'hr', 'img', 'input', 'meta', 'link', 'source']:
                stack.append(tag)
    
    # 检查是否有未闭合的标签
    for tag in stack:
        errors.append(f"错误: 找到开始标签 <{tag}>，但没有匹配的闭合标签")
    
    # 输出结果
    if errors:
        print("HTML标签匹配错误:")
        for error in errors:
            print(f"  {error}")
    else:
        print("HTML标签匹配检查通过！所有标签都正确闭合。")
        
except Exception as e:
    print(f"验证过程中出错: {e}")