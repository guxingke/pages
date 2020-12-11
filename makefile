DIST_DIR := docs
META_DIR := meta
SRC_DIR := src
STATIC_DIR := static

THEME := default
HIGHLIGHT := breezedark

THEME_DIR = templates/$(THEME)

# 静态文件
STATIC_FILE_SRC = $(wildcard $(STATIC_DIR)/*)
STATIC_FILE_OBJ = $(patsubst $(STATIC_DIR)%,$(DIST_DIR)%, $(patsubst %, %, $(STATIC_FILE_SRC)))

# 二级目录静态文件
STATIC_SUB_DIR_FILE_SRC = $(wildcard $(STATIC_DIR)/*/*)
STATIC_SUB_DIR_FILE_OBJ = $(patsubst $(STATIC_DIR)%,$(DIST_DIR)%, $(patsubst %, %, $(STATIC_SUB_DIR_FILE_SRC)))

# 主题资源文件
THEME_FILE_SRC = $(wildcard $(THEME_DIR)/assets/*)
THEME_FILE_OBJ = $(patsubst $(THEME_DIR)%,$(DIST_DIR)%, $(patsubst %, %, $(THEME_FILE_SRC)))

# md 源文件
SOURCES = $(wildcard $(SRC_DIR)/*/*.md)
OBJECTS = $(patsubst $(SRC_DIR)%,$(DIST_DIR)%, $(patsubst %.md,%.html, $(SOURCES)))
META_OBJS = $(patsubst $(SRC_DIR)%,$(META_DIR)%, $(patsubst %.md,%.yml, $(SOURCES)))

# end ========== 变量定义

all: static meta layout home objs

# 静态文件
static: $(STATIC_FILE_OBJ) $(STATIC_SUB_DIR_FILE_OBJ) $(THEME_FILE_OBJ)

# 静态文件构建，目录 -> 创建，文件 -> 复制
$(DIST_DIR)/%: $(STATIC_DIR)/%
	@if test -d $< ; then mkdir -p $@; else cp $< $@ ; fi;

# 主题资源文件
$(DIST_DIR)/%: $(THEME_DIR)/%
	@[[ -d $(DIST_DIR)/assets ]] || mkdir -p $(DIST_DIR)/assets
	@cp $< $@

# end

# meta
meta: $(META_OBJS) meta/objs.yml

$(META_DIR)/%.yml: $(SRC_DIR)/%.md
	@echo build meta ... $< $@ $*
	@sh helper build_meta $< $@ $*

meta/objs.yml: $(META_OBJS)
	@sh helper build_objs_meta $^

# end

# 布局
layout: $(DIST_DIR)/header.html $(DIST_DIR)/before.html $(DIST_DIR)/after.html

$(DIST_DIR)/before.html: templates/${THEME}/before.template basic.yml $(SRC_DIR)/index.md
	@pandoc --template=$< --from markdown --metadata-file basic.yml $(SRC_DIR)/index.md -s -o $@

$(DIST_DIR)/after.html: templates/${THEME}/after.template basic.yml $(SRC_DIR)/index.md
	@pandoc --template=$< --from markdown --metadata-file basic.yml $(SRC_DIR)/index.md -s -o $@

$(DIST_DIR)/header.html: templates/${THEME}/header.template basic.yml $(SRC_DIR)/index.md
	@pandoc --template=$< --from markdown --metadata-file basic.yml $(SRC_DIR)/index.md -s -o $@
# obj
$(DIST_DIR)/%.html: $(SRC_DIR)/%.md $(META_DIR)/%.yml $(META_DIR)/objs.yml
	@echo build html ... ${HIGHLIGHT} ${THEME} ${DIST_DIR} $< $@ ${*}
	@sh helper build_obj ${HIGHLIGHT} ${THEME} ${DIST_DIR} $< $@ ${*}

# end

# 首页
home: $(DIST_DIR)/index.html $(DIST_DIR)/wiki/index.html

$(DIST_DIR)/index.html: templates/${THEME}/index.template basic.yml meta/objs.yml $(SRC_DIR)/index.md ${DIST_DIR}/header.html ${DIST_DIR}/before.html ${DIST_DIR}/after.html
	@pandoc --template=$< --from markdown --metadata-file basic.yml --metadata-file meta/objs.yml -H $(DIST_DIR)/header.html -B $(DIST_DIR)/before.html -A $(DIST_DIR)/after.html $(SRC_DIR)/index.md -s -o $@

$(DIST_DIR)/wiki/index.html: templates/${THEME}/page.template basic.yml meta/objs.yml ${DIST_DIR}/header.html ${DIST_DIR}/before.html ${DIST_DIR}/after.html $(SRC_DIR)/readme.md
	@[[ -d $(DIST_DIR)/wiki ]] || mkdir -p $(DIST_DIR)/wiki
	@cat $(SRC_DIR)/readme.md | sed -E 's/\((.*).md/(\/\1\.html/g' | pandoc --template=$< --from markdown --metadata-file basic.yml --metadata-file meta/objs.yml -H $(DIST_DIR)/header.html -B $(DIST_DIR)/before.html -A $(DIST_DIR)/after.html --toc -s -o $@
# end

objs: $(OBJECTS)
# end

# ======================== 构建结束

# 本地预览, 依赖 python3
serve: all
	@echo Preview on http://localhost:8000
	@echo 
	@open 'http://localhost:8000/'
	@python3 -m http.server --directory $(DIST_DIR)

# 本地监听目录文件变化，自动构建，依赖 fswatch , chrome-cli (用来 reload 当前 chrome active tab)
watch:
	@fswatch -o -l 3 src | xargs -I{} ./helper watch

# 部署到 github
deploy:
	@git add .
	@git commit -m ':sparkles: .'
	@git push -u origin master

# 清理构建
clean:
	@rm -rf $(DIST_DIR)/*
	@rm -rf $(META_DIR)/*

.PHONY: clean serve deploy pages posts resources home all objects
