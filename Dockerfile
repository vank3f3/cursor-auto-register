FROM python:3.11-slim

WORKDIR /app

# 安装系统依赖，包括Chrome浏览器和其他必要的包
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    xvfb \
    procps \
    locales \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 安装Playwright的浏览器
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# 复制项目文件
COPY . .

# 创建数据目录并设置权限
RUN mkdir -p /app/data && \
    touch /app/data/accounts.db && \
    touch /app/api.log && \
    chmod 777 /app/data && \
    chmod 666 /app/data/accounts.db && \
    chmod 666 /app/api.log

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt && \
    python -m playwright install chromium

# 设置环境变量
ENV PYTHONUNBUFFERED=1
ENV BROWSER_HEADLESS=True
ENV DATABASE_URL="sqlite+aiosqlite:///./data/accounts.db"
ENV BROWSER_PATH="/ms-playwright/chromium-1097/chrome-linux/chrome"

# 设置Chrome浏览器启动参数
ENV DRISSION_NO_SANDBOX=True
ENV DRISSION_HEADLESS=True
ENV DRISSION_DISABLE_GPU=True
ENV DRISSION_DISABLE_DEV_SHM_USAGE=True

# 设置默认命令
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]