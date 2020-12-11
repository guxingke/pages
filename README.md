# Pages

超轻量级的静态内容生成工具, 通过组合一些命令行工具构建而成。

- 项目站点 [Pages](https://www.guxingke.com/pages/)。
- 实例站点 [Guxingke](https://www.guxingke.com)。

# 功能

- 博客
- 静态 HTML 部署
- Wiki 知识库
- 自定义主题
- 自定义所有流程

# 快速开始(macos 用户)

### 安装依赖

```bash
# jq 工具，处理 json
brew install jq

# yq 工具，处理 yaml
brew install python-yq

# sed ，使用 gnu-sed 而不是 macos 自带的。注意修改 PATH 
# PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
brew install gnu-sed

# pandoc , 用来实现 markdown 转 html , 核心工具
brew install pandoc
```

### 项目初始化

- Clone 或者下载当前项目的源码

```bash
wget 'https://github.com/guxingke/pages/archive/master.zip'
unzip master.zip
mv master/pages-master pages
cd pages
```

- 本地预览

```bash
make serve
```

- 清除并重新构建

```bash
make clean && make
```

# 更多功能

- [ ] rss 支持
- [ ] 搜索支持


# CHANGELOG

- 基本可用