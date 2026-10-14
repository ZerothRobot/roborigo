# 命名规范

本文件记录 Origo 项目的仓库命名规范。

---

## 当前决定

- 仓库按【项目名 + 角色】命名：`origo-<role>`
- **GitHub 仓库名**：全 kebab-case → `origo-rl-mjlab`
- **Python 包名**：全 snake_case → `origo_rl_mjlab`
- **主域名**：`origo.bot`
- 机器人资产文件名采用纯名称：`origo.urdf` / `origo.xml`，版本交给 git tag
  （随上游一并携带的资产包可以保留其原有文件名，例如 `origo-rl-isaaclab` 的
  `edu3_nqj13_trainable_fullbody.urdf`——包内的脚本与 USD 层按原名互相引用，
  改名需要一并改这些引用）
- 任务 ID 统一前缀 `Origo-`：`Origo-Flat` / `Origo-Tracking`
- 分支统一 `main`

### 仓库清单

| 仓库 | 角色 |
|---|---|
| `origo` | 主仓库 / 聚合入口 / 文档 |
| `origo-description` | **机器人描述的权威来源** |
| `origo-retarget` | 动作重定向 |
| `origo-rl-mjlab` | RL 训练后端 A（mjlab） |
| `origo-rl-isaaclab` | RL 训练后端 B（Isaac Lab） |
| `origo-deploy` | 部署与实机推理 |
| `origo-hardware` | 机械 / 电气 / BOM |
| `origo-appearance` | 外壳与 DIY 辅助工具 |
| `origo-navigation` | 导航等扩展 demo |
| `origo-pipeline` | 开发流水线 / 打包 |

---
