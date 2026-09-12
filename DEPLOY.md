# 网站更新与部署（2026-09-12 更新）

## 两份副本，必须同步

这个仓库里有两份**同一个网站的副本**，各自服务一个部署目标：

| 路径 | 服务谁 |
| --- | --- |
| `index.html` + `photos/`（仓库根目录） | **GitHub Pages** → https://luanshu.de5.net |
| `dist/index.html` + `dist/photos/` | **Cloudflare Pages** → https://luanshu-homepage.pages.dev |

改网站时**两份都要改**，改完一起提交。只改一份会导致两个域名显示不同内容（照片尤其容易漏，因为 GitHub Pages 是从仓库根目录取文件）。

```powershell
# 改完 dist 后，用这两条命令同步到仓库根目录
Copy-Item 'dist\index.html' 'index.html' -Force
Copy-Item 'dist\photos' 'photos' -Recurse -Force
```

## 目录说明

- `dist/` —— 完整站点（含 `photos/` 照片），Cloudflare 的部署源
- `photos/`（仓库根目录）—— GitHub Pages 用的同一批照片副本
- `dist/CNAME` 和根目录 `CNAME` —— 都写着 `luanshu.de5.net`，**不要删**，GitHub Pages 靠它绑定域名
- `photo/`、`IMG_*.JPG` —— 照片原图，只在本地，已被 .gitignore 排除，**不要提交**（大文件会让 Pages 构建失败）

## 更新流程

1. 改 `dist/index.html`（照片放进 `dist/photos/`）
2. 同步到仓库根目录：
   `Copy-Item 'dist\index.html' 'index.html' -Force` 和 `Copy-Item 'dist\photos' 'photos' -Recurse -Force`
3. `.\git.ps1 add -A` → `.\git.ps1 commit -m "说明"` → `.\git.ps1 push`
4. GitHub Pages 会自动重新构建（约 1 分钟）
5. Cloudflare Pages 需在后台连接 Git 后才会自动部署；在此之前手动执行：
   `wrangler pages deploy dist --project-name=luanshu-homepage --branch=main`

## 注意事项

- **不要提交大图**。曾有一版提交带入了 10.5MB 照片原图，导致 Pages 构建报 `Page build failed.`
- GitHub Pages 当前构建方式为 `legacy`（直接发布分支内容），源是 `main` 分支根目录
- 自定义域名 `luanshu.de5.net` 只能指向一个平台，两个平台同时绑同一个域名会冲突

## 私人访问密码（前端门禁）

站点有一个"私人档案"入口，访问密码放在 `index.html` 里的一段独立脚本中：

- 密码**不以明文存在**，文件里只有一个 SHA-256 哈希（`fa7a4bec…5013`）
- 验证通过后往 `localStorage` 写入 `private_site_auth`（值为时间戳 + 哈希），有效期 30 天
- 页面内容在验证前通过 `html.locked .shell{display:none}` 完全不下发
- 已通过验证的访客由 `<head>` 里的脚本在**首次绘制前**加上 `authed` 类，不会闪一下密码页
- 顶部导航的「退出」会清除 localStorage 并回到入口页
- 改密码：把新密码的 SHA-256 替换脚本里的 `AUTH_HASH`（`index.html` 与 `dist/index.html` 两处都要改）

```powershell
# 生成新密码的 SHA-256
$p='新密码'
[BitConverter]::ToString([System.Security.Cryptography.SHA256]::Create().ComputeHash([Text.Encoding]::UTF8.GetBytes($p))).Replace('-','').ToLower()
```

### ⚠️ 这个门禁的真实边界（务必知道）

这是**纯前端门禁，不是真正的安全措施**。当前架构是静态站点（没有服务端），所以做不到 HttpOnly Cookie / 服务端校验。具体来说：

1. **密码哈希可以被离线破解**。文件里只有哈希，但短数字密码（如 8 位数字）用普通电脑几秒就能反推。发给朋友没问题，防不住有心人。
2. **照片完全没有被保护**。这是最大的缺口 —— 图片是独立的静态文件，绕过页面直接访问链接即可查看：

   ```
   https://luanshu.de5.net/photos/sweet-10.jpg
   https://luanshu-homepage.pages.dev/photos/sweet-10.jpg
   https://ayangtuo.github.io/luanshu-homepage/photos/sweet-10.jpg
   https://raw.githubusercontent.com/AyangTuo/luanshu-homepage/main/photos/sweet-10.jpg
   ```

   知道图片命名规律（`sweet-01`～`sweet-10`）的人可以直接遍历下载。
3. **GitHub 仓库是公开的**，所以 `raw.githubusercontent.com` 那条链接绕过了所有前端限制。

已做的缓解：全站加了 `noindex, nofollow, noarchive`（搜索引擎不收录）和 `referrer: no-referrer`。这在"不希望被陌生人偶然翻到"这个目标上是有效的，但**挡不住任何主动尝试**。

### 想真正锁住，只有两条路

| 方案 | 效果 | 代价 |
| --- | --- | --- |
| **Cloudflare Access** | 页面+照片全部受保护，邮箱验证码放行 | 需要一个 Cloudflare 账号；每次新设备要收验证码 |
| **Cloudflare Worker + 环境变量** | 完全符合"密码 + HttpOnly Cookie + 照片保护" | 站点从 Pages 迁到 Worker；需要一个能写 Workers 的 token |
| **把 GitHub 仓库改为 Private** | 至少堵掉 `raw.githubusercontent.com` 这个缺口 | 可能影响 GitHub Pages（需确认套餐支持） |

