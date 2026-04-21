---
name: summary-to-obsidian
description: "Use when the user explicitly wants to save, summarize, capture, or organize information into an Obsidian vault or note, including requests such as 写入 Obsidian, 记笔记, 保存到库里, save to Obsidian, write this down in notes, 整理成笔记, 做个总结存起来, 帮我记录一下. This skill orchestrates multiple Obsidian skills (obsidian-markdown, mermaid-visualizer, excalidraw-diagram, obsidian-canvas-creator, obsidian-bases) to produce rich, well-structured notes with diagrams, canvas maps, and database views as needed. Even if the user just says '保存' or 'save this', if the context involves Obsidian or notes, use this skill."
---

# 总结并写入 Obsidian 笔记库

## 概述

这是一个编排型 skill：分析用户意图和内容结构，然后调度专业 skills 来完成各自擅长的部分，最终产出高质量的 Obsidian 笔记。

**核心原则：** 先结论，后证据。每篇笔记以清晰的核心观点开头。

## 可调度的 Skills

本 skill 根据内容需要，通过 `Skill` 工具调用以下 skills：

| Skill | 何时调用 | 产出 |
|-------|----------|------|
| `obsidian-markdown` | 写笔记正文时，确保 wikilinks、callouts、properties、embeds 等语法正确 | 规范的 .md 内容 |
| `obsidian-visual-skills:mermaid-visualizer` | 内容包含流程、时序、状态机、对比等结构化信息 | 内联 Mermaid 代码块 |
| `obsidian-visual-skills:excalidraw-diagram` | 内容包含复杂架构图、关系网络、需要手绘风格的可视化 | .md 或 .excalidraw 文件 |
| `obsidian-visual-skills:obsidian-canvas-creator` | 需要空间化思维导图、多主题聚合、跨笔记全景视图 | .canvas 文件 |
| `obsidian-bases` | 用户有系列笔记需要数据库视图（表格、卡片、筛选） | .base 文件 |

**调用方式：** 在需要某个 skill 能力时，使用 `Skill` 工具调用对应 skill，加载其完整指令后按照该 skill 的规范执行。不要凭记忆猜测这些 skills 的语法细节——每次都调用加载最新版本。

## 前提：验证库路径

**在做任何事之前，先确认 Obsidian 库路径。**

检查当前目录下是否存在 `./调研/` 文件夹：

- **存在** → 继续，当前目录即为库根目录
- **不存在** → 停止，告知用户：

  > 当前目录（`<pwd>`）下未找到 `调研/` 文件夹，可能不是 Obsidian 库根目录。
  > 请确认：
  > 1. 是否需要在当前目录初始化库结构（创建 `调研/` 文件夹）？
  > 2. 还是应该切换到其他目录？

  等待用户确认后再继续。

## 库配置

- **库路径：** `./`（当前目录，已通过前提验证）
- **调研文件夹：** `./调研/`，存放所有总结内容
- **结构：** 顶层文件夹 = 领域，笔记存放在领域文件夹内

## 文件命名规范

格式：`[类型] 主题.md`

| 类型 | 使用场景 |
|------|----------|
| 概念 | 解释某事物是什么、核心原理 |
| 可行性 | 评估某事是否可行或值得做 |
| 总结 | 对某一主题、论文或研究体系的总结 |
| 分析 | 深度分析、根因分析、机制解析 |
| 对比 | 比较 2+ 个选项、技术或方案 |
| 人物 | 人物背景、贡献、观点 |
| 事件 | 历史或当前事件、事故 |
| 趋势 | 行业/技术趋势分析 |

示例：`[概念] ZK证明.md`、`[对比] GPT-4 vs Claude 3.md`、`[趋势] AI芯片2024.md`

## 访问限制

**严格禁止：** 未经用户明确允许，不得读取或写入 `./Myself/` 文件夹下的任何内容。

如果用户请求涉及 `Myself` 文件夹，必须先获得明确授权。

## 工作流程

### 第一步：确认目标与现有内容

先确认这次是新建笔记、更新已有笔记、还是追加章节。

只读取完成任务所必需的目录和笔记：
- 检查 `调研/` 下是否已有同主题或强相关笔记
- 已有类似内容 → 优先更新原笔记
- 没有类似内容 → 新建笔记，记录可添加的 `[[wikilinks]]`

### 第二步：规划可视化方案

分析内容，判断哪些部分用图表比纯文字更清晰。

