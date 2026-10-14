# 系统架构

本文件描述 Origo 的仓库划分、数据流，以及跨仓库协作的机制。

---

## 1. 仓库划分原则

**按职责切分。**

每个仓库有一个明确的、可用一句话说清的职责。判断一个改动该放哪里，以**职责**为准。

### 唯一的例外：两个 RL 后端

`origo-rl-mjlab` 和 `origo-rl-isaaclab` 是按**仿真后端**切分的。这是有意为之：

- 两者的训练目标相同（同一台机器人、同类任务）
- 依赖栈各自独立（MuJoCo-Warp vs Isaac Sim），分别置于独立环境
- 后端名称是它们的**区分轴**，因此进入仓库名是合理的

---

## 2. 依赖关系

```
                     origo-description        ★ 权威来源
                  （URDF / MJCF / USD / 网格 /
                    关节定义 / 执行器参数）
                              │
        ┌─────────────────────┼─────────────────────┬──────────────────┐
        ▼                     ▼                     ▼                  ▼
  origo-retarget       origo-rl-mjlab       origo-rl-isaaclab    origo-deploy
  人体动作重定向        后端 A 训练           后端 B 训练          策略部署
        │                     │                     │                  │
        └─────────────────────┴─────────────────────┴──────────────────┘
                              ▼
                            origo
                  （聚合入口：文档 / 仓库索引）
```

### 核心约束

> **`origo-description` 是机器人描述的权威来源。**
> 同一参数出现多个取值时，以它为准。

这样做的收益是：关节顺序、执行器增益与限位始终有一个可对照的取值，
训练与部署出现差异时可以直接复核定位。

---

## 3. 数据流

```
① 人体动作源（SMPL-X / LAFAN1 / BVH / 视频）
        │
        ▼
② origo-retarget ── 逆运动学重定向 ──▶ 机器人关节轨迹
        │                                    │
        │                          （关节名与顺序来自 origo-description）
        ▼
③ 训练后端（mjlab 或 Isaac Lab）
        │   · 从 origo-description 取 MJCF + 关节 + 执行器参数
        │   · 从 ② 取参考动作
        ▼
   策略 checkpoint
        │
        ▼
④ 导出为部署格式（ONNX / kinfer）
        │
        ▼
⑤ origo-deploy ── 实机推理 ──▶ 关节指令
                                     │
                          （执行器参数、限位来自 origo-description）
```

**可以看到：`origo-description` 在 ②③⑤ 三处被消费。**

---

## 4. 跨仓库协作机制

### 现阶段：平级目录

工作区不使用 submodule：各仓库是平级、独立的 git 仓库。

```
<工作区根>/
├── origo/
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

| 消费方 | 目前持有描述的方式 |
|---|---|
| `origo-description` | 权威来源本身 |
| `origo-retarget` | 本地副本 `asset/robot/origo/` |
| `origo-rl-mjlab` | 本地副本 `src/origo_rl_mjlab/assets/robots/origo/` + `origo_constants.py` |
| `origo-rl-isaaclab` | 本地副本 `source/origo/origo/assets/origo/` |

各仓库如何引用机器人描述由自己决定——截至当前，没有任何仓库把
`origo-description` 写进自己的依赖声明。

**submodule 推迟到开源阶段**——它解决的是"社区用户一次 clone 拿到全部资源"
的便利性问题。

### 目录链接策略

某些消费方（如 Isaac Lab 扩展）要求资产位于**固定路径**。
处理原则：

| 做法 | 结论 |
|---|---|
| **本地生成** symlink，并加入 `.gitignore` | ✅ 可用 |
| 把 symlink **提交进 git** | ❌ 请改用本地生成——git 中的 symlink 只是路径字符串，clone 后即断链，CI 上会暴露该问题 |

```bash
# 在需要该路径的仓库内执行；源取 origo-description 的资产目录
mkdir -p assets
ln -sfn "$(python -c 'import origo_description as d; print(d.asset_root())')" assets/origo
```

**symlink 采用本地生成是好工具；提交进 git 后会让 CI 在 clone 后断链。**

---

## 5. 技术栈

| 层 | 选型 |
|---|---|
| 机器人描述 | URDF（源）+ MJCF（MuJoCo）+ USD（Isaac） |
| 物理仿真 | MuJoCo / MuJoCo-Warp；Isaac Sim / Isaac Lab |
| RL 算法 | PPO（RSL-RL） |
| 动作重定向 | 逆运动学（mink + MuJoCo） |
| 部署运行时 | ONNX Runtime（`origo-deploy` 的设计目标，代码尚未落盘） |
| 包管理 | conda / pip（`uv pip` 亦可） |
| 语言 | Python 3.10+；部署侧计划 C++17 |

---

## 6. 与外部框架的边界

Origo **优先依赖**框架，而不是把框架代码复制进仓库：一旦复制进来，
就永久承担了它的升级合并成本，上游框架的每个版本更新都会变成手工合并。

| 框架 | 关系 |
|---|---|
| mjlab | 依赖（PyPI，钉版 `mjlab==1.2.0`） |
| Isaac Lab | 依赖（外部安装） |
| MuJoCo / MuJoCo-Warp | 依赖 |
| RSL-RL | 依赖。例外：`origo-rl-mjlab/src/rsl_rl_amp/` 是 rsl_rl 2.3.1 的**内嵌副本**（AMP 需要隔离改动），升级时需手工合并 |
| BeyondMimic（whole_body_tracking） | 例外：`origo-rl-isaaclab` 的动作跟踪任务派生自它，代码已内嵌 |

Origo 自己的代码只包含：任务定义、环境配置、机器人描述、部署栈。
