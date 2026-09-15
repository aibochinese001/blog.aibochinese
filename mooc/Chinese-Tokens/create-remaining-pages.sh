#!/bin/bash
# 中国Tokens出海课程 - 批量创建剩余页面脚本
# 使用方法: ./create-remaining-pages.sh

echo "开始创建剩余课程页面..."

# 定义页面配置模板
page_template='<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{title}} - 中国Tokens出海 - 爱博·客</title>
    <meta name="description" content="{{description}}">
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .course-container {{
            max-width: 1200px;
            margin: 0 auto;
            padding: 100px 20px 50px;
        }}
        
        .course-header {{
            text-align: center;
            margin-bottom: 40px;
        }}
        
        .course-title {{
            font-size: 2.5rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 20px;
        }}
        
        .lesson-nav {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }}
        
        .nav-btn {{
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 20px;
            background: white;
            border: 2px solid #667eea;
            border-radius: 25px;
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }}
        
        .nav-btn:hover {{
            background: #667eea;
            color: white;
        }}
        
        .lesson-content {{
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            line-height: 1.8;
        }}
        
        .section {{
            margin-bottom: 40px;
        }}
        
        .section-title {{
            font-size: 1.8rem;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 20px;
            border-left: 5px solid #667eea;
            padding-left: 20px;
        }}
        
        @media (max-width: 768px) {{
            .course-title {{
                font-size: 2rem;
            }}
            
            .lesson-content {{
                padding: 20px;
            }}
        }}
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="logo">
                <a href="/"><img src="https://cf.aibochinese.com/%E7%88%B1%E5%8D%9A%C2%B7%E5%AE%A2%E5%9B%BE%E7%89%87%E5%BA%93/logo.png" alt="爱博·客"></a>
            </div>
            <ul class="nav-menu">
                <li><a href="/index.html" class="nav-link">首页</a></li>
                <li><a href="../mooc.html" class="nav-link">公开课</a></li>
                <li><a href="dashboard.html" class="nav-link">课程导航</a></li>
            </ul>
            <div class="hamburger">
                <span class="bar"></span>
                <span class="bar"></span>
                <span class="bar"></span>
            </div>
        </div>
    </nav>

    <div class="course-container">
        <div class="course-header">
            <h1 class="course-title">{{title}}</h1>
            <p>{{subtitle}}</p>
        </div>

        <div class="lesson-nav">
            <a href="{{prev_page}}" class="nav-btn">
                <i class="fas fa-arrow-left"></i> {{prev_text}}
            </a>
            <a href="{{next_page}}" class="nav-btn">
                {{next_text}} <i class="fas fa-arrow-right"></i>
            </a>
        </div>

        <div class="lesson-content">
            {{content}}
            
            <div class="lesson-nav" style="margin-top: 40px;">
                <a href="{{prev_page}}" class="nav-btn">
                    <i class="fas fa-arrow-left"></i> {{prev_text}}
                </a>
                <a href="{{next_page}}" class="nav-btn">
                    {{next_text}} <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </div>

    <!-- 导航菜单脚本 -->
    <script>
        const hamburger = document.querySelector(".hamburger");
        const navMenu = document.querySelector(".nav-menu");

        hamburger.addEventListener("click", () => {{
            hamburger.classList.toggle("active");
            navMenu.classList.toggle("active");
        }});
    </script>
</body>
</html>'

