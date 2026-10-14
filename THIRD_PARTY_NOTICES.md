# Third-Party Notices

Origo 使用了若干第三方开源组件。本文件列出这些组件的来源、许可证与版权声明。

**任何引入或移除第三方组件的改动，都必须同步更新本文件。**

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
- **用途**：Isaac 仿真后端（`origo-rl-isaaclab`）

### RSL-RL

- **来源**：<https://github.com/leggedrobotics/rsl_rl>
- **许可证**：BSD 3-Clause
- **版权**：Copyright (c) 2021, ETH Zurich, Robotic Systems Lab
- **用途**：PPO 算法实现

### GMR (General Motion Retargeting)

- **来源**：<https://github.com/Yanjieze/GMR>
- **许可证**：MIT License
- **版权**：Copyright 2025 Yanjieze
- **用途**：人体动作到机器人的重定向（`origo-retarget`）

### mink

- **来源**：<https://github.com/kevinzakka/mink>
- **许可证**：Apache License 2.0
- **版权**：Copyright Kevin Zakka
- **用途**：基于 MuJoCo 的逆运动学求解

---

## 内嵌第三方组件

以下组件以源码或二进制形式内嵌于本项目，其许可证原文必须随附保留。

| 组件 | 位置 | 许可证 | 版权 |
|---|---|---|---|
| ONNX Runtime | `origo-deploy/thirdparty/` | Apache-2.0 | Copyright Microsoft Corporation |
| cnpy | `origo-deploy/thirdparty/` | MIT | Copyright Carl Rogers |
| lodepng | `origo-rl-mjlab/`（仿真查看器） | zlib | Copyright Lode Vandevenne |
| joystick | `origo-rl-mjlab/`（仿真查看器） | BSD | Copyright Sam Lantinga |

---

## 许可证合规要求

1. **保留版权声明。** 任何保留下来的第三方代码文件，其版权头和许可证声明一律原文保留。
   即使只保留少量片段，归属信息同样保留。
2. **保留 NOTICE 文件内容。** Apache-2.0 组件若带有 `NOTICE` 文件，其内容必须随附。
3. **声明修改。** Apache-2.0 要求对修改过的文件作出说明。
4. **如实标注来源。** 可以重写实现，既有归属声明一律保留。

> 重构可以自由进行——前提是上述四条守住。详见 `docs/naming.md` 的命名约束。
