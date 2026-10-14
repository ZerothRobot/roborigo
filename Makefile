# Origo — 统一命令入口
#
# 本 Makefile 是项目唯一的命令入口。所有常用操作都应在这里暴露，
# 而不是散落在各子仓库的 README 里。

SHELL := /bin/bash
.DEFAULT_GOAL := help

DESCRIPTION := origo-description
RETARGET    := origo-retarget
RL_MJLAB    := origo-rl-mjlab
RL_ISAACLAB := origo-rl-isaaclab

# 子仓库列表（顺序即依赖顺序）
REPOS := $(DESCRIPTION) $(RETARGET) $(RL_MJLAB) $(RL_ISAACLAB)

.PHONY: help
help: ## 显示本帮助
	@echo "Origo — 可用命令："
	@echo
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo

# ---------------------------------------------------------------- 环境

.PHONY: init
init: ## 拉齐所有子仓库（submodule）
	git submodule update --init --recursive

.PHONY: sync
sync: ## 安装/同步全部依赖
	uv sync

.PHONY: link
link: ## 将 origo-description 资产链到各消费方期望的路径
	@for r in $(RETARGET) $(RL_MJLAB) $(RL_ISAACLAB); do \
		if [ -f $$r/Makefile ] && grep -q '^link:' $$r/Makefile; then \
			echo "==> $$r"; $(MAKE) -C $$r link; \
		fi; \
	done

# ---------------------------------------------------------------- 训练与仿真

.PHONY: train
train: ## 训练策略（默认后端：mjlab）
	uv run --project $(RL_MJLAB) train Origo-Flat --env.scene.num-envs 4096

.PHONY: train-isaaclab
train-isaaclab: ## 训练策略（后端：Isaac Lab）
	uv run --project $(RL_ISAACLAB) train Origo-Flat

.PHONY: play
play: ## 可视化已训练的策略
	uv run --project $(RL_MJLAB) play Origo-Flat

.PHONY: sim
sim: ## 起仿真环境
	uv run --project $(RL_MJLAB) play Origo-Flat --no-checkpoint

# ---------------------------------------------------------------- 重定向

.PHONY: retarget
retarget: ## 人体动作重定向（用法：make retarget INPUT=xxx.npz OUTPUT=yyy.csv）
	@test -n "$(INPUT)" || { echo "错误：需要 INPUT=<动作文件>"; exit 1; }
	uv run --project $(RETARGET) origo retarget \
		--robot origo --input $(INPUT) --output $(OUTPUT)

# ---------------------------------------------------------------- 部署

.PHONY: deploy
deploy: ## 将策略部署到实机
	uv run --project origo-deploy origo deploy --policy $(POLICY)

# ---------------------------------------------------------------- 校验

.PHONY: check
check: ## 校验机器人描述（URDF / MJCF 一致性）
	uv run --project $(DESCRIPTION) python -m origo_description.validate

.PHONY: test
test: ## 跑全部测试
	@for r in $(REPOS); do \
		if [ -d $$r/tests ]; then echo "==> $$r"; $(MAKE) -C $$r test || exit 1; fi; \
	done

.PHONY: lint
lint: ## 代码检查
	pre-commit run --all-files

# ---------------------------------------------------------------- 维护

.PHONY: status
status: ## 查看各子仓库状态
	@echo "工作区：$$(pwd)"
	@echo
	@for r in $(REPOS) origo-hardware origo-appearance origo-navigation origo-pipeline; do \
		if [ -d $$r/.git ]; then \
			printf "  %-22s %s\n" "$$r" "$$(git -C $$r rev-parse --short HEAD 2>/dev/null) $$(git -C $$r status --porcelain | wc -l) 处改动"; \
		else \
			printf "  %-22s %s\n" "$$r" "（未初始化）"; \
		fi; \
	done

.PHONY: update
update: ## 将所有子仓库更新到远端最新
	git submodule update --remote --merge

.PHONY: clean
clean: ## 清理构建产物
	rm -rf .venv **/__pycache__ **/.pytest_cache **/.ruff_cache
