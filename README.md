# 栾树 LUANSHU · 个人主页

一个人的线上小屋。单文件静态站点，无构建步骤、无外部依赖。

- 线上地址：https://luanshu-homepage.pages.dev
- 代码仓库：https://github.com/AyangTuo/luanshu-homepage
- 目标域名：luanshu.de5.net（待绑定）

## 文件说明

| 文件 | 作用 |
| --- | --- |
| `dist/index.html` | 整个网站。内联了全部 CSS 与 JS，直接部署即可 |
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
02 兴趣与日常
03 在做的事
04 时间线
联系
页脚
```

## 待办

- [ ] 在 Cloudflare 后台把 Pages 项目连接到 GitHub 仓库，实现 push 自动部署
- [ ] 绑定自定义域名 `luanshu.de5.net`
- [ ] 替换 GitHub 卡片里的占位链接（目前指向 github.com 首页）
- [ ] 补上「公众号 / 小红书 / B站」那张占位卡的链接
