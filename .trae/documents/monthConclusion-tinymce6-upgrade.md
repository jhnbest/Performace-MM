# 月总结编辑器 TinyMCE 5 → 6 升级方案

## 一、概述

将月总结富文本编辑器由 `tinymce@5.10.9` + `@tinymce/tinymce-vue@2.1.0` 升级到
`tinymce@6` + `@tinymce/tinymce-vue@3`，并新增 `paste` 插件与粘贴样式过滤配置，
解决"粘贴时把复制源格式（颜色/字体/字号等）一并带入"的体验问题。
粘贴行为目标：**仅保留基础排版**（加粗/斜体/下划线/列表/标题等结构），剥离源颜色、字体、字号、背景等内联样式。

## 二、现状分析

- 编辑器组件：[editor.vue](file:///d:/vscode_project/Performace-MM/front-end/src/components/monthConclusion/editor.vue)
- 依赖声明：[package.json](file:///d:/vscode_project/Performace-MM/front-end/package.json#L11)（`@tinymce/tinymce-vue ^2.1.0`）、[package.json](file:///d:/vscode_project/Performace-MM/front-end/package.json#L23)（`tinymce ^5.0.12`，实际锁定 5.10.9）
- 使用方：[monthConclusionTableNew.vue](file:///d:/vscode_project/Performace-MM/front-end/src/views/monthConclusion/childViews/monthConclusionTableNew.vue#L47-L48) 等以 `<editor-vue :value @input>` 方式使用，数据为 HTML 字符串，与版本升级无关，无需改动。
- 项目为 Vue 2.6.10 + vue-cli 3.11（webpack 4）。

**根因**：当前 `editor.vue` 既未导入 `paste` 插件，默认 `plugins` 也不含 `paste`，
粘贴走浏览器原生行为，不经过 TinyMCE 内容过滤，导致源格式被完整保留。

**版本约束（直接影响方案选择）**：
- Vue 2 项目下 `@tinymce/tinymce-vue` 最高兼容到 **v3**（v4+ 仅支持 Vue 3）。
- 为降低老旧 webpack 4 工具链风险，TinyMCE 核心选择 **v6.x**（v7 对 webpack 5+ 依赖更强，升级风险更高）。

## 三、改动清单

### 1. 依赖升级（front-end/package.json + package-lock.json）
- `"tinymce": "^5.0.12"` → `"tinymce": "^6.8.0"`（v6 末代稳定版）
- `"@tinymce/tinymce-vue": "^2.1.0"` → `"@tinymce/tinymce-vue": "^3.2.8"`（npm 官方 `vue2` 标签版本）
- 执行 `npm install` 更新 `package-lock.json` 与 `node_modules/tinymce`（注意 Teancent 镜像源不变）。

> 说明：`tinymce-vue` v3 仍默认导出 `Editor` 组件、标签名 `<editor>` 与 v2 基本一致，组件使用方无需改动；
> 实施时需验证 `disabled` prop 行为（v2→v3 若有差异，在 editor.vue 内处理）。

### 2. 静态资源同步（public/tinymce）
TinyMCE 皮肤/语言包需与核心主版本匹配，v6 与 v5 皮肤 CSS 类名不兼容，必须整体替换：
- `public/tinymce/skins/`：用 `node_modules/tinymce/skins/` 中 v6 版覆盖（含 `ui/oxide`、`content/default` 等）。
- `public/tinymce/langs/zh_CN.js`：替换为 v6 官方中文语言包。
- `public/tinymce/icons/`：若需保持 webpack 内联导入风格，改为在 editor.vue 中 `import 'tinymce/icons/default/icons'`；
  若保持从 public 读取，则同步替换为 v6 版本（建议前者，与核心同源避免版本漂移）。

### 3. editor.vue 适配与粘贴过滤
修订 [editor.vue](file:///d:/vscode_project/Performace-MM/front-end/src/components/monthConclusion/editor.vue)：

- **导入调整**：
  ```js
  import tinymce from 'tinymce/tinymce'
  import Editor from '@tinymce/tinymce-vue'
  import 'tinymce/icons/default/icons'   // v6 需要显式导入图标
  import 'tinymce/models/dom'            // v6 必须导入 DOM model
  import 'tinymce/themes/silver'
  import 'tinymce/plugins/paste'         // 新增，粘贴过滤核心
  import 'tinymce/plugins/image'
  import 'tinymce/plugins/link'
  import 'tinymce/plugins/code'
  import 'tinymce/plugins/table'
  import 'tinymce/plugins/lists'
  import 'tinymce/plugins/wordcount'
  ```
- **init 配置**：
  - 删除 `theme: 'silver'`（v6 已移除 theme 配置项，主题改为导入决定）。
  - `plugins` 默认值追加 `paste`：`'link lists table wordcount paste'`。
  - 保留 `base_url` / `skin_url` / `language_url` 指向 public（需与第 2 步 v6 资源匹配）。
  - 新增粘贴过滤（仅保留基础排版）：
    ```js
    paste_as_text: false,                          // 保留段落/列表结构
    paste_remove_styles_if_webkit: false,          // 关闭"全量剥离"，改用白名单
    paste_webkit_styles: 'font-weight font-style text-decoration', // 只保留粗/斜/下划线
    paste_merge_formats: true,
    paste_convert_word_fake_lists: true,
    ```
  > 实施时以 v6 官方 paste 文档校准确切键名与取值（`paste_webkit_styles` 在 v6 中依然有效）。

### 4. 冗余清理（可选）
确认 `src/components/monthConclusion/zh_CN.js` 是否被引用；若未引用可删除（避免混淆）。默认不删，除非验证确认无用。

## 四、假定与决策
- 采用「升级 TinyMCE 5→6」+「粘贴仅保留基础排版」；已获用户确认。
- 升级限定在 `front-end` 目录；**不触碰后端**。按项目规则，执行修改前需确认当前工作目录为 `front-end`（当前主工作目录为项目根 `Performace-MM`，含前后端，故执行前说明并确认）。
- 保持编辑器组件对外 API（`:value`/`@input`/`:disabled`/`plugins`/`toolbar`）不变，使用方 `monthConclusionTableNew.vue` 无需改动。
- 数据层面 `content` 仍为 HTML 字符串，无需任何数据库/接口迁移。
- 不引入付费 PowerPaste；用开源免费 `paste` 插件满足需求。

## 五、验证步骤
1. `cd front-end && npm install` 成功，`package-lock.json` 中 tinymce 为 6.x。
2. `npm run serve` 启动，打开月总结编辑页。
3. 分别从 Word / 网页 / 富文本编辑器复制含颜色、字体、字号、加粗、列表的内容粘贴：
   - 期望：加粗、斜体、下划线、列表、标题保留；颜色、字体、字号、背景被剥离。
4. 原已有月总结内容打开后样式正常（v6 内容 CSS 生效、无乱码、无初始化重复问题——沿用 `initComplete` 防抖逻辑）。
5. 提交/暂存功能正常，保存内容在后端展示无异常。
6. 控制台无 TinyMCE 版本警告、无皮肤加载 404。

## 六、实施步骤顺序
1. 修改 `package.json` 依赖版本。
2. 在 `front-end` 执行 `npm install`。
3. 同步 `public/tinymce`（skins / langs / icons）。
4. 重写 `editor.vue` 的导入与 init 配置。
5. 按第五节逐项验证；必要时比对 v6 官方文档校准 paste 键名。