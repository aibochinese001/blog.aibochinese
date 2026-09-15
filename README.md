# AI Bo Chinese Blog

[![Language](https://img.shields.io/badge/language-HTML%2099%25-orange.svg)](https://github.com/aibochinese001/blog.aibochinese)

爱博·客（blog.aibochinese.com）的静态站点源码。围绕**中文内容分享**与**KOL 知识输出**，
收录网站搭建、跨境收付、自媒体运营、公开课、实用工具等主题的静态 HTML 页面。

- **线上站点**：https://blog.aibochinese.com
- **仓库**：https://github.com/aibochinese001/blog.aibochinese

## 目录结构

| 路径 | 说明 | 页面数 |
| --- | --- | --- |
| `index.html` | 站点首页 | 1 |
| `post/` | 文章主体（含 Pagefind 搜索索引 `post/pagefind/`） | 73 |
| `mooc/` | 公开课（Chinese-Tokens / hermes / photoshop / quant-trading / site-architecture） | 79 |
| `payment/` | 跨境支付与境外账户教程 | 25 |
| `tools/` | 实用工具与优惠 vpn/eSIM 等 | 20 |
| `buildsites/` | 建站与部署教程 | 14 |
| `SMC/` | 自媒体矩阵运营 | 10 |
| `conmon_funcation_code/` | **可复用 HTML 片段**（导航、悬浮客服、底部按钮等），非独立页面 | 10 |
| `web3/` | Web3 / 交易所相关 | 6 |
| `appstore/` | 应用推荐页 | 4 |
| `Rescous/`、`education/` | 教学资源 | 4 |
| `css/` | 站点共享基础样式 | — |
| `uploads/` | 站点配图 | — |
| `redirects/` | 301 重定向规则与站点体检脚本（非页面，不参与站点地图） | — |

> 各板块目录（如 `mooc/css/`、`payment/css/`）下的 `style.css` 统一 `@import` 根目录下的
> `css/style.css`，便于集中维护主题变量。

## 文件命名约定

为保证托管与抓取的可靠性，仓库统一遵循：

- 文件名只用**小写英文字母、数字、下划线 `_` 和连字符 `-`**；
- **不使用空格**（避免 URL 出现 `%20`）、中文文件名或 `()[]{}` 等特殊字符；
- 页面后缀统一为 `.html`，站内导航链接不得省略扩展名。

## 本地预览

推荐用本地静态服务器，避免 `file://` 协议下相对路径异常：

```bash
python -m http.server 8000
# 浏览器访问 http://localhost:8000
```

## SEO 与站点地图

- `sitemap.xml` / `sitemap.html`：同源 XML 站点地图，覆盖 242 个有效页面，
  已排除 `404.html` 与 `conmon_funcation_code/` 下的 HTML 片段。
- `robots.txt`：允许全站抓取并声明站点地图位置。
- `BingSiteAuth.xml`：必应站长验证文件。
- 每个页面均包含 `charset`、`viewport`、`lang`、`title`、`description`；
  其中 `<meta charset>` **必须位于 `<head>` 首位**（浏览器仅嗅探前 1024 字节）。

### 重复页面与 canonical

`post/` 下的部分页面是各板块页面的历史副本（内容几乎相同）。为避免重复内容分散权重，
已为 **43 个副本页**添加 `<link rel="canonical">`，指向其权威版本：

- 权威版本的判定规则：首页 > 站内入链数多者 > 板块目录（如 `payment/`、`tools/`）优于 `post/` > 正文更丰富者。
- 判定依据为「标题一致 **且** 正文相似度 ≥ 80%」，仅文件名相同但内容不同的页面
  （如 `mooc/photoshop/chapter2.html` 与 `mooc/site-architecture/chapter2.html`）不会被误判。
- 副本页**仍保留**在站点地图中，以便搜索引擎抓取并读取 canonical 信号。

需要重新生成或校验时运行 `redirects/apply_canonical.py`（默认 dry-run，加 `--apply` 才写入）。

## 旧 URL 重定向（301）

规范化重命名后，旧的含空格 / 中文文件名 URL 已失效。为保住外部链接与搜索权重，
`redirects/` 下提供了各托管环境的 301 规则：

| 文件 | 适用场景 |
| --- | --- |
| `_redirects`（站点根目录） | **Cloudflare Pages**，已就位，部署后自动生效 |
| `redirects/cloudflare-worker.js` | Cloudflare Workers / Snippets，返回真正的 301 |
| `redirects/nginx-redirects.conf` | Nginx，需放入 `server {}` 块 |
| `redirects/htaccess-redirects.conf` | Apache，复制规则到 `.htaccess` |
| `redirects/redirect-map.md` | 42 条新旧路径对照表（人工核对用） |

规则同时覆盖空格原样与 `%20` 编码两种形式，并含 `conmon funcation code/` →
`conmon_funcation_code/` 的目录级跳转。重新生成：`python redirects/build_redirects.py`。

## 站点自检

```bash
python redirects/verify_site.py   # HTML 结构 + 内部链接 + canonical 格式校验
```

最近一次自检结果：254 个页面标签结构全部闭合，471 条内部链接 0 断链。

## 已知待办

- `mooc/site-architecture/uploads/` 下有两张未被任何页面引用的配图。
- 重复副本页目前仅用 canonical 声明权威版本，若后续确认无外部入链，可直接删除副本。

## 许可证

本仓库尚未指定开源许可证，默认保留所有权利。如需开放授权，请补充 `LICENSE` 文件。
