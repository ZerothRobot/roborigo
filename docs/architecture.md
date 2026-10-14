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
                  （聚合入口：文档 / 流水线 / 统一命令 / 快照）
```

### 核心约束

> **`origo-description` 是机器人描述的权威来源。**
> 同一参数出现多个取值时，以它为准。

这条约束带来实际的收益：关节顺序、执行器增益与限位始终有一个可对照的取值，
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

### 现阶段：平级目录 + Python 包依赖

```
<工作区根>/
├── origo/
├── origo-description/
├── origo-retarget/
├── origo-rl-mjlab/
└── origo-rl-isaaclab/
```

各仓库通过 **Python 包依赖**互相引用，代码在工作区中保持单一副本：

```toml
# origo-rl-mjlab/pyproject.toml
[project]
dependencies = ["origo-description"]

[tool.uv.sources]
origo-description = { path = "../origo-description", editable = true }
```

**现阶段选择包依赖的理由**：

- submodule 会让每个子仓库各自携带一份完整历史，本地磁盘占用成倍增长
- 当前的改进重点是把**机器人描述在多个仓库的重复**收敛为一处（每份含大量 USD/网格资产），
  submodule 会加剧这一重复
- 包依赖能做到零重复，且版本可钉（发布构建时改用 `origo-description==1.0.0`）

**submodule 推迟到开源阶段**——它解决的是"社区用户一次 clone 拿到全部资源"
的便利性问题，正确性已由包依赖保证。

### 目录链接策略

某些消费方（Isaac Lab 扩展、GMR 资产目录）要求资产位于**固定路径**。
处理原则：

| 做法 | 结论 |
|---|---|
| 用 `make link` **本地生成** symlink，并加入 `.gitignore` | ✅ 推荐 |
| 把 symlink **提交进 git** | ❌ 请改用本地生成——git 中的 symlink 只是路径字符串，clone 后即断链，CI 上会暴露该问题 |

```makefile
link:
	@mkdir -p assets
	@ln -sfn $$(python -c "import origo_description as d; print(d.asset_root())") assets/origo
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
| 部署运行时 | ONNX Runtime |
| 包管理 | uv |
| 语言 | Python 3.10+；部署侧 C++17 |

---

## 6. 与外部框架的边界

Origo **依赖**框架，框架代码统一通过依赖获取。

| 框架 | 关系 |
|---|---|
| mjlab | 依赖（PyPI / 源码安装），代码通过依赖获取 |
| Isaac Lab | 依赖（外部安装），代码通过依赖获取 |
| MuJoCo | 依赖 |
| RSL-RL | 依赖 |

**依赖获取框架的理由**：一旦把框架代码复制进仓库，就永久承担了它的升级合并成本。
上游框架的每个版本更新都会变成手工合并。

Origo 自己的代码只包含：任务定义、环境配置、机器人描述、部署栈。
