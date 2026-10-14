# Origo

**一个面向开发者与极客的开源人形机器人项目。**

[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)
[![Python](https://img.shields.io/badge/python-3.10%2B-blue.svg)](https://www.python.org/)
[![MuJoCo](https://img.shields.io/badge/physics-MuJoCo-orange.svg)](https://mujoco.org/)
[![Isaac Lab](https://img.shields.io/badge/physics-Isaac%20Lab-silver.svg)](https://isaac-sim.github.io/IsaacLab)

---

## 关于本项目

Origo 是一台 3D 打印、全开源的人形机器人。整机 **21 个自由度**，采用模块化关节模组，
目标是让开发者与极客用尽可能低的门槛上手真实的人形机器人研究：

- **可打印** — 结构件 3D 打印，普通 FDM 设备即可完成
- **可复刻** — 完整 BOM、装配指南、标定流程开源
- **可训练** — 内置强化学习训练工作流，支持多种仿真后端
- **可部署** — 训练出的策略可直接导出到实机
- **可扩展** — 适配主流与前沿机器人框架，技术栈自由选择

### 定位声明

> Origo 是一个**独立的开源项目**。
>
> 项目名仅代表 Origo 项目本身。
>
> 社区贡献全部用于 Origo 项目本身。

---

## 组件导览

Origo 由若干独立仓库组成。本仓库 (`origo`) 是**聚合入口**——内容为文档与仓库索引，
实现代码位于各子仓库。**本仓库不提供统一命令入口**，各子仓库的命令在各自目录内执行。

| 仓库 | 职责 | 依赖 |
|---|---|---|
| **[origo-description](https://github.com/origo-robotics/origo-description)** | **机器人描述的权威来源**<br>URDF / MJCF / USD / 网格 / 关节定义 / 执行器参数 | — |
| **[origo-retarget](https://github.com/origo-robotics/origo-retarget)** | 人体动作 → 机器人动作的重定向流水线 | description |
| **[origo-rl-mjlab](https://github.com/origo-robotics/origo-rl-mjlab)** | RL 训练后端 A（mjlab + MuJoCo-Warp） | description, retarget |
| **[origo-rl-isaaclab](https://github.com/origo-robotics/origo-rl-isaaclab)** | RL 训练后端 B（Isaac Lab） | description, retarget |
| **[origo-deploy](https://github.com/origo-robotics/origo-deploy)** | 策略部署与实机推理 | description |
| **[origo-hardware](https://github.com/origo-robotics/origo-hardware)** | 机械结构 / 电气 / PCB / BOM | — |
| **[origo-appearance](https://github.com/origo-robotics/origo-appearance)** | 外壳与 DIY 辅助工具 | hardware |
| **[origo-navigation](https://github.com/origo-robotics/origo-navigation)** | 导航与定位等扩展 demo | description |
| **[origo-pipeline](https://github.com/origo-robotics/origo-pipeline)** | 开发流水线 / 打包 / 分发 | 全部 |

### 依赖关系

```
                    origo-description   ★ 权威来源
                            │
        ┌───────────────────┼───────────────────┬──────────────────┐
        ▼                   ▼                   ▼                  ▼
  origo-retarget     origo-rl-mjlab     origo-rl-isaaclab    origo-deploy
  （重定向出动作）    （后端 A 训练）      （后端 B 训练）       （策略上机）
        │                   │                   │                  │
        └───────────────────┴───────────────────┴──────────────────┘
                            ▼
                         origo  （本仓库：文档 / 仓库索引）
```

**关键设计**：四个消费方以 `origo-description` 的关节顺序与执行器参数为准。

---

## 快速开始

各子仓库以**平级目录**协作（本阶段不使用 submodule）：

```
<工作区>/
├── origo/                  ← 本仓库（文档 / 仓库索引）
├── origo-description/
├── origo-retarget/
├── origo-rl-mjlab/
├── origo-rl-isaaclab/
├── origo-deploy/
├── origo-hardware/
├── origo-appearance/
├── origo-navigation/
└── origo-pipeline/
```

在需要的那一侧目录内安装依赖并运行（下例为训练后端 A）：

```bash
conda activate origo_mjlab
cd origo-rl-mjlab

# 训练速度跟踪策略
python scripts/train.py Origo-Flat

# 回放（--agent zero 只看参考动作）
python scripts/play.py Origo-Flat --agent zero
```

> 具体命令以各子仓库 README 为准；本仓库不提供 `make` / `uv run` 之类的统一入口。

---

## 文档

| 文档 | 内容 |
|---|---|
| [`docs/architecture.md`](docs/architecture.md) | 系统架构与数据流 |
| [`docs/naming.md`](docs/naming.md) | 命名规范 |

---

## 贡献

Origo 由社区共同建设。贡献前请先阅读：

- [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md) — 第三方组件与许可证

**模块级问题反馈和代码贡献请前往对应的子仓库。** 本仓库的 Issue / PR 用于
聚合层工作：根目录文档、仓库链接与元数据；跨仓库 CI、打包、分发与快照聚合在
[`origo-pipeline`](https://github.com/origo-robotics/origo-pipeline)。

---

## 许可证

本项目采用 [Apache License 2.0](LICENSE)。

第三方组件及其许可证见 [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md)。
