# Docker 部署指南

本文档提供如何使用 Docker 和 Docker Compose 部署 Cursor Auto Register 项目的指南。

## 前提条件

- [Docker](https://docs.docker.com/get-docker/) 已安装
- [Docker Compose](https://docs.docker.com/compose/install/) 已安装

## 部署步骤

### 1. 准备环境变量配置

在项目根目录下创建 `.env` 文件（可以基于 `.env.example` 修改）：

```bash
cp .env.example .env
```

然后根据需要编辑 `.env` 文件，配置必要的参数：

- `EMAIL_DOMAINS`: 你的邮箱域名
- `EMAIL_USERNAME`: 临时邮箱用户名
- 其他必要的配置

注意：

- 确保 `BROWSER_HEADLESS=True`，这在Docker环境中是必须的
- `DATABASE_URL` 应保持为 `sqlite+aiosqlite:///./data/accounts.db`

### 2. 创建必要的目录

确保在项目根目录下创建必要的数据目录：

```bash
mkdir -p data
chmod 777 data
```

### 3. 构建和启动容器

在项目根目录执行以下命令启动服务：

```bash
docker-compose up -d
```

这将在后台构建并启动容器。首次构建可能需要几分钟时间。

### 4. 查看日志

要查看应用日志，执行：

```bash
docker-compose logs -f
```

或者直接查看挂载的日志文件：

```bash
tail -f api.log
```

### 5. 验证部署

服务启动后，可以访问以下URL：

- 用户界面: http://localhost:8000/
- API文档: http://localhost:8000/docs
- 健康检查: http://localhost:8000/health

### 6. 停止服务

要停止服务，执行：

```bash
docker-compose down
```

## 数据持久化

- 数据目录 `data` 已通过卷挂载，会保存在宿主机上
- 数据库文件 `data/accounts.db` 会保存在数据目录中
- 日志文件 `api.log` 已通过卷挂载，会保存在宿主机上
- 环境配置 `.env` 已通过卷挂载，可以直接在宿主机上修改

## 常见问题排查

### 服务无法启动

检查日志：

```bash
docker-compose logs
```

如果出现与数据库相关的错误，请确保：
1. 已创建 `data` 目录
2. 目录具有适当的权限（chmod 777 data）
3. 环境变量 DATABASE_URL 指向正确的路径

### 浏览器相关问题

确保Dockerfile中安装了所有必要的浏览器依赖，可能需要根据不同的系统环境调整依赖项。

### 网络问题

如果需要使用代理，请在 `.env` 文件中配置 `BROWSER_PROXY`。

## 更新部署

如果代码有更新，执行以下命令重新构建并部署：

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
``` 