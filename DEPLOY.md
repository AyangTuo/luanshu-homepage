# 网站更新与部署（2026-09-12 更新）

## 两份副本，必须同步

这个仓库里有两份**同一个网站的副本**，各自服务一个部署目标：

| 文件 | 服务谁 |
| --- | --- |
| `index.html`（根目录） | **GitHub Pages** → https://luanshu.de5.net |
| `dist/index.html` + `dist/photos/` | **Cloudflare Pages** → https://luanshu-homepage.pages.dev |

改网站时**两份都要改**，改完一起提交。只改一份会导致两个域名显示不同内容。

```powershell
# 改完 dist 后，用这条命令同步到根目录
Copy-Item 'dist\index.html' 'index.html' -Force
```

## 目录说明

- `dist/` —— 完整站点（含 `photos/` 照片），Cloudflare 的部署源
- `dist/CNAME` 和根目录 `CNAME` —— 都写着 `luanshu.de5.net`，**不要删**，GitHub Pages 靠它绑定域名
- `photo/`、`IMG_*.JPG` —— 照片原图，只在本地，已被 .gitignore 排除，**不要提交**（大文件会让 Pages 构建失败）

## 更新流程

1. 改 `dist/index.html`（照片放在 `dist/photos/`）
2. `Copy-Item 'dist\index.html' 'index.html' -Force` 同步根目录副本
3. `.\git.ps1 add -A` → `.\git.ps1 commit -m "说明"` → `.\git.ps1 push`
4. GitHub Pages 会自动重新构建（约 1 分钟）
5. Cloudflare Pages 需在后台连接 Git 后才会自动部署；在此之前手动执行：
   `wrangler pages deploy dist --project-name=luanshu-homepage --branch=main`

## 注意事项

- **不要提交大图**。曾有一版提交带入了 10.5MB 照片原图，导致 Pages 构建报 `Page build failed.`
- GitHub Pages 当前构建方式为 `legacy`（直接发布分支内容），源是 `main` 分支根目录
- 自定义域名 `luanshu.de5.net` 只能指向一个平台，两个平台同时绑同一个域名会冲突
