# 池 — ASCII 思维泡泡手账

纯白底、ASCII 字符绘制的荷花与鱼，右下角写下的句子会变成缓慢漂浮的泡泡。
每天一页，泡泡满了自动翻新页，每页的荷花荷叶鱼布局由该页的 seed 决定。

## 结构

- `index.html` — 全部内容（画面、交互、数据层），无构建步骤
- 数据存在 Supabase，页面本身是静态的

## 权限

- 任何人打开 = 只读。未登录时连右下角的加号都不渲染
- 写入需要登录：左下角角标**连点三下**，或按 **Shift+L** 唤出登录框
- 真正的权限边界是数据库的 RLS，不是前端。`anon` 角色只有 select，
  insert/delete 要求 `authenticated`

## 数据库

两张表：

- `bubbles` — 一条记录一个泡泡（text / day / page / hue / created_at）
- `pages` — 每一页的 seed，保证所有访客看到同一幅背景

泡泡在页面上的落点由其 `id` 哈希出来，不存坐标，所以每个人打开看到的排布一致。

建表 SQL 见 `schema.sql`。

## 本地预览

```sh
python3 -m http.server 8000
```

然后开 http://localhost:8000 。直接双击 `index.html` 用 `file://` 打开不行，
ES module 和 Supabase 的跨域请求会被拦。

## 部署

推到 `main`，仓库 Settings → Pages → Source 选 `main` / `(root)`。
