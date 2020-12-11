---
title: 文本处理之 sed
date: 2020-12-10 19:22:00
---

## 常用操作

- 正则替换

```bash
echo "[test](test.md)" | sed -E 's/\((.*).md/(\/\1\.html/g' 
# [test](/test.html)
```

这是当前站点用来替换路径的脚本

## 参考

- [SED 简明教程](https://coolshell.cn/articles/9104.html)