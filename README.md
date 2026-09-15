# AI Bo Chinese Blog

这是 AI Bo Chinese 的个人博客仓库，包含静态 HTML 页面与相关资源，用于发布中文技术与学习类文章（AI、编程、语言学习等）。

## 仓库简介

- 仓库名：aibochinese001/blog.aibochinese
- 描述：AI Bo Chinese blog repository
- 主要语言：HTML（约 99%）

## 功能亮点

- 纯静态站点，使用 HTML/CSS/静态资源构建，部署成本低。
- 适合托管在 GitHub Pages 或任意静态站点服务上。

## 目录结构（示例）

仓库中的实际目录结构可能有所不同，以下为常见结构示意：

- index.html                # 站点首页
- posts/                    # 文章页面或按需命名的目录
- assets/
  - css/                    # 样式文件
  - js/                     # 脚本文件（若有）
  - img/                    # 图片资源
- README.md                 # 本文件

> 如果您的仓库目录与上面示例不完全一致，请根据实际文件组织进行调整。

## 本地预览

1. 克隆仓库：

   git clone https://github.com/aibochinese001/blog.aibochinese.git

2. 进入仓库并直接用浏览器打开 `index.html`：

   - 双击 `index.html` 或者使用浏览器的“文件 -> 打开文件”功能。

   或者使用一个简单的本地静态服务器（推荐用于测试相对路径与路由）：

   - 使用 Python 3：
     ```bash
     python -m http.server 8000
     # 然后在浏览器打开 http://localhost:8000
     ```

   - 使用 Node.js（http-server）：
     ```bash
     npx http-server -p 8000
     # 然后在浏览器打开 http://localhost:8000
     ```

## 部署到 GitHub Pages

1. 在 GitHub 仓库页面点击 Settings -> Pages。
2. 选择部署分支（通常选择 `main` 或 `master`）以及根目录 `/ (root)` 或 `/docs`，保存。
3. 等待几分钟，GitHub 会生成站点并给出网址，例如：https://aibochinese001.github.io/blog.aibochinese/。

如果需要自定义域名，请在仓库根目录添加 `CNAME` 文件并在域名 DNS 中添加相应的 A/ALIAS/AAAA/CNAME 记录。

## 编辑与发布文章

- 直接在 HTML 文件中添加/修改文章内容（若使用纯静态模板）。
- 推荐工作流：在本地新建分支、添加/修改文件、提交并发起 Pull Request，经过检查后合并到默认分支以触发部署。

## 贡献

欢迎改进仓库：

- Fork 本仓库，创建分支，完成修改并发起 Pull Request。
- 提交清晰的提交信息与变更说明；如涉及样式或脚本，请尽量保证向后兼容。

## 许可证

本仓库未指定许可证（If you want to make this repo open-source, consider adding a LICENSE file such as MIT）。

## 联系方式

如果有问题或建议，请通过 GitHub Issues 与我联系。

---

感谢使用和关注 AI Bo Chinese 的博客项目！
