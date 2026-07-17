# EndlessPixel-Player-Image

EP 服务器玩家截图资源仓库，存放游戏内高清截图素材。

## 目录结构
```
├── assets/         # 所有截图图片文件
└── assets.json     # 图片索引配置文件
```

## 用途
为 EndlessPixel 相关项目、插件、展示页面提供远程图片静态资源加载。

## 外部调用

通过 GitHub Raw 直链读取 `assets.json` 与图片资源。

```
https://raw.githubusercontent.com/EndlessPixel/EndlessPixel-Player-Image/main/assets.json
```

```
https://raw.githubusercontent.com/EndlessPixel/EndlessPixel-Player-Image/main/assets/图片名.png
```

## 如何上传图片
请参考：[https://wiki.endlesspixel.cn/dev/image_upload](https://wiki.endlesspixel.cn/dev/image_upload)

## API接口
请参考：[https://wiki.endlesspixel.cn/dev/api_docs/api#查询EndlessPixel服务器玩家游戏截图列表](https://wiki.endlesspixel.cn/dev/api_docs/api#%E6%9F%A5%E8%AF%A2endlesspixel%E6%9C%8D%E5%8A%A1%E5%99%A8%E7%8E%A9%E5%AE%B6%E6%B8%B8%E6%88%8F%E6%88%AA%E5%9B%BE%E5%88%97%E8%A1%A8)