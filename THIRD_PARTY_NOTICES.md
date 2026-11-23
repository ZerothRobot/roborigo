# Third-Party Notices

RoboRigo 使用了若干第三方组件。本文件列出这些组件的来源、许可证与版权声明。

**任何引入或移除第三方组件的改动，都必须同步更新本文件。**

> 注：下表中的 `ccrpRepo/robot_retargeter` **并非开源许可组件**——其上游未声明任何许可证，
> 详见「内嵌第三方组件」一节的说明。

---

## 直接依赖

### mjlab

- **来源**：<https://github.com/mujocolab/mjlab>
- **许可证**：Apache License 2.0
- **版权**：Copyright The MjLab Developers
- **用途**：强化学习训练框架（Isaac Lab 风格 API + MuJoCo-Warp 物理后端）
- **备注**：中立研究框架，由独立研究社区维护

### MuJoCo / MuJoCo-Warp

- **来源**：<https://github.com/google-deepmind/mujoco>、<https://github.com/google-deepmind/mujoco_warp>
- **许可证**：Apache License 2.0
- **版权**：Copyright Google DeepMind
- **用途**：物理仿真后端

### Isaac Lab

- **来源**：<https://github.com/isaac-sim/IsaacLab>
- **许可证**：BSD 3-Clause
- **版权**：Copyright (c) 2024, The Isaac Lab Project Developers
- **用途**：Isaac 仿真后端（`roborigo-rl-isaaclab`）

### RSL-RL

- **来源**：<https://github.com/leggedrobotics/rsl_rl>
- **许可证**：BSD 3-Clause
- **版权**：Copyright (c) 2021, ETH Zurich, Robotic Systems Lab
- **用途**：PPO 算法实现

### 参考实现（未内嵌）

- [GMR (General Motion Retargeting)](https://github.com/Yanjieze/GMR) — MIT License，
  Copyright 2025 Yanjieze。重定向算法的**参考实现**，未内嵌于任何仓库；
  `roborigo-retarget` 的逆运动学求解使用 mink。

### mink

- **来源**：<https://github.com/kevinzakka/mink>
- **许可证**：Apache License 2.0
- **版权**：Copyright Kevin Zakka
- **用途**：基于 MuJoCo 的逆运动学求解

---

## 内嵌第三方组件

### 已内嵌

以下组件以源码或文档形式内嵌于本项目，其许可证原文必须随附保留。

| 组件 | 位置 | 许可证 | 版权 |
|---|---|---|---|
| ccrpRepo/robot_retargeter | `roborigo-retarget/`（迁移代码与文档） | **上游未声明许可证**（默认保留所有权利） | ccrpRepo © 2026（同组织 `wbc_fsm` 自署「ccrpRepo / ZSTU Robotics」） |
| BeyondMimic (whole_body_tracking) | `roborigo-rl-isaaclab/`（迁移的 Isaac Lab 扩展、脚本与动作数据） | MIT | Copyright (c) 2024, The Isaac Lab Project Developers |

### ccrpRepo/robot_retargeter（迁移进 `roborigo-retarget`）

- **来源**：<https://github.com/ccrpRepo/robot_retargeter>
- **版权**：ccrpRepo © 2026（`robot_retargeter` 自身未标注版权主体；同组织 `wbc_fsm` 自署「ccrpRepo / ZSTU Robotics © 2026」）
- **许可证**：**上游未声明任何许可证**。经核对：仓库根目录没有 `LICENSE` / `NOTICE` / `COPYING`，
  中英文 README 中也没有许可证章节，GitHub 的 license 字段为空。按默认规则属于「保留所有权利」。
- **用途**：`roborigo-retarget` 的重定向流水线代码（`scripts/`、`bash/`、`config/`）与算法文档（`docs/`）
- **⚠️ 限制**：在取得上游作者书面授权之前，**仅限内部使用**，不得对外发布、再分发或商用。
- **本地修改清单**：见 [`../roborigo-retarget/THIRD_PARTY_NOTICES.md`](../roborigo-retarget/THIRD_PARTY_NOTICES.md)

> 因此 `roborigo-retarget` 的代码**不构成可整体再分发的 Apache-2.0 作品**：
> 其中 RoboRigo 自行编写的部分按 Apache-2.0，迁移部分仍受上游「保留所有权利」约束。

### BeyondMimic（whole_body_tracking，迁移进 `roborigo-rl-isaaclab`）

- **来源**：<https://github.com/HybridRobotics/whole_body_tracking>
- **许可证**：MIT License
- **版权**：Copyright (c) 2024, The Isaac Lab Project Developers
- **用途**：`roborigo-rl-isaaclab` 的 Isaac Lab 扩展、训练/回放脚本与动作数据
- **许可证原文**：[`../roborigo-rl-isaaclab/LICENSES/BeyondMimic-LICENCE.txt`](../roborigo-rl-isaaclab/LICENSES/BeyondMimic-LICENCE.txt)
- **本地修改清单**：见 [`../roborigo-rl-isaaclab/THIRD_PARTY_NOTICES.md`](../roborigo-rl-isaaclab/THIRD_PARTY_NOTICES.md)

> MIT 与 Apache-2.0 兼容：`roborigo-rl-isaaclab` 自身按 Apache-2.0 使用，
> 迁移部分保留上游 MIT 的版权与许可声明即可。
> 注意 `roborigo-rl-isaaclab/source/motion/roborigo/` 的动作数据派生自 LAFAN1（CC BY-NC-ND 4.0），
> 仅限内部研究使用。

### 规划内嵌（尚未落盘）

`roborigo-deploy` 的 `thirdparty/` 目录目前**尚未创建**（其 README 的「目录结构」与
「现状与计划」已把它列为目标）。下面两项是该仓库设计上要内嵌的库，
**落地时必须随附许可证原文**：

| 组件 | 位置 | 许可证 | 版权 |
|---|---|---|---|
| ONNX Runtime | `roborigo-deploy/thirdparty/`（规划） | Apache-2.0 | Copyright Microsoft Corporation |
| cnpy | `roborigo-deploy/thirdparty/`（规划） | MIT | Copyright Carl Rogers |

> 仿真查看器用的图形库（lodepng / joystick 等）随 **mjlab** 依赖提供，不在本表内。

---

## 许可证合规要求

1. **保留版权声明。** 任何保留下来的第三方代码文件，其版权头和许可证声明一律原文保留。
   即使只保留少量片段，归属信息同样保留。
2. **保留 NOTICE 文件内容。** Apache-2.0 组件若带有 `NOTICE` 文件，其内容必须随附。
3. **声明修改。** Apache-2.0 要求对修改过的文件作出说明。
4. **如实标注来源。** 可以重写实现，既有归属声明一律保留。

> 重构可以自由进行——前提是上述四条守住。详见 `docs/naming.md` 的命名约束。