# 剩余页面配置
pages_config=(
    "docker-deployment.html,Docker容器化部署,使用Docker快速部署API中转服务,性能-optimization.html,上一课：性能优化,api-design.html,下一课：API设计"
    "api-design.html,API适配层设计与实现,构建兼容OpenAI格式的API转发层,bt-panel.html,上一课：宝塔面板,key-management.html,下一课：密钥管理"
    "key-management.html,API Key管理与计费系统,实现用户鉴权和计费功能,api-design.html,上一课：API设计,performance-optimization.html,下一课：性能优化"
    "performance-optimization.html,性能优化与高可用架构,确保服务稳定性和响应速度,key-management.html,上一课：密钥管理,global-payment.html,下一课：全球支付"
    "global-payment.html,全球支付渠道整合方案,解决海外收款和支付难题,performance-optimization.html,上一课：性能优化,payone-setup.html,下一课：Payone配置"
    "payone-setup.html,Payone收款账户配置,开通境外银行和支付账户,global-payment.html,上一课：全球支付,risk-management.html,下一课：风控管理"
    "risk-management.html,风控管理与合规策略,防范支付风险确保合规运营,payone-setup.html,上一课：Payone配置,website-optimization.html,下一课：网站优化"
    "website-optimization.html,网站性能与SEO优化,提升网站加载速度和搜索引擎排名,risk-management.html,上一课：风控管理,user-experience.html,下一课：用户体验"
    "user-experience.html,用户体验设计与最佳实践,优化界面和操作流程,website-optimization.html,上一课：网站优化,brand-building.html,下一课：品牌建设"
    "brand-building.html,品牌建设与专业形象打造,建立可信赖的服务品牌,user-experience.html,上一课：用户体验,deepseek-advantages.html,下一课：DeepSeek优势"
    "deepseek-advantages.html,DeepSeek模型核心优势,深度分析DeepSeek的技术特点,brand-building.html,上一课：品牌建设,model-comparison.html,下一课：模型对比"
    "model-comparison.html,主流AI模型对比分析,综合比较各家AI模型的优劣势,deepseek-advantages.html,上一课：DeepSeek优势,service-portfolio.html,下一课：服务组合"
    "service-portfolio.html,服务组合与定价策略,设计多层次的服务套餐,model-comparison.html,上一课：模型对比,social-media.html,下一课：社交媒体营销"
    "social-media.html,自媒体与社交媒体营销,利用社交媒体推广服务,service-portfolio.html,上一课：服务组合,content-marketing.html,下一课：内容营销"
    "content-marketing.html,内容营销与SEO策略,通过内容创作吸引客户,social-media.html,上一课：社交媒体营销,partnership.html,下一课：渠道合作"
    "partnership.html,渠道合作与生态建设,建立合作伙伴关系扩大影响力,content-marketing.html,上一课：内容营销,case-study.html,下一课：案例分析"
    "case-study.html,成功案例分析,学习优秀项目的实践经验,partnership.html,上一课：渠道合作,troubleshooting.html,下一课：问题排查"
    "troubleshooting.html,常见问题排查与解决,快速定位和解决运营问题,case-study.html,上一课：案例分析,next-steps.html,下一课：未来规划"
    "next-steps.html,下一步发展规划,制定业务扩张和发展策略,troubleshooting.html,上一课：问题排查,dashboard.html,返回课程导航"
)

# 创建页面的函数
create_page() {
    local filename="$1"
    local title="$2"
    local description="$3"
    local prev_page="$4"
    local prev_text="$5"
    local next_page="$6"
    local next_text="$7"
    
    echo "创建页面: $filename"
    
    # 默认内容模板
    local content="<div class=\"section\">
            <h2 class=\"section-title\">$title</h2>
            <p>本课程内容正在进一步完善中，敬请期待...</p>
            <p>在正式内容发布前，您可以通过课程导航页面查看其他已发布的课程。</p>
        </div>"
    
    # 替换模板变量
    local page_content="${page_template//\{\{title\}\}/$title}"
    page_content="${page_content//\{\{description\}\}/$description}"
    page_content="${page_content//\{\{subtitle\}\}/$description}"
    page_content="${page_content//\{\{prev_page\}\}/$prev_page}"
    page_content="${page_content//\{\{prev_text\}\}/$prev_text}"
    page_content="${page_content//\{\{next_page\}\}/$next_page}"
    page_content="${page_content//\{\{next_text\}\}/$next_text}"
    page_content="${page_content//\{\{content\}\}/$content}"
    
    # 写入文件
    echo "$page_content" > "$filename"
}

# 批量创建页面
for config in "${pages_config[@]}"; do
    IFS=',' read -r -a params <<< "$config"
    create_page "${params[0]}" "${params[1]}" "${params[2]}" "${params[3]}" "${params[4]}" "${params[5]}" "${params[6]}"
done

echo "所有页面创建完成！"
echo "共计创建了 ${#pages_config[@]} 个课程页面"
echo "访问地址: https://blog.aibochinese.com/mooc/Chinese-Tokens/dashboard.html"