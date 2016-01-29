# Quick Start

## Installation

Install `j3.js` in root directory and just insert `script` tag into html document.

```html
<script type="text/javascript" src="j3.js"></script>
```

> *Note:*
>
> jThree is under development. So built file has not supplied yet. Check out how to build.


## How to build

Run command below.

```
npm install
npm run build
```

If build is succeeded, built files are outputed inside `/jThree/bin/product`.


# Guide

## Getting Started

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

# Tips

Comming soon...
