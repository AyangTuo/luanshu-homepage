# 栾树 LUANSHU · 个人主页

一个人的线上小屋。单文件静态站点，无构建步骤、无外部依赖。

- 线上地址：https://luanshu-homepage.pages.dev
- 代码仓库：https://github.com/AyangTuo/luanshu-homepage
- 目标域名：luanshu.de5.net（待绑定）

## 文件说明

| 文件 | 作用 |
| --- | --- |
| `dist/index.html` | 整个网站。内联了全部 CSS 与 JS，直接部署即可 |
| `dist/photos/` | 网页用的照片（12MP 原图压缩后的版本，共 535KB） |
| `photo/`、`IMG_*.JPG` | 照片原图，**只在本地留档，不进仓库**（已在 .gitignore 排除） |
| `git.ps1` | git 包装脚本（本机用的是仓库内的便携版 git） |
| `.tools/` | 便携版 git 与 wrangler，**不纳入版本管理** |
| `.openai/hosting.json` | ChatGPT/Codex 静态托管配置，保留未动 |

## 本地改动 → 上线

改完 `dist/index.html` 后：

```powershell
.\git.ps1 add -A
.\git.ps1 commit -m "改了什么"
.\git.ps1 push
```

或者跳过 git，直接推到 Cloudflare：

```powershell
$env:CLOUDFLARE_API_TOKEN = "<你的 token>"
$env:CLOUDFLARE_ACCOUNT_ID = "44bb246fe6611e0abf5a84ef64a61589"
.\.tools\wrangler\node_modules\.bin\wrangler.cmd pages deploy dist --project-name=luanshu-homepage --branch=main
```

## 部署信息

- Cloudflare 账号 ID：`44bb246fe6611e0abf5a84ef64a61589`
- Pages 项目名：`luanshu-homepage`
- 生产分支：`main`
- Build command：留空（纯静态）
- Build output directory：`dist`

## 页面结构

```
首屏（海报 + 数字统计）
跑马灯
01 关于我
02 那个夏天的夜晚（照片 + 灯箱）
03 兴趣与日常
04 在做的事
05 时间线
联系
页脚
```

## 待办

- [ ] 在 Cloudflare 后台把 Pages 项目连接到 GitHub 仓库，实现 push 自动部署
- [ ] 绑定自定义域名 `luanshu.de5.net`
- [ ] 替换 GitHub 卡片里的占位链接（目前指向 github.com 首页）
- [ ] 补上「公众号 / 小红书 / B站」那张占位卡的链接

## 换照片的方法

1. 把新照片放进 `photo/`
2. 用下面的脚本压缩并生成网页版本（会自动处理手机照片的 EXIF 旋转）
3. 改 `dist/index.html` 里 `.photo-grid` 中对应的 `src` 和说明文字

```powershell
# 示例：把 IMG_1234.JPG 转成网页版本（宽 1400、质量 80）
Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("photo\你的照片.JPG")
# EXIF 方向为 6 或 8 时需要旋转，否则跳过这行
$img.RotateFlip([System.Drawing.RotateFlipType]::Rotate90FlipNone)
# …缩放并保存为 dist/photos/xxx.jpg
```
