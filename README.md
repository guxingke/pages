# Pages

超轻量级的静态内容生成工具, 通过组合一些命令行工具构建而成。

- 项目站点 [Pages](https://www.guxingke.com/pages/)。
- 实例站点 [Guxingke](https://www.guxingke.com)。

核心逻辑在 [makefile](makefile) 和 [helper](helper) 文件内，不超过 200 行。

# 功能

- 博客
- 静态 HTML 部署
- Wiki 知识库
- 自定义主题
- 自定义所有流程

# 快速开始(macos 用户)

## 安装依赖

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

## 项目初始化

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

# 进阶功能

## 并行构建

项目基于 make 和 Makefile，并对并行构建进行了支持。

```bash
make -j 12 
```

解决全量构建时的速度问题

## 增量实时构建

watch 增量实时构建，并刷新当前 Chrome 的活动 Tab，基于 fswatch 在写入 3 秒后进行构建, 构建完成后通过 `chrome-cli` 刷新活动 tab （配合 make serve 使用）

## 切换主题

自带三主题，默认为 default。

```bash
make THEME=basic -j 12
```

使用主题 basic 进行构建。

## 集成 disqus 评论

只需反注释 `basic.yml` 文件中的 disqus 部分，配置 shortname 后重新构建即可。

# 更多功能

- [ ] rss 支持
- [ ] 搜索支持


# 实现原理

## pandoc 转换工具

- pandoc 支持模板
- pandoc 支持读取 yaml 文件作为元信息
- pandoc 支持 include 文件

## make 构建

make 默认增量构建


# CHANGELOG

- 基本可用