**何时需要图表：**
- 流程、步骤、工作流 → 强烈建议
- 概念间的关系或依赖 → 强烈建议
- 对比多个方案 → 建议
- 层级结构或分类体系 → 建议
- 纯文字陈述，无明显结构 → 可跳过

**选择图表工具：**

| 场景 | 推荐工具 | 调用的 Skill |
|------|----------|-------------|
| 流程图、时序图、状态机、简单关系图 | Mermaid（内联，无需附件） | `obsidian-visual-skills:mermaid-visualizer` |
| 复杂架构图、关系网络、手绘风格图 | Excalidraw（存为附件） | `obsidian-visual-skills:excalidraw-diagram` |
| 空间化思维导图、多主题聚合、全景视图 | Canvas（存为附件） | `obsidian-visual-skills:obsidian-canvas-creator` |

**选择原则：**
- Mermaid 优先：能用 Mermaid 表达的就用 Mermaid，因为它直接内联在笔记中，无需额外文件
- Excalidraw：适合需要自由布局、手绘风格、或 Mermaid 表达力不够的复杂图（如系统架构全景图、多层关系网络）
- Canvas：适合整体思维导图或跨笔记组织
- 每篇笔记最多 2 张图，避免过度可视化

**调用方式：** 确定需要哪种图表后，使用 `Skill` 工具调用对应的 visual skill，按照该 skill 的完整指令来生成图表。生成的附件文件保存在对应领域目录下。

### 第三步：撰写笔记正文

调用 `obsidian-markdown` skill 加载 Obsidian Markdown 规范，然后按规范撰写笔记。

**必填 frontmatter：**
```yaml
---
title: "主题标题"
date: YYYY-MM-DD
tags: [tag1, tag2]
source: [url1, url2]
---
```

**内容规范：**
- 以结论开头，核心观点是什么
- 加粗关键判断 `**这是关键结论**`
- 使用 `[[wikilinks]]` 关联库内相关笔记（没有关联笔记就不加）
- 在合适位置嵌入第二步生成的图表：
  - Mermaid：直接内联代码块
  - Excalidraw：`![[图表名.md]]` 或 `![[图表名.excalidraw]]`
  - Canvas：`[[图表名.canvas]]`
- 使用 callout 标注重要事项（`> [!note]`、`> [!warning]` 等）
- 结构：核心结论 → 背景/定义 → 详细分析（含图表）→ 来源

**注意事项：**
- 附件和图片存放在当前文件夹的 `_resources` 目录下
- 流程图、架构图排版优先自上而下（`TB`）
- Mermaid 里换行使用 `<br/>`，`\n` 兼容性不好

### 第四步：确定分类和文件名

1. 从类型表选择正确的 `[类型]`
2. 选择或新建领域文件夹（如 `区块链/`、`AI/`、`政策/`）
3. 确认完整路径：`调研/<领域>/[类型] 主题.md`
4. 附件路径：`调研/<领域>/_resources/<附件名>`
5. Canvas 文件：`调研/<领域>/<文件名>.canvas`
6. Excalidraw 文件：`调研/<领域>/<文件名>.excalidraw`（或 `.md`，取决于输出模式）
7. Base 文件：`调研/<领域>/<文件名>.base`

如果请求模糊，最多提两个聚焦问题。

### 第五步：判断是否需要 Base 视图

如果用户正在建立某个领域的系列笔记（比如已有 3+ 篇同领域笔记），可以主动建议创建一个 Base 视图来管理这些笔记。

**适合创建 Base 的场景：**
- 同领域下有多篇笔记，需要按标签、日期、类型筛选
- 用户明确要求创建索引或数据库视图
- 对比类笔记需要表格化展示

**调用方式：** 使用 `Skill` 工具调用 `obsidian-bases`，按其规范创建 `.base` 文件。

### 第六步：保存并确认

将所有文件写入 Obsidian 库。完成后汇报：
- 保存的完整文件路径
- 核心结论（1-2 句话）
- 已关联的相关笔记
- 生成了哪些图表和附件（如有）
- 是否创建了 Base 视图（如有）

## 质量检查清单

保存前验证：
- [ ] frontmatter 包含所有必填字段
- [ ] 文件在正确的领域文件夹中，命名格式正确
- [ ] 笔记以结论开头，而非背景介绍
- [ ] 关键判断已加粗
- [ ] 库内已有的相关概念已添加 wikilink
- [ ] 来源已在 frontmatter 和/或正文中注明
- [ ] 图表（如有）已正确嵌入或链接
- [ ] 附件（如有）已保存至正确位置
- [ ] 调用的每个 skill 都是通过 Skill 工具加载的，而非凭记忆
