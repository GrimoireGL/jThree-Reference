# jThree
[![Slack Status](https://jthree-slackin.herokuapp.com/badge.svg)](https://jthree-slackin.herokuapp.com/)
[![Build Status](https://travis-ci.org/jThreeJS/jThree.svg?branch=develop)](https://travis-ci.org/jThreeJS/jThree)
[![LICENSE](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/jThreeJS/jThree/blob/develop/LICENSE)
[![Dependency Status](https://david-dm.org/jThreeJS/jThree.svg)](https://david-dm.org/jThreeJS/jThree)
[![devDependency Status](https://david-dm.org/jThreeJS/jThree/dev-status.svg)](https://david-dm.org/jThreeJS/jThree#info=devDependencies)
## What is jThree?

jThree is an innovative 3D graphics engine. It may seem to be just a javascript library.
However, jThree will enable browser to use most of the feature as other game engines do in local environment, plugins features,hierarchies,templates,module systems.


### Purposes

* Provide a good learning resource for the beginners to know how programming is awesome via this library.
* Sharing features that will be achieved easily by this library implemented with javascript.
* Redefine legacies of 3DCG technologies on the Internet.
* Have Enjoyable contributions :heart:


### Dependencies

This library depends on the following libraries. We appreciate these contributors below :heart:

|Name|Purpose|URL|Memo|
|:-:|:-:|:-:|:-:|
|gl-matrix|Use for calculation for webgl|https://github.com/toji/gl-matrix||


## Contributions

Thank you for your interest in contributions!   :kissing_smiling_eyes:


### Installation to build

You need the applications below.
* node.js
* npm

You need **not** to install any packages in global.

You need to run the command below to install npm packages,bower packages,and so on in local environment.

```shell
npm install
```

**That is all you need to do for preparation!**

Then, run the command below to build "j3.js"

```shell
npm run build
```

|command|description|
|:-:|:-:|
|npm run build|build "j3.js"|
|npm run test|run test|
|npm run watch|watch files for build and run simple web server(under wwwroot)|
|npm start|only run simple web server(under wwwroot)|

(simple web server supported LiveReload)

## Quick Start

### Installation

Install `j3.js` in root directory and just insert `script` tag into html document.

```html
<script type="text/javascript" src="j3.js"></script>
```

> *Note:*
>
> jThree is under development. So built file has not supplied yet. Check out how to build.


### How to build

Run command below.

```
npm install
npm run build
```

If build is succeeded, built files are outputed inside `/jThree/bin/product`.


## Guide

### Getting Started

Look at this simple example.

```
<!DOCTYPE html>
<html>
<head>
  <script type="text/goml">
    <goml>
      <resources>
        <cube name="cube" />
      </resources>
      <canvases>
        <canvas clearColor="purple" frame=".canvasContainer">
          <viewport cam="CAM1" id="main" width="640" height="480" name="MAIN"/>
        </canvas>
      </canvases>
      <scenes>
        <scene name="mainScene">
          <object rotation="y(30d)">
            <camera id="maincam" aspect="1" far="20" fovy="1/2p" name="CAM1" near="0.1" position="(0,8,10)" rotation="x(-30d)"></camera>
          </object>
          <scenelight color="#FFF" intensity="1"  top="40"  far="50" right="50" position="-10,-10,10"/>
          <mesh id="cube" geo="cube" mat="red"/>
        </scene>
      </scenes>
    </goml>
  </script>
</head>
<body>
</body>
</html>
```

Comming soon...

