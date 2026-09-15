#!/bin/bash
# 中国Tokens出海课程内容完善工具
# 为各个页面添加详细的技术和商业内容

echo "=== 中国Tokens出海课程内容完善工具 ==="

# 1. 完善 key-management.html - API密钥管理系统
cat > key-management-detailed.html << 'EOF'
<div class="section">
    <h2 class="section-title">API密钥管理系统设计</h2>
    
    <h3>核心功能模块</h3>
    <div class="advantage-list">
        <div class="advantage-item">
            <div class="advantage-title">🔑 密钥生成与管理</div>
            <p>自动生成唯一API密钥，支持前缀标识、有效期设置、权限控制</p>
        </div>
        <div class="advantage-item">
            <div class="advantage-title">💳 计费与额度控制</div>
            <p>实时Token计数，设置使用额度，支持按天/月/年计费模式</p>
        </div>
        <div class="advantage-item">
            <div class="advantage-title">📊 使用统计与分析</div>
            <p>详细的使用日志、流量监控、异常检测、使用报告</p>
        </div>
        <div class="advantage-item">
            <div class="advantage-title">🔒 安全与审计</div>
            <p>密钥轮换、访问控制、操作审计、安全告警</p>
        </div>
    </div>
</div>

<div class="section">
    <h2 class="section-title">数据库设计示例</h2>
    
    <h3>API密钥表结构</h3>
    <pre style="background: #f8f9fa; padding: 15px; border-radius: 8px; overflow-x: auto;">
CREATE TABLE api_keys (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    api_key VARCHAR(64) UNIQUE NOT NULL,
    api_secret VARCHAR(128) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    rate_limit_per_minute INTEGER DEFAULT 60,
    rate_limit_per_day INTEGER DEFAULT 10000,
    total_tokens_used BIGINT DEFAULT 0,
    max_tokens_per_month BIGINT DEFAULT 1000000,
    created_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP,
    last_used_at TIMESTAMP
);

CREATE INDEX idx_api_keys_user_id ON api_keys(user_id);
CREATE INDEX idx_api_keys_key ON api_keys(api_key);
    </pre>
    
    <h3>使用记录表</h3>
    <pre style="background: #f8f9fa; padding: 15px; border-radius: 8px; overflow-x: auto;">
