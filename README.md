# プチ電車シリーズ - The Daiso Petit Train - ザ・ダイソー

[![Netlify Status](https://api.netlify.com/api/v1/badges/87358614-82ad-4828-8182-14279c775df3/deploy-status)](https://app.netlify.com/sites/puchi/deploys)

Petit Train is a cheap railway toy made by LEC, Inc. (http://lecinc.info/) and sold at 100 yen shops of Daiso (ザ・ダイソー). The Japanese name is プチ電車 ("puchi densha"). It is based on three-car trains running on plastic rails. The middle car has the engine that run on asingle AA battery. This is the official video: https://www.youtube.com/watch?v=AVJfzkGycLo.

## [Site](http://puchi.guupa.com/)

## Getting started

If you don't already have `elm` and `elm-live`:

```
$ npm install -g elm elm-live
```

Then, to build everything:

```
$ elm-live --dir=docs --output=docs/main.js src/main.elm --pushstate --open --debug
```
Then open http://localhost:8000


(Leave off the `--debug` if you don't want the time-traveling debugger.)

* [Code](https://github.com/lucamug/elm-petit-train-puchi-densha)

## To deploy

```
$ cd docs
$ surge
```
