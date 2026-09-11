# 网站更新与部署

公开网站文件是仓库根目录的 `index.html` 和 `CNAME`。修改完成后，将改动提交并推送到 GitHub 的 `main` 分支，GitHub Pages 会自动部署到：

https://luanshu.de5.net

DeepSeek 更新网站时，只需完成以下步骤：

1. 修改根目录的 `index.html`，并确保 `CNAME` 保留为 `luanshu.de5.net`。
2. 提交全部网页改动。
3. 推送到 `origin main`。
4. 在 GitHub 仓库的 Deployments 或 Pages 页面确认部署成功。

不要删除根目录的 `CNAME`，它负责保持自定义域名绑定。
