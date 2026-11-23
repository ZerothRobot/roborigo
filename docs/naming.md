# 命名规范

本文件记录 RoboRigo 项目的仓库命名规范。

---

## 当前决定

- 仓库按【项目名 + 角色】命名：`roborigo-<role>`
- **GitHub 仓库名**：全 kebab-case → `roborigo-rl-mjlab`
- **Python 包名**：全 snake_case → `roborigo_rl_mjlab`
- **主域名**：`roborigo.bot`
- 机器人资产文件名采用纯名称：`roborigo.urdf` / `roborigo.xml`，版本交给 git tag
- 消费仓库中的 RoboRigo 副本同样使用 `roborigo.urdf` / `roborigo.xml`；
  USD 使用 `roborigo_body_trainable_fullbody*`，不再保留旧机器人前缀
- 任务 ID 统一前缀 `RoboRigo-`：`RoboRigo-Flat` / `RoboRigo-Tracking`
- 分支统一 `main`

### 仓库清单

| 仓库 | 角色 |
|---|---|
| `roborigo` | 主仓库 / 聚合入口 / 文档 |
| `roborigo-description` | **机器人描述的权威来源** |
| `roborigo-retarget` | 动作重定向 |
| `roborigo-rl-mjlab` | RL 训练后端 A（mjlab） |
| `roborigo-rl-isaaclab` | RL 训练后端 B（Isaac Lab） |
| `roborigo-deploy` | 部署与实机推理 |
| `roborigo-hardware` | 机械 / 电气 / BOM |
| `roborigo-appearance` | 外壳与 DIY 辅助工具 |
| `roborigo-navigation` | 导航等扩展 demo |
| `roborigo-pipeline` | 开发流水线 / 打包 |

---
