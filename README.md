# BetterChannel
怀旧服聊天频道过滤器



## 主要功能

* 对玩家刷屏行为限流, 默认 1 分钟一条, 暂时不可修改, 后续考虑提供修改方式
* 支持用户名屏蔽, 突破 BLZ 用户名屏蔽数量限制
* 支持关键词屏蔽
* 支持正则表达式屏蔽(WIP)
* 支持特定频道的用户名, 关键词屏蔽和正则表达式(WIP)
* 支持账号下多角色共享的屏蔽列表



## 下载

[下载地址](https://github.com/ta7sudan/BetterChannel/releases), 看不懂的点[这里](https://codeload.github.com/ta7sudan/BetterChannel/zip/v0.1.1)



## 使用方式

解压到 `$WOW_HOME/_classic_/Interface/AddOns` 目录下, 修改解压后的目录名为 `BetterChannel` 即可, 即 `BetterChannel-0.1.1` 重命名为 `BetterChannel`.



### 屏蔽用户

```
/au <用户名> [-u][-g]
```

eg. 屏蔽用户名为 Ceaty 的玩家

```
/au Ceaty
```

如果需要仅在当前角色屏蔽该玩家, 使用方式如下

```
/au Ceaty -u
```

如果需要在所有角色下都屏蔽该玩家, 如下

```
/au Ceaty -g
```

*注意: **默认在所有角色下都屏蔽该玩家, 即可以不加 `-g` 选项***



### 解除用户屏蔽

```
/du <用户名> [-u][-g]
```

eg. 解除对用户名为 Ceaty 的玩家的屏蔽

```
/du Ceaty
```

如果需要仅在当前角色解除对该玩家的屏蔽, 使用方式如下

```
/du Ceaty -u
```

如果需要在所有角色都解除对该玩家的屏蔽, 如下

```
/du Ceaty -g
```

*注意: **默认在所有角色下都解除该玩家的屏蔽, 即可以不加 `-g` 选项***



### 显示已屏蔽的玩家

```
/lsu
```



### 屏蔽关键词

```
/aw <关键词> [-u][-g]
```

eg. 屏蔽关键词**大米**

```
/aw 大米
```

如果需要仅在当前角色屏蔽该关键词, 使用方式如下

```
/aw 大米 -u
```

如果需要在所有角色下都屏蔽该关键词, 如下

```
/aw 大米 -g
```

*注意: **默认在所有角色下都屏蔽该关键词, 即可以不加 `-g` 选项***



### 解除关键词屏蔽

```
/dw <关键词> [-u][-g]
```

eg. 解除屏蔽的关键词**大米**

```
/dw 大米
```

如果需要仅在当前角色解除对该关键词的屏蔽, 使用方式如下

```
/dw 大米 -u
```

如果需要在所有角色下都解除对该关键词的屏蔽, 如下

```
/dw 大米 -g
```

*注意: **默认在所有角色下都解除对该关键词的屏蔽, 即可以不加 `-g` 选项***



### 显示已屏蔽的关键词

```
/lsw
```



## TODO

* 增加正则表达式过滤
* 增加特定频道下过滤



## Q&A

* Q: 遇到火星文的名字怎么办?

  A: 考虑到大部分玩家都是用大脚, 则可以右键复制玩家名字, 其他自行解决

* Q: 为什么你不直接在右键菜单增加用户名的屏蔽功能?

  A: 因为我不会