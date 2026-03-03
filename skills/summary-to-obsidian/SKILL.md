---
name: summary-to-obsidian
description: Use when user asks to research, investigate, analyze, compare, or summarize a topic and wants results saved as Obsidian notes. Triggers on Chinese keywords like 调研、研究、分析、整理、总结、对比 as well as English equivalents. Creates structured markdown notes in the user's Obsidian research vault.
---

# 调研笔记

## 概述

执行调研任务，并在用户的 Obsidian 调研库中生成标准化笔记。**必须保存输出——不要只在对话中回复。**

**核心原则：** 先结论，后证据。每篇笔记以清晰的核心观点开头。

## 库配置

- **库路径：** `/Users/yunfeng/Library/Mobile Documents/com~apple~CloudDocs/Obsidian/调研/`
- **结构：** 顶层文件夹 = 领域，笔记存放在领域文件夹内
- **工具：** 所有库操作均使用 `obsidian:obsidian-cli` skill

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

## 工作流程

### 第一步：动手前先澄清

如果请求模糊或目的不明确，最多提两个聚焦的问题：
- 应该放在哪个领域/文件夹？
- 你最想解答的核心问题是什么？

如果主题和范围已经清晰，直接开始。

### 第二步：确定分类和文件名

1. 从上表选择正确的 `[类型]`
2. 选择或新建领域文件夹（例如 `区块链/`、`AI/`、`政策/`）
3. 确认完整路径：`<库路径>/<领域>/<[类型] 主题>.md`

### 第三步：多源调研

按以下顺序调研，按需深入：

1. **库内已有笔记** — 搜索相关笔记，避免重复并建立关联
2. **网络搜索** — 最新信息、新闻、官方来源
3. **论文/文档** — 技术性或学术性话题
4. **公开数据** — 统计数据、报告、数据集

### 第四步：撰写笔记

**必填 frontmatter：**
```yaml
---
title: "主题标题"
date: YYYY-MM-DD
tags: [tag1, tag2]
source: [url1, url2]
status: draft | complete
---
```

**内容规范：**
- **以结论开头** — 核心观点是什么？
- **加粗关键判断** — `**这是关键结论**`
- 使用 `[[wikilinks]]` 关联库内相关笔记
- 使用 callout 标注重要注意事项：
  ```
  > [!note] 注意
  > 重要的注意事项

  > [!warning] 风险
  > 关键风险或局限性
  ```
- 结构：核心结论 → 背景/定义 → 详细分析 → 来源

### 第五步：保存并确认

使用 `obsidian:obsidian-cli` 将文件写入库中。完成后汇报：
- 保存的完整文件路径
- 核心结论（1-2 句话）
- 已关联的相关笔记

## 质量检查清单

保存前验证：
- [ ] frontmatter 包含所有必填字段
- [ ] 文件在正确的领域文件夹中，命名格式正确
- [ ] 笔记以结论开头，而非背景介绍
- [ ] 关键判断已加粗
- [ ] 库内已有的相关概念已添加 wikilink
- [ ] 来源已在 frontmatter 和/或正文中注明
- [ ] status 已正确设置为 `draft` 或 `complete`