CREATE TABLE api_usage_logs (
    id SERIAL PRIMARY KEY,
    api_key_id INTEGER REFERENCES api_keys(id),
    endpoint VARCHAR(200) NOT NULL,
    model_used VARCHAR(100) NOT NULL,
    prompt_tokens INTEGER NOT NULL,
    completion_tokens INTEGER NOT NULL,
    total_tokens INTEGER NOT NULL,
    cost_usd DECIMAL(10,6) NOT NULL,
    response_time_ms INTEGER NOT NULL,
    status_code INTEGER NOT NULL,
    user_agent TEXT,
    ip_address INET,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_usage_logs_api_key ON api_usage_logs(api_key_id, created_at);
CREATE INDEX idx_usage_logs_created ON api_usage_logs(created_at);
    </pre>
</div>
EOF

echo "✓ 密钥管理页面详细内容已生成"

# 2. 完善 global-payment.html - 全球支付解决方案
cat > global-payment-detailed.html << 'EOF'
<div class="section">
    <h2 class="section-title">全球支付渠道整合策略</h2>
    
    <h3>支付渠道选择标准</h3>
    <table style="width: 100%; border-collapse: collapse; margin: 20px 0;" border="1">
        <thead>
            <tr style="background: #f8f9fa;">
                <th style="padding: 12px; text-align: left;">支付渠道</th>
                <th style="padding: 12px; text-align: left;">覆盖地区</th>
                <th style="padding: 12px; text-align: left;">手续费</th>
                <th style="padding: 12px; text-align: left;">结算周期</th>
                <th style="padding: 12px; text-align: left;">适用场景</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td style="padding: 12px;"><strong>Stripe</strong></td>
                <td style="padding: 12px;">全球主流国家</td>
                <td style="padding: 12px;">2.9% + $0.30</td>
                <td style="padding: 12px;">2-7天</td>
                <td style="padding: 12px;">企业客户、信用卡支付</td>
            </tr>
            <tr>
                <td style="padding: 12px;"><strong>PayPal</strong></td>
                <td style="padding: 12px;">全球200+国家</td>
                <td style="padding: 12px;">3.4% + $0.30</td>
                <td style="padding: 12px;">即时到账</td>
                <td style="padding: 12px;">个人用户、小额支付</td>
            </tr>
            <tr>
                <td style="padding: 12px;"><strong>加密货币</strong></td>
                <td style="padding: 12px;">全球无限制</td>
                <td style="padding: 12px;">0.5-1%</td>
                <td style="padding: 12px;">即时确认</td>
                <td style="padding: 12px;">技术用户、匿名支付</td>
            </tr>
            <tr>
                <td style="padding: 12px;"><strong>银行转账</strong></td>
                <td style="padding: 12px;">特定国家</td>
                <td style="padding: 12px;">$10-30/笔</td>
                <td style="padding: 12px;">3-5工作日</td>
                <td style="padding: 12px;">大额支付、企业客户</td>
            </tr>
        </tbody>
    </table>
</div>

<div class="section">
    <h2 class="section-title">支付集成技术方案</h2>
    
    <h3>多支付网关架构</h3>
    <pre style="background: #f8f9fa; padding: 15px; border-radius: 8px; overflow-x: auto;">
// payment_gateway.js - 支付网关抽象层
export class PaymentGateway {
    constructor(config) {
        this.gateways = {
            stripe: new StripeGateway(config.stripe),
            paypal: new PayPalGateway(config.paypal),
            crypto: new CryptoGateway(config.crypto)
        };
    }
    
    async createPayment(order) {
        // 根据用户地区自动选择最优支付方式
        const gateway = this.selectBestGateway(order.userCountry);
        return await gateway.createPayment(order);
    }
    
    selectBestGateway(country) {
        const gatewayPreferences = {
            'US': 'stripe',
            'EU': 'stripe', 
            'CN': 'alipay',
            'global': 'paypal'
        };
        
        return this.gateways[gatewayPreferences[country] || 'paypal'];
    }
}

// Stripe集成示例
export class StripeGateway {
    async createPayment(order) {
        const session = await stripe.checkout.sessions.create({
            payment_method_types: ['card'],
            line_items: [{
                price_data: {
                    currency: 'usd',
                    product_data: { name: order.description },
                    unit_amount: order.amount * 100, // 转换为分
                },
                quantity: 1,
            }],
            mode: 'payment',
            success_url: `${process.env.BASE_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
            cancel_url: `${process.env.BASE_URL}/cancel`,
        });
        
        return { paymentUrl: session.url, paymentId: session.id };
    }
}
    </pre>
</div>
EOF

echo "✓ 全球支付页面详细内容已生成"

# 3. 完善 deepseek-advantages.html - DeepSeek模型优势
cat > deepseek-advantages-detailed.html << 'EOF'
<div class="section">
    <h2 class="section-title">DeepSeek模型技术优势深度解析</h2>
    
    <div style="background: linear-gradient(135deg, #4ECDC4 0%, #2C3E50 100%); color: white; padding: 30px; border-radius: 15px; margin: 20px 0;">
        <h3 style="color: white;">🎯 核心技术创新</h3>
        <ul style="color: white;">
            <li><strong>MoE混合专家架构</strong> - 万亿参数规模，智能路由到最合适的专家网络</li>
            <li><strong>高效推理优化</strong> - 推理速度比GPT-4快3倍，成本降低10倍</li>
            <li><strong>长文本处理</strong> - 支持128K上下文，行业领先的文本理解能力</li>
            <li><strong>多模态扩展</strong> - 原生支持图像理解，无需额外转换</li>
        </ul>
    </div>
</div>

<div class="section">
    <h2 class="section-title">性能基准测试对比</h2>
    
    <table style="width: 100%; border-collapse: collapse; margin: 20px 0;" border="1">
        <thead>
            <tr style="background: #f8f9fa;">
                <th style="padding: 12px; text-align: left;">测试项目</th>
                <th style="padding: 12px; text-align: left;">DeepSeek-V3</th>
                <th style="padding: 12px; text-align: left;">GPT-4</th>
                <th style="padding: 12px; text-align: left;">Claude-3</th>
                <th style="padding: 12px; text-align: left;">性能优势</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td style="padding: 12px;"><strong>MMLU综合能力</strong></td>
                <td style="padding: 12px;">86.5%</td>
                <td style="padding: 12px;">86.4%</td>
                <td style="padding: 12px;">85.2%</td>
                <td style="padding: 12px; color: #48bb78;">领先0.1%</td>
            </tr>
            <tr>
                <td style="padding: 12px;"><strong>数学推理GSM8K</strong></td>
                <td style="padding: 12px;">94.5%</td>
                <td style="padding: 12px;">92.0%</td>
                <td style="padding: 12px;">91.2%</td>
                <td style="padding: 12px; color: #48bb78;">领先2.5%</td>
            </tr>
            <tr>
                <td style="padding: 12px;"><strong>代码生成HumanEval</strong></td>
                <td style="padding: 12px;">80.1%</td>
                <td style="padding: 12px;">67.0%</td>
                <td style="padding: 12px;">71.3%</td>
                <td style="padding: 12px; color: #48bb78;">领先13.1%</td>
            </tr>
            <tr>
                <td style="padding: 12px;"><strong>响应速度(tokens/秒)</strong></td>
                <td style="padding: 12px;">1250</td>
                <td style="padding: 12px;">400</td>
                <td style="padding: 12px;">350</td>
                <td style="padding: 12px; color: #48bb78;">3倍速度</td>
            </tr>
            <tr>
                <td style="padding: 12px;"><strong>价格($/百万token)</strong></td>
                <td style="padding: 12px;">$0.14</td>
                <td style="padding: 12px;">$5.00</td>
                <td style="padding: 12px;">$15.00</td>
                <td style="padding: 12px; color: #48bb78;">35倍性价比</td>
            </tr>
        </tbody>
    </table>
</div>

<div class="section">
    <h2 class="section-title">DeepSeek API使用最佳实践</h2>
    
    <h3>请求优化技巧</h3>
    <pre style="background: #f8f9fa; padding: 15px; border-radius: 8px; overflow-x: auto;">
# 最佳实践：流式响应处理
import requests
import json

def stream_chat_completion(messages, model="deepseek-chat"):
    url = "https://api.deepseek.com/v1/chat/completions"
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json"
    }
    
    data = {
        "model": model,
        "messages": messages,
        "stream": True,  # 启用流式响应
        "temperature": 0.7,
        "max_tokens": 2048
    }
    
    response = requests.post(url, headers=headers, json=data, stream=True)
    
    full_response = ""
    for line in response.iter_lines():
        if line:
            line = line.decode('utf-8')
            if line.startswith('data: '):
                data_str = line[6:]  # 移除'data: '前缀
                if data_str == '[DONE]':
                    break
                try:
                    chunk = json.loads(data_str)
                    if 'choices' in chunk and chunk['choices']:
                        delta = chunk['choices'][0].get('delta', {})
                        if 'content' in delta:
                            content = delta['content']
                            full_response += content
                            print(content, end='', flush=True)  # 实时显示
                except json.JSONDecodeError:
                    continue
    
    return full_response

# 使用示例
messages = [
    {"role": "system", "content": "你是一个有帮助的AI助手"},
    {"role": "user", "content": "请解释什么是机器学习"}
]

result = stream_chat_completion(messages)
    </pre>
    
    <h3>错误处理与重试机制</h3>
    <pre style="background: #f8f9fa; padding: 15px; border-radius: 8px; overflow-x: auto;">
async def robust_api_call(messages, max_retries=3):
    """带重试机制的API调用"""
    for attempt in range(max_retries):
        try:
            response = await deepseek_chat_completion(messages)
            return response
        except Exception as e:
            if attempt == max_retries - 1:
                raise e  # 最后一次尝试仍失败则抛出异常
            
            # 根据错误类型决定等待时间
            wait_time = 2 ** attempt  # 指数退避
            if 'rate limit' in str(e).lower():
                wait_time = min(wait_time * 2, 60)  # 限流错误等待更久
            
            print(f"第{attempt + 1}次尝试失败，{wait_time}秒后重试: {e}")
            await asyncio.sleep(wait_time)
    </pre>
</div>
EOF

echo "✓ DeepSeek优势页面详细内容已生成"

echo ""
echo "=== 内容完善完成 ==="
echo "详细内容文件已生成："
echo "- key-management-detailed.html"
echo "- global-payment-detailed.html" 
echo "- deepseek-advantages-detailed.html"
echo ""
echo "使用方法："
echo "1. 手动将内容追加到相应HTML文件中"
echo "2. 或者使用patch工具批量插入"
echo "3. 确保内容的逻辑连贯性和格式一致性"