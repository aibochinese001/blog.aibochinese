# 旧 URL → 新 URL 对照表

本次规范化重命名共 **42** 个文件/目录。下表为旧路径到新路径的 301 对照。

| # | 旧路径 | 新路径 |
|---|---|---|
| 1 | `Rescous/free rs.html` | `Rescous/free_rs.html` |
| 2 | `SMC/sm maketing.html` | `SMC/sm_maketing.html` |
| 3 | `buildsites/chat support.html` | `buildsites/chat_support.html` |
| 4 | `buildsites/cloudflare Pages.html` | `buildsites/cloudflare_pages.html` |
| 5 | `buildsites/cloudflare R2.html` | `buildsites/cloudflare_r2.html` |
| 6 | `buildsites/code template.html` | `buildsites/code_template.html` |
| 7 | `buildsites/free ocs.html` | `buildsites/free_ocs.html` |
| 8 | `buildsites/host ssh.html` | `buildsites/host_ssh.html` |
| 9 | `conmon funcation code/Page template.html` | `conmon_funcation_code/page_template.html` |
| 10 | `conmon funcation code/ads.html` | `conmon_funcation_code/ads.html` |
| 11 | `conmon funcation code/embed chat` | `conmon_funcation_code/embed_chat` |
| 12 | `conmon funcation code/embed code template.html` | `conmon_funcation_code/embed_code_template.html` |
| 13 | `conmon funcation code/floatwechat-search.html` | `conmon_funcation_code/floatwechat-search.html` |
| 14 | `conmon funcation code/remit.html` | `conmon_funcation_code/remit.html` |
| 15 | `conmon funcation code/standard_nav.html` | `conmon_funcation_code/standard_nav.html` |
| 16 | `conmon funcation code/video code template.html` | `conmon_funcation_code/video_code_template.html` |
| 17 | `conmon funcation code/video list play bili.html` | `conmon_funcation_code/video_list_play_bili.html` |
| 18 | `conmon funcation code/video list play.html` | `conmon_funcation_code/video_list_play.html` |
| 19 | `conmon funcation code/移动端底部按钮.html` | `conmon_funcation_code/mobile_bottom_bar.html` |
| 20 | `earn online.html` | `earn_online.html` |
| 21 | `education/tutor guide.html` | `education/tutor_guide.html` |
| 22 | `mooc/Chinese-Tokens/课程内容索引.md` | `mooc/Chinese-Tokens/course_content_index.md` |
| 23 | `mooc/Chinese-Tokens/课程总结.md` | `mooc/Chinese-Tokens/course_summary.md` |
| 24 | `payment/Proxy Recharge.html` | `payment/proxy_recharge.html` |
| 25 | `payment/apply V-cards.html` | `payment/apply_v-cards.html` |
| 26 | `payment/self recharge.html` | `payment/self_recharge.html` |
| 27 | `post/China AdSense W-8BEN Tax Guide (2025).html` | `post/china_adsense_w-8ben_tax_guide_2025.html` |
| 28 | `post/Proxy Recharge.html` | `post/proxy_recharge.html` |
| 29 | `post/apply V-cards.html` | `post/apply_v-cards.html` |
| 30 | `post/chat support.html` | `post/chat_support.html` |
| 31 | `post/cloudflare Pages.html` | `post/cloudflare_pages.html` |
| 32 | `post/cloudflare R2.html` | `post/cloudflare_r2.html` |
| 33 | `post/code template.html` | `post/code_template.html` |
| 34 | `post/earn online.html` | `post/earn_online.html` |
| 35 | `post/free ocs.html` | `post/free_ocs.html` |
| 36 | `post/free rs.html` | `post/free_rs.html` |
| 37 | `post/global-payments-guide copy.html` | `post/global-payments-guide_copy.html` |
| 38 | `post/host ssh.html` | `post/host_ssh.html` |
| 39 | `post/search frame.html` | `post/search_frame.html` |
| 40 | `post/self recharge.html` | `post/self_recharge.html` |
| 41 | `post/sm maketing.html` | `post/sm_maketing.html` |
| 42 | `post/tutor guide.html` | `post/tutor_guide.html` |

## 目录级重定向

| 旧目录 | 新目录 |
|---|---|
| `conmon funcation code/` | `conmon_funcation_code/` |

## 使用方式

1. **Cloudflare Pages**：把 `_redirects` 复制到站点根目录，重新部署即可。
2. **Cloudflare Workers**：部署 `cloudflare-worker.js`，路由设为 `blog.aibochinese.com/*`。
3. **Nginx / Apache**：参考 `nginx-redirects.conf` 或 `htaccess-redirects.conf`。

> 规则同时提供了空格原样与 `%%20` 编码两种形式，避免不同客户端编码差异导致漏匹配。
