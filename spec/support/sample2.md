---
title: サンプルマークダウン
category:
  - Markdown
  - Sample
updated: '2020-05-10T18:30:30'
hatena:
  image:
    sample01.png:
      syntax: "[f:id:hoge:11111111111111p:plain]"
      id: tag:hatena.ne.jp,2005:fotolife-hoge-11111111111111
      image_url: https://cdn-ak.f.st-hatena.com/images/fotolife/s/hoge/20200509/20200509150000.png
    sample02.png:
      syntax: "[f:id:hoge:22222222222222p:plain]"
      id: tag:hatena.ne.jp,2005:fotolife-hoge-22222222222222
      image_url: https://cdn-ak.f.st-hatena.com/images/fotolife/s/hoge/20200509/20200509150001.png
  id: '11111111111111111'
---

## code block
### back quote

`hoge fuga`

### multiline code block

```typescript
type HogeProps = <ComponentProps<typeof Hoge>>
type PartialP2 = Partial<Pick<HogeProps, 'p2'>>
type Props = HogeProps & PartialP2
```

## image

- image1

![alt](sample01.png)

- image2

![alt](sample02.png)

- via http

![alt](http://dummyimage.com/570×295)

## title3

## title4

<!-- textlint-disable ja-technical-writing/ja-no-weak-phrase -->
まるだと思います
<!-- textlint-enable ja-technical-writing/ja-no-weak-phrase -->

おわり
