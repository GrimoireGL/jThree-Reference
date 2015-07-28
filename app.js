(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Context, Docs, Handlebars, InitializeState, React, Root, docs, express, favicon, fs, initializeState, server, template;

if ("production" === 'development') {
  require('source-map-support').install();
}

express = require('express');

favicon = require('serve-favicon');

fs = require('fs');

Handlebars = require('handlebars');

React = require('react');

Context = require('./renderer/context');

Root = require('./renderer/components/root-component');

InitializeState = require('./server/initializeState');

Docs = require('./server/docs');

console.log("environment: " + "production");

server = express();

server.use('/static', express["static"]('public'));

server.use(favicon((fs.realpathSync('./')) + "/public/assets/favicon/favicon.ico"));

template = Handlebars.compile(fs.readFileSync((fs.realpathSync('./')) + "/view/index.hbs").toString());

docs = new Docs();

initializeState = new InitializeState(docs);

docs.getJsonScheduler(3 * 60 * 60, function() {
  return initializeState.gen();
});


/**
 * API for get doc data
 * @param  {Object} req express request object
 * @param  {Object} res express response object
 * @return {[type]}     [description]
 */

server.get('/api/class/global/:file_id/:factor_id', function(req, res) {
  console.log(req.originalUrl);
  return res.json(docs.getDocDataById(req.params.file_id, req.params.factor_id));
});


/**
 * All page view request routing is processed here
 * generate view by React server-side rendering
 * @param  {Object} req express request object
 * @param  {Object} res express response object
 */

server.get('*', function(req, res) {
  var context, initialStates;
  console.log(req.originalUrl);
  initialStates = initializeState.initialize(req);
  context = new Context(initialStates);
  return res.send(template({
    initialStates: JSON.stringify(initialStates),
    markup: React.renderToString(React.createElement(Root, {
      context: context
    }))
  }));
});

console.log('running on', 'PORT:', process.env.PORT || 5000, 'IP:', process.env.IP);

server.listen(process.env.PORT || 5000, process.env.IP);



},{"./renderer/components/root-component":37,"./renderer/context":44,"./server/docs":49,"./server/initializeState":50,"express":undefined,"fs":undefined,"handlebars":undefined,"react":undefined,"serve-favicon":undefined,"source-map-support":undefined}],2:[function(require,module,exports){
var DocAction, Flux, Promise, keys, request,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Flux = require('material-flux');

keys = require('../keys');

request = require('superagent');

Promise = require('bluebird');

DocAction = (function(superClass) {
  extend(DocAction, superClass);


  /**
   * flux action for doc
   * @return {DocAction}
   */

  function DocAction() {
    DocAction.__super__.constructor.apply(this, arguments);
  }


  /**
   * get and update doc object
   * @param  {String|Number} file_id   id of child of doc root
   * @param  {String|Number} factor_id id of grandchild of doc root
   */

  DocAction.prototype.updateDoc = function(file_id, factor_id) {
    return new Promise((function(_this) {
      return function(resolve, reject) {
        return request.get("/api/class/global/" + file_id + "/" + factor_id).end(function(err, res) {
          if (res.ok) {
            return resolve(res.body);
          } else {
            return reject(err);
          }
        });
      };
    })(this)).then((function(_this) {
      return function(res) {
        return _this.dispatch(keys.updateDoc, res);
      };
    })(this))["catch"](function(err) {
      return console.error(err);
    });
  };

  return DocAction;

})(Flux.Action);

module.exports = DocAction;



},{"../keys":45,"bluebird":undefined,"material-flux":undefined,"superagent":undefined}],3:[function(require,module,exports){
var Flux, History, RouteAction, keys,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Flux = require('material-flux');

keys = require('../keys');

History = null;

if (typeof window !== "undefined" && window !== null) {
  History = require('html5-history');
}

RouteAction = (function(superClass) {
  extend(RouteAction, superClass);


  /**
   * flux action for routing
   * @return {RouteAction}
   */

  function RouteAction() {
    RouteAction.__super__.constructor.apply(this, arguments);
    if ((History != null ? History.Adapter : void 0) != null) {
      History.Adapter.bind(window, 'statechange', (function(_this) {
        return function() {
          var state;
          state = History.getState();
          return _this.dispatch(keys.route, state.hash);
        };
      })(this));
    } else {
      if (typeof window !== "undefined" && window !== null) {
        console.warn('html5-history is not available.');
      }
    }
  }


  /**
   * route navigation
   * @param  {String} path    navigation path
   * @param  {Object} options option.silent is specifyed, only replace location bar and no page transfer
   */

  RouteAction.prototype.navigate = function(path, options) {
    if (path[0] !== '/') {
      path = document.location.pathname + "/" + (this.clearSlashes(path));
    } else {
      path = "/" + (this.clearSlashes(path));
    }
    if ((History != null ? History.Adapter : void 0) != null) {
      if ((options != null ? options.replace : void 0) === true) {
        return History.replaceState(null, null, path, void 0, options != null ? options.silent : void 0);
      } else {
        return History.pushState(null, null, path, void 0, options != null ? options.silent : void 0);
      }
    } else if (typeof location !== "undefined" && location !== null) {
      return location.href = path;
    }
  };


  /**
   * strip slashes
   * @param  {String} path
   * @return {String}      slashes striped path
   */

  RouteAction.prototype.clearSlashes = function(path) {
    return path.toString().replace(/\/$/, '').replace(/^\//, '');
  };

  return RouteAction;

})(Flux.Action);

module.exports = RouteAction;



},{"../keys":45,"html5-history":undefined,"material-flux":undefined}],4:[function(require,module,exports){
var AppComponent, ClassDocComponent, ErrorComponent, HeaderComponent, IndexComponent, Link, Radium, React, Route, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Route = require('./route-component');

Link = require('./link-component');

IndexComponent = require('./index-component');

ErrorComponent = require('./error-component');

ClassDocComponent = require('./classdoc-component');

HeaderComponent = require('./header-component');

AppComponent = (function(superClass) {
  extend(AppComponent, superClass);

  function AppComponent(props) {
    AppComponent.__super__.constructor.call(this, props);
  }

  AppComponent.prototype.handleEvent = function(e) {
    if (e.type === 'resize') {
      return this.updateMainHeight();
    }
  };

  AppComponent.prototype.updateMainHeight = function() {
    var mainHeight, minMainHeight;
    minMainHeight = 1000;
    mainHeight = document.documentElement.clientHeight - 80 >= minMainHeight ? document.documentElement.clientHeight - 80 : minMainHeight;
    return this.setState({
      mainHeight: mainHeight
    });
  };

  AppComponent.prototype.componentWillMount = function() {
    return this.setState({
      mainHeight: 0
    });
  };

  AppComponent.prototype.componentDidMount = function() {
    this.updateMainHeight();
    return window.addEventListener('resize', this);
  };

  AppComponent.prototype.componentWillUnmount = function() {
    return window.removeEventListener('resize', this);
  };

  AppComponent.prototype.render = function() {
    var dstyle;
    dstyle = {
      main: {
        height: this.state.mainHeight
      }
    };
    return React.createElement("div", {
      "style": styles.base
    }, React.createElement(Route, {
      "style": styles.header
    }, React.createElement(HeaderComponent, {
      "notroute": 'index'
    })), React.createElement(Route, null, React.createElement(IndexComponent, {
      "route": 'index'
    }), React.createElement(ClassDocComponent, {
      "route": 'class',
      "style": [styles.main, dstyle.main]
    }), React.createElement(ErrorComponent, {
      "route": 'error',
      "style": [styles.main, dstyle.main]
    })));
  };

  return AppComponent;

})(React.Component);

styles = {
  base: {
    minWidth: 1000
  },
  header: {
    position: 'fixed',
    zIndex: 100,
    height: 80,
    width: '100%',
    top: 0
  },
  main: {
    marginTop: 80
  }
};

AppComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(AppComponent);



},{"./classdoc-component":6,"./error-component":30,"./header-component":31,"./index-component":32,"./link-component":33,"./route-component":38,"radium":undefined,"react":undefined}],5:[function(require,module,exports){
var CharIconComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

CharIconComponent = (function(superClass) {
  extend(CharIconComponent, superClass);

  function CharIconComponent(props) {
    CharIconComponent.__super__.constructor.call(this, props);
  }

  CharIconComponent.prototype.render = function() {
    var dstyle, ref;
    dstyle = {};
    if (((ref = this.props.char) != null ? ref.length : void 0) >= 2) {
      dstyle.base = {
        width: 'auto',
        paddingLeft: 8,
        paddingRight: 8
      };
    }
    return React.createElement("span", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style, dstyle.base])
    }, (this.props.char != null ? React.createElement("span", null, this.props.char) : this.props.icomoon != null ? React.createElement("span", {
      "className": "icon-" + this.props.icomoon
    }) : null));
  };

  return CharIconComponent;

})(React.Component);

styles = {
  base: {
    display: 'inline-block',
    width: 18,
    height: 18,
    borderWidth: 1,
    borderStyle: 'solid',
    borderColor: '#000',
    marginTop: 4,
    marginRight: 10,
    textAlign: 'center',
    fontSize: 13
  }
};

CharIconComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(CharIconComponent);



},{"radium":undefined,"react":undefined}],6:[function(require,module,exports){
var ClassDocComponent, DocContainerComponent, DocDetailContainerComponent, DocSlideWrapperComponent, ListComponent, Radium, React, Route, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Route = require('./route-component');

ListComponent = require('./list-component');

DocContainerComponent = require('./doc-container-component');

DocDetailContainerComponent = require('./doc-detail-container-component');

DocSlideWrapperComponent = require('./doc-slide-wrapper-component');

ClassDocComponent = (function(superClass) {
  extend(ClassDocComponent, superClass);

  function ClassDocComponent(props) {
    ClassDocComponent.__super__.constructor.call(this, props);
  }

  ClassDocComponent.prototype._onChange = function() {
    return this.setState(this.store.get());
  };

  ClassDocComponent.prototype.componentWillMount = function() {
    this.store = this.context.ctx.docStore;
    return this.setState(this.store.get());
  };

  ClassDocComponent.prototype.componentDidMount = function() {
    return this.store.onChange(this._onChange.bind(this));
  };

  ClassDocComponent.prototype.componentWillUnmount = function() {
    return this.store.removeChangeListener(this._onChange.bind(this));
  };

  ClassDocComponent.prototype.render = function() {
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement("div", {
      "style": styles.list
    }, React.createElement(Route, null, React.createElement(ListComponent, {
      "dir_tree": this.state.dir_tree
    }))), React.createElement("div", {
      "style": styles.container
    }, React.createElement(Route, {
      "style": styles.doc_wrapper
    }, React.createElement(DocSlideWrapperComponent, null, React.createElement(DocContainerComponent, {
      "style": styles.doc_container,
      "doc_data": this.state.doc_data
    }), React.createElement(DocDetailContainerComponent, {
      "style": styles.doc_detail_container,
      "doc_data": this.state.doc_data
    })))));
  };

  return ClassDocComponent;

})(React.Component);

styles = {
  base: {
    display: 'flex',
    display: '-webkit-flex',
    flexDirection: 'row',
    WebkitFlexDirection: 'row',
    flexWrap: 'nowrap',
    WebkitFlexWrap: 'nowrap'
  },
  list: {
    boxSizing: 'border-box',
    paddingLeft: 10,
    paddingTop: 10,
    width: 360,
    minWidth: 360,
    borderRightWidth: 1,
    borderRightColor: '#ccc',
    borderRightStyle: 'solid',
    position: 'fixed',
    top: 80,
    height: 'calc(100% - 80px)',
    overflowY: 'scroll',
    overflowX: 'hidden',
    zIndex: 10,
    backgroundColor: '#fff'
  },
  container: {
    flexGrow: '1',
    WebkitFlexGrow: '1',
    display: 'flex',
    display: '-webkit-flex',
    flexDirection: 'column',
    WebkitFlexDirection: 'column',
    flexWrap: 'nowrap',
    WebkitFlexWrap: 'nowrap',
    marginLeft: 360
  },
  doc_wrapper: {
    display: 'flex',
    display: '-webkit-flex',
    flexDirection: 'row',
    WebkitFlexDirection: 'row',
    flexWrap: 'nowrap',
    WebkitFlexWrap: 'nowrap',
    flexGrow: '1',
    WebkitFlexGrow: '1'
  },
  doc_container: {},
  doc_detail_container: {
    flexGrow: '1',
    WebkitFlexGrow: '1'
  }
};

ClassDocComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(ClassDocComponent);



},{"./doc-container-component":8,"./doc-detail-container-component":10,"./doc-slide-wrapper-component":26,"./list-component":34,"./route-component":38,"radium":undefined,"react":undefined}],7:[function(require,module,exports){

/**
 * Color definition for components styles
 * root[category][situation][grade]
 * category: name of category
 * situation: (n|r) n is normal(background), r is reverse(font)
 * grade: (emphasis|default|moderate|light)
 * @type {Object}
 */
module.exports = {
  main: {
    n: {
      "default": '#344F6F',
      moderate: '#4D6B98',
      light: '#D5DDE9'
    },
    r: {
      emphasis: 'rgba(255, 255, 255, 0.8)',
      "default": 'rgba(255, 255, 255, 0.5)',
      moderate: 'rgba(255, 255, 255, 0.3)'
    }
  },
  general: {
    n: {
      light: 'rgb(242, 242, 242)'
    },
    r: {
      emphasis: '#000',
      "default": '#333',
      moderate: '#666',
      light: '#aaa'
    }
  },
  inverse: {
    n: {
      emphasis: '#000',
      "default": '#333',
      moderate: '#666'
    },
    r: {
      emphasis: 'rgba(255, 255, 255, 0.95)',
      "default": 'rgba(255, 255, 255, 0.7)',
      moderate: 'rgba(255, 255, 255, 0.5)'
    }
  }
};



},{}],8:[function(require,module,exports){
var DocContainerComponents, DocDescriptionComponent, DocFactorHierarchyComponent, DocFactorImplementsComponent, DocFactorItemComponent, DocFactorTitleComponent, DocSearchContainerComponent, DocTypeparameterComponent, Link, Radium, React, Route, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Route = require('./route-component');

Link = require('./link-component');

DocDescriptionComponent = require('./doc-description-component');

DocFactorTitleComponent = require('./doc-factor-title-component');

DocFactorItemComponent = require('./doc-factor-item-component');

DocFactorHierarchyComponent = require('./doc-factor-hierarchy-component');

DocFactorImplementsComponent = require('./doc-factor-implements-component');

DocTypeparameterComponent = require('./doc-typeparameter-component');

DocSearchContainerComponent = require('./doc-search-container-component');

DocContainerComponents = (function(superClass) {
  extend(DocContainerComponents, superClass);

  function DocContainerComponents(props) {
    DocContainerComponents.__super__.constructor.call(this, props);
    this.loadingQueue = [];
  }

  DocContainerComponents.prototype.close = function() {
    var ref;
    if (((ref = this.props.argu.route_arr[1]) != null ? ref.toString() : void 0) === 'local') {
      return this.context.ctx.routeAction.navigate(document.location.pathname.match(/^(.+)\/[^\/]+$/)[1]);
    }
  };

  DocContainerComponents.prototype.render = function() {
    var current, factor_id, file_id, group, i, q, ref, ref1, splice_index, text;
    file_id = (ref = this.props.argu.route_arr[2]) != null ? ref.toString() : void 0;
    factor_id = (ref1 = this.props.argu.route_arr[3]) != null ? ref1.toString() : void 0;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, ((function() {
      var j, len, ref2, ref3, ref4, ref5;
      if ((file_id != null) && (factor_id != null)) {
        current = (ref2 = this.props.doc_data[file_id]) != null ? ref2[factor_id] : void 0;
        if (current != null) {
          splice_index = null;
          ref3 = this.loadingQueue;
          for (i = j = 0, len = ref3.length; j < len; i = ++j) {
            q = ref3[i];
            if (q.file_id === file_id && q.factor_id === factor_id) {
              splice_index = i;
              break;
            }
          }
          if (splice_index != null) {
            this.loadingQueue.splice(splice_index, 1);
          }
          return React.createElement("div", null, React.createElement(DocFactorTitleComponent, {
            "current": current,
            "from": this.props.doc_data[file_id].from,
            "collapsed": this.props.collapsed
          }), (!this.props.collapsed ? (text = [(ref4 = current.comment) != null ? ref4.shortText : void 0, (ref5 = current.comment) != null ? ref5.text : void 0], React.createElement(DocDescriptionComponent, {
            "text": text
          })) : void 0), (!this.props.collapsed && (current.typeParameter != null) ? React.createElement(DocTypeparameterComponent, {
            "current": current
          }) : void 0), (!this.props.collapsed && ((current.extendedTypes != null) || (current.extendedBy != null)) ? React.createElement(DocFactorHierarchyComponent, {
            "current": current
          }) : void 0), (!this.props.collapsed && ((current.implementedTypes != null) || (current.implementedBy != null)) ? React.createElement(DocFactorImplementsComponent, {
            "current": current
          }) : void 0), ((function() {
            var k, len1, ref6, results;
            if (current.groups != null) {
              ref6 = current.groups;
              results = [];
              for (k = 0, len1 = ref6.length; k < len1; k++) {
                group = ref6[k];
                results.push(React.createElement(DocFactorItemComponent, {
                  "key": group.kind,
                  "group": group,
                  "current": current,
                  "collapsed": this.props.collapsed
                }));
              }
              return results;
            }
          }).call(this)));
        } else {
          if (typeof window !== "undefined" && window !== null) {
            if (!this.loadingQueue.some(function(q) {
              return q.file_id === file_id && q.factor_id === factor_id;
            })) {
              this.loadingQueue.push({
                file_id: file_id,
                factor_id: factor_id
              });
              this.context.ctx.docAction.updateDoc(file_id, factor_id);
            } else {

            }
          } else {
            throw new Error('doc_data must be initialized by initialStates');
          }
          return React.createElement("span", null, "Loading...");
        }
      } else {
        return React.createElement(DocSearchContainerComponent, null);
      }
    }).call(this)));
  };

  return DocContainerComponents;

})(React.Component);

styles = {
  base: {}
};

DocContainerComponents.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocContainerComponents);



},{"./doc-description-component":9,"./doc-factor-hierarchy-component":17,"./doc-factor-implements-component":18,"./doc-factor-item-component":19,"./doc-factor-title-component":21,"./doc-search-container-component":25,"./doc-typeparameter-component":29,"./link-component":33,"./route-component":38,"radium":undefined,"react":undefined}],9:[function(require,module,exports){
var DocDescriptionComponent, DocItemComponent, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocItemComponent = require('./doc-item-component');

colors = require('./colors/color-definition');


/*
@props.text (array|string) description text
 */

DocDescriptionComponent = (function(superClass) {
  extend(DocDescriptionComponent, superClass);

  function DocDescriptionComponent(props) {
    DocDescriptionComponent.__super__.constructor.call(this, props);
  }

  DocDescriptionComponent.prototype.render = function() {
    var alt_text, ref, texts;
    alt_text = 'no description';
    texts = this.props.text instanceof Array ? this.props.text : (ref = this.props.text) != null ? ref.split('\n') : void 0;
    texts = texts.some(function(t) {
      return t != null;
    }) ? texts : [alt_text];
    return React.createElement(DocItemComponent, {
      "title": 'Description',
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement("div", {
      "style": styles.content
    }, texts.map(function(t) {
      if (t != null) {
        return React.createElement("p", null, t);
      }
    })));
  };

  return DocDescriptionComponent;

})(React.Component);

styles = {
  base: {},
  content: {
    color: colors.general.r["default"]
  }
};

DocDescriptionComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocDescriptionComponent);



},{"./colors/color-definition":7,"./doc-item-component":24,"radium":undefined,"react":undefined}],10:[function(require,module,exports){
var DocDescriptionComponent, DocDetailContainerComponent, DocDetailParametersComponent, DocDetailReturnComponent, DocDetailTitleComponent, DocSlideWrapperComponent, DocTypeparameterComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocSlideWrapperComponent = require('./doc-slide-wrapper-component');

DocDescriptionComponent = require('./doc-description-component');

DocDetailTitleComponent = require('./doc-detail-title-component');

DocDetailParametersComponent = require('./doc-detail-parameters-component');

DocDetailReturnComponent = require('./doc-detail-return-components');

DocTypeparameterComponent = require('./doc-typeparameter-component');

DocDetailContainerComponent = (function(superClass) {
  extend(DocDetailContainerComponent, superClass);

  function DocDetailContainerComponent(props) {
    DocDetailContainerComponent.__super__.constructor.call(this, props);
  }

  DocDetailContainerComponent.prototype.render = function() {
    var c, current, current_local, factor_id, file_id, local_factor_id, ref, ref1, ref2, text;
    file_id = (ref = this.props.argu.route_arr[2]) != null ? ref.toString() : void 0;
    factor_id = (ref1 = this.props.argu.route_arr[3]) != null ? ref1.toString() : void 0;
    local_factor_id = (ref2 = this.props.argu.route_arr[4]) != null ? ref2.toString() : void 0;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, ((function() {
      var i, len, ref10, ref11, ref12, ref13, ref14, ref3, ref4, ref5, ref6, ref7, ref8, ref9;
      if ((file_id != null) && (factor_id != null)) {
        current = (ref3 = this.props.doc_data[file_id]) != null ? ref3[factor_id] : void 0;
        if (current != null) {
          current_local = null;
          ref4 = current.children;
          for (i = 0, len = ref4.length; i < len; i++) {
            c = ref4[i];
            if (((ref5 = c.id) != null ? ref5.toString() : void 0) === local_factor_id) {
              current_local = c;
            }
          }
          if (current_local != null) {
            text = [];
            if (current_local.signatures != null) {
              text = [(ref6 = current_local.signatures[0].comment) != null ? ref6.shortText : void 0, (ref7 = current_local.signatures[0].comment) != null ? ref7.text : void 0];
            } else if (current_local.getSignature != null) {
              text = [(ref8 = current_local.getSignature[0].comment) != null ? ref8.shortText : void 0, (ref9 = current_local.getSignature[0].comment) != null ? ref9.text : void 0];
            } else if (current_local.setSignature != null) {
              text = [(ref10 = current_local.setSignature[0].comment) != null ? ref10.shortText : void 0, (ref11 = current_local.setSignature[0].comment) != null ? ref11.text : void 0];
            } else {
              text = [(ref12 = current_local.comment) != null ? ref12.shortText : void 0, (ref13 = current_local.comment) != null ? ref13.text : void 0];
            }
            return React.createElement("div", null, React.createElement(DocDetailTitleComponent, {
              "current": current_local,
              "from": current
            }), React.createElement(DocDescriptionComponent, {
              "text": text
            }), (current_local.typeParameter != null ? React.createElement(DocTypeparameterComponent, {
              "current": current_local
            }) : void 0), (((ref14 = current_local.signatures) != null ? ref14.every(function(s) {
              return s.parameters != null;
            }) : void 0) ? React.createElement(DocDetailParametersComponent, {
              "current": current_local
            }) : void 0), ((current_local.signatures != null) || (current_local.getSignature != null) || (current_local.setSignature != null) ? React.createElement(DocDetailReturnComponent, {
              "current": current_local
            }) : void 0));
          }
        }
      }
    }).call(this)));
  };

  return DocDetailContainerComponent;

})(React.Component);

styles = {
  base: {}
};

DocDetailContainerComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocDetailContainerComponent);



},{"./doc-description-component":9,"./doc-detail-parameters-component":11,"./doc-detail-return-components":13,"./doc-detail-title-component":16,"./doc-slide-wrapper-component":26,"./doc-typeparameter-component":29,"radium":undefined,"react":undefined}],11:[function(require,module,exports){
var DocDetailParametersComponent, DocDetailParametersTableComponent, DocItemComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocDetailParametersTableComponent = require('./doc-detail-parameters-table-component');

DocItemComponent = require('./doc-item-component');


/*
@props.current [required] local current which is child of current factor
@props.style
 */

DocDetailParametersComponent = (function(superClass) {
  extend(DocDetailParametersComponent, superClass);

  function DocDetailParametersComponent(props) {
    DocDetailParametersComponent.__super__.constructor.call(this, props);
  }

  DocDetailParametersComponent.prototype.render = function() {
    return React.createElement(DocItemComponent, {
      "title": 'Parameters',
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement(DocDetailParametersTableComponent, {
      "parameters": this.props.current.signatures[0].parameters,
      "current_id": this.props.current.id,
      "style": [styles.content]
    }));
  };

  return DocDetailParametersComponent;

})(React.Component);

styles = {
  base: {},
  content: {}
};

DocDetailParametersComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocDetailParametersComponent);



},{"./doc-detail-parameters-table-component":12,"./doc-item-component":24,"radium":undefined,"react":undefined}],12:[function(require,module,exports){
var DocDetailParameterTableComponent, DocSignaturesTypeComponent, DocTableComponent, Link, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('./link-component');

DocTableComponent = require('./doc-table-component');

DocSignaturesTypeComponent = require('./signatures/doc-signatures-type-component');

colors = require('./colors/color-definition');


/*
@props.parameters [required] parameters
@props.current_id [required] current.id
@props.style
 */

DocDetailParameterTableComponent = (function(superClass) {
  extend(DocDetailParameterTableComponent, superClass);

  function DocDetailParameterTableComponent(props) {
    DocDetailParameterTableComponent.__super__.constructor.call(this, props);
  }

  DocDetailParameterTableComponent.prototype.render = function() {
    var alt_text, i, prm, table, table_row;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, ((function() {
      var j, len, ref, ref1, ref2;
      table = [];
      ref = this.props.parameters;
      for (i = j = 0, len = ref.length; j < len; i = ++j) {
        prm = ref[i];
        alt_text = 'no description';
        table_row = [];
        table_row.push(React.createElement("span", null, prm.name));
        if (prm.type != null) {
          table_row.push(React.createElement("span", {
            "style": styles.type
          }, React.createElement(DocSignaturesTypeComponent, {
            "type": prm.type,
            "emphasisStyle": styles.emphasis
          })));
        }
        table_row.push(React.createElement("span", null, ((ref1 = prm.comment) != null ? ref1.shortText : void 0) || ((ref2 = prm.comment) != null ? ref2.text : void 0) || alt_text));
        table.push(table_row);
      }
      return React.createElement(DocTableComponent, {
        "prefix": this.props.current_id + "-prm",
        "table": table
      });
    }).call(this)));
  };

  return DocDetailParameterTableComponent;

})(React.Component);

styles = {
  base: {},
  type: {
    color: colors.general.r.light
  },
  emphasis: {
    color: colors.general.r["default"]
  },
  link: {
    color: colors.general.r.emphasis,
    textDecoration: 'none',
    cursor: 'pointer',
    ':hover': {
      textDecoration: 'underline'
    }
  }
};

DocDetailParameterTableComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocDetailParameterTableComponent);



},{"./colors/color-definition":7,"./doc-table-component":27,"./link-component":33,"./signatures/doc-signatures-type-component":42,"radium":undefined,"react":undefined}],13:[function(require,module,exports){
var DocDetailReturnComponent, DocDetailReturnTableComponent, DocItemComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocDetailReturnTableComponent = require('./doc-detail-return-table-component');

DocItemComponent = require('./doc-item-component');


/*
@props.current [required] local current which is child of current factor
@props.style
 */

DocDetailReturnComponent = (function(superClass) {
  extend(DocDetailReturnComponent, superClass);

  function DocDetailReturnComponent(props) {
    DocDetailReturnComponent.__super__.constructor.call(this, props);
  }

  DocDetailReturnComponent.prototype.render = function() {
    return React.createElement(DocItemComponent, {
      "title": 'Returns',
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement(DocDetailReturnTableComponent, {
      "current": this.props.current,
      "style": [styles.content]
    }));
  };

  return DocDetailReturnComponent;

})(React.Component);

styles = {
  base: {},
  content: {}
};

DocDetailReturnComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocDetailReturnComponent);



},{"./doc-detail-return-table-component":14,"./doc-item-component":24,"radium":undefined,"react":undefined}],14:[function(require,module,exports){
var DocDetailReturnTableComponent, DocSignaturesTypeComponent, DocTableComponent, Link, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('./link-component');

DocTableComponent = require('./doc-table-component');

DocSignaturesTypeComponent = require('./signatures/doc-signatures-type-component');

colors = require('./colors/color-definition');


/*
@props.current [required] local current which is child of current factor
@props.style
 */

DocDetailReturnTableComponent = (function(superClass) {
  extend(DocDetailReturnTableComponent, superClass);

  function DocDetailReturnTableComponent(props) {
    DocDetailReturnTableComponent.__super__.constructor.call(this, props);
  }

  DocDetailReturnTableComponent.prototype.render = function() {
    var alt_text, prm, ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9, table, table_row;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, (table = [], alt_text = 'no description', table_row = [], prm = ((ref = this.props.current.signatures) != null ? ref[0] : void 0) || ((ref1 = this.props.current.getSignature) != null ? ref1[0] : void 0) || ((ref2 = this.props.current.setSignature) != null ? ref2[0] : void 0), table_row.push(React.createElement("span", {
      "style": styles.type
    }, React.createElement(DocSignaturesTypeComponent, {
      "type": prm.type,
      "emphasisStyle": styles.emphasis
    }))), table_row.push(React.createElement("span", null, ((ref3 = this.props.current.comment) != null ? ref3.returns : void 0) || ((ref4 = this.props.current.signatures) != null ? (ref5 = ref4[0].comment) != null ? ref5.returns : void 0 : void 0) || ((ref6 = this.props.current.getSignature) != null ? (ref7 = ref6[0].comment) != null ? ref7.returns : void 0 : void 0) || ((ref8 = this.props.current.setSignature) != null ? (ref9 = ref8[0].comment) != null ? ref9.returns : void 0 : void 0) || alt_text)), table.push(table_row), React.createElement(DocTableComponent, {
      "prefix": this.props.current.id + "-rtn",
      "table": table
    })));
  };

  return DocDetailReturnTableComponent;

})(React.Component);

styles = {
  base: {},
  type: {
    color: colors.general.r.light
  },
  oblique: {
    fontStyle: 'italic'
  },
  emphasis: {
    color: colors.general.r["default"]
  },
  link: {
    color: colors.general.r.emphasis,
    textDecoration: 'none',
    cursor: 'pointer',
    ':hover': {
      textDecoration: 'underline'
    }
  }
};

DocDetailReturnTableComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocDetailReturnTableComponent);



},{"./colors/color-definition":7,"./doc-table-component":27,"./link-component":33,"./signatures/doc-signatures-type-component":42,"radium":undefined,"react":undefined}],15:[function(require,module,exports){
var DocDetailSignaturesComponent, DocSignaturesComponent, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocSignaturesComponent = require('./signatures/doc-signatures-component');

colors = require('./colors/color-definition');

DocDetailSignaturesComponent = (function(superClass) {
  extend(DocDetailSignaturesComponent, superClass);

  function DocDetailSignaturesComponent(props) {
    DocDetailSignaturesComponent.__super__.constructor.call(this, props);
  }

  DocDetailSignaturesComponent.prototype.render = function() {
    var elm, ref, ref1;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style, styles.code])
    }, (elm = [], this.props.current.signatures != null ? this.props.current.signatures.forEach(function(s) {
      return elm.push(React.createElement(DocSignaturesComponent, {
        "signature": s,
        "emphasisStyle": styles.emphasis
      }));
    }) : (this.props.current.getSignature != null) || (this.props.current.setSignature != null) ? ((ref = this.props.current.getSignature) != null ? ref.forEach((function(_this) {
      return function(s) {
        return elm.push(React.createElement(DocSignaturesComponent, {
          "signature": s,
          "emphasisStyle": styles.emphasis,
          "name": _this.props.current.name
        }));
      };
    })(this)) : void 0, (ref1 = this.props.current.setSignature) != null ? ref1.forEach((function(_this) {
      return function(s) {
        return elm.push(React.createElement(DocSignaturesComponent, {
          "signature": s,
          "emphasisStyle": styles.emphasis,
          "name": _this.props.current.name
        }));
      };
    })(this)) : void 0) : elm.push(React.createElement(DocSignaturesComponent, {
      "signature": this.props.current,
      "emphasisStyle": styles.emphasis
    })), elm.map(function(e, i) {
      var signature_style;
      signature_style = {};
      if (i !== elm.length - 1) {
        signature_style = {
          borderBottomWidth: 1,
          borderBottomStyle: 'solid',
          borderBottomColor: '#555'
        };
      }
      return React.createElement("div", {
        "style": [signature_style, styles.signature]
      }, e);
    })));
  };

  return DocDetailSignaturesComponent;

})(React.Component);

styles = {
  base: {
    backgroundColor: colors.inverse.n["default"],
    paddingTop: 2,
    paddingBottom: 3,
    paddingLeft: 50,
    paddingRight: 50,
    marginRight: -50,
    marginLeft: -50,
    color: colors.inverse.r.moderate
  },
  signature: {
    paddingTop: 12,
    paddingBottom: 11
  },
  emphasis: {
    color: colors.inverse.r.emphasis
  },
  oblique: {
    fontStyle: 'italic'
  },
  code: {
    fontFamily: 'Menlo, Monaco, Consolas, "Courier New", monospace',
    fontSize: 13
  }
};

DocDetailSignaturesComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocDetailSignaturesComponent);



},{"./colors/color-definition":7,"./signatures/doc-signatures-component":39,"radium":undefined,"react":undefined}],16:[function(require,module,exports){
var DocDetailSignaturesComponent, DocDetailTitleComponent, DocFlagtagsComponent, DocTitleComponent, Link, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('./link-component');

DocDetailSignaturesComponent = require('./doc-detail-signatures-component');

DocTitleComponent = require('./doc-title-component');

DocFlagtagsComponent = require('./doc-flagtags-component');

colors = require('./colors/color-definition');


/*
@props.current [required] local current which is child of current factor
@props.style
 */

DocDetailTitleComponent = (function(superClass) {
  extend(DocDetailTitleComponent, superClass);

  function DocDetailTitleComponent(props) {
    DocDetailTitleComponent.__super__.constructor.call(this, props);
  }

  DocDetailTitleComponent.prototype.constructLink = function(current) {
    var detail_href, factor_href, fragment, global_match, local_match, match, route, routes;
    routes = this.context.ctx.routeStore.get().routes;
    match = current.name.match(/^(.+)\.(.+)$/);
    detail_href = '#';
    factor_href = '#';
    local_match = null;
    global_match = null;
    for (fragment in routes) {
      route = routes[fragment];
      local_match = route.match(new RegExp("^class:local:(.+):(.+):" + current.id + "$"));
      if (local_match) {
        detail_href = "/" + fragment;
        break;
      }
    }
    for (fragment in routes) {
      route = routes[fragment];
      global_match = route.match(new RegExp("^class:global:" + local_match[1] + ":" + local_match[2] + "$"));
      if (global_match) {
        factor_href = "/" + fragment;
        break;
      }
    }
    return React.createElement("span", null, React.createElement(Link, {
      "style": styles.link,
      "href": factor_href
    }, match[1]), React.createElement("span", null, "."), React.createElement(Link, {
      "style": styles.link,
      "href": detail_href
    }, match[2].replace(/__constructor/, 'constructor')));
  };

  DocDetailTitleComponent.prototype.render = function() {
    var dstyle;
    dstyle = {
      kind_string: {
        borderRadius: 7
      }
    };
    return React.createElement(DocTitleComponent, {
      "title": "." + this.props.current.name,
      "kindString": this.props.current.kindString,
      "dstyle": dstyle,
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, (this.props.current.inheritedFrom != null ? React.createElement("div", {
      "style": styles.from
    }, React.createElement("span", null, React.createElement("span", null, "Inherited from "), this.constructLink(this.props.current.inheritedFrom))) : void 0), (this.props.current.overwrites != null ? React.createElement("div", {
      "style": styles.from
    }, React.createElement("span", null, React.createElement("span", null, "Overwrites "), this.constructLink(this.props.current.overwrites))) : void 0), React.createElement(DocFlagtagsComponent, {
      "flags": this.props.current.flags,
      "style": styles.tags
    }), React.createElement(DocDetailSignaturesComponent, {
      "style": styles.signatures,
      "current": this.props.current
    }));
  };

  return DocDetailTitleComponent;

})(React.Component);

styles = {
  base: {},
  from: {
    marginBottom: 4
  },
  tags: {
    marginTop: 11,
    marginBottom: 11
  },
  signatures: {
    marginTop: 23
  },
  link: {
    color: colors.general.r.light,
    textDecoration: 'none',
    cursor: 'pointer',
    ':hover': {
      textDecoration: 'underline'
    }
  }
};

DocDetailTitleComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocDetailTitleComponent);



},{"./colors/color-definition":7,"./doc-detail-signatures-component":15,"./doc-flagtags-component":22,"./doc-title-component":28,"./link-component":33,"radium":undefined,"react":undefined}],17:[function(require,module,exports){
var DocDetailParametersTableComponent, DocItemComponent, DocSignaturesTypeComponent, DocTypeparameterComponent, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocDetailParametersTableComponent = require('./doc-detail-parameters-table-component');

DocSignaturesTypeComponent = require('./signatures/doc-signatures-type-component');

DocItemComponent = require('./doc-item-component');

colors = require('./colors/color-definition');


/*
@props.current [required] current factor
@props.style
 */

DocTypeparameterComponent = (function(superClass) {
  var constructTreeFromArray;

  extend(DocTypeparameterComponent, superClass);

  function DocTypeparameterComponent(props) {
    DocTypeparameterComponent.__super__.constructor.call(this, props);
  }

  constructTreeFromArray = function(arr) {
    var a, i, value;
    return React.createElement("ul", {
      "style": styles.ul
    }, ((function() {
      var j, len, results;
      a = arr[0];
      a = a instanceof Array ? a : [a];
      results = [];
      for (i = j = 0, len = a.length; j < len; i = ++j) {
        value = a[i];
        results.push(React.createElement("li", {
          "style": styles.li
        }, React.createElement("span", null, value), (i === a.length - 1 ? arr.length !== 1 ? constructTreeFromArray(arr.slice(1)) : void 0 : void 0)));
      }
      return results;
    })()));
  };

  DocTypeparameterComponent.prototype.render = function() {
    var children, current, parents, ref, ref1, tree_arr;
    return React.createElement(DocItemComponent, {
      "title": 'Hierarchy',
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, (parents = (ref = this.props.current.extendedTypes) != null ? ref.map(function(o) {
      return React.createElement("span", {
        "style": [styles.type, styles.not_current]
      }, React.createElement(DocSignaturesTypeComponent, {
        "type": o,
        "emphasisStyle": styles.emphasis
      }));
    }) : void 0, children = (ref1 = this.props.current.extendedBy) != null ? ref1.map(function(o) {
      return React.createElement("span", {
        "style": [styles.type, styles.not_current]
      }, React.createElement(DocSignaturesTypeComponent, {
        "type": o,
        "emphasisStyle": styles.emphasis
      }));
    }) : void 0, current = React.createElement("span", {
      "style": styles.current
    }, this.props.current.name), tree_arr = [], [parents, current, children].forEach(function(v) {
      if (v != null) {
        return tree_arr.push(v);
      }
    }), React.createElement("div", null, constructTreeFromArray(tree_arr))));
  };

  return DocTypeparameterComponent;

})(React.Component);

styles = {
  base: {},
  li: {
    marginTop: 4,
    listStyle: 'square'
  },
  ul: {
    marginTop: 4,
    paddingLeft: 20
  },
  current: {
    fontWeight: 'bold',
    color: colors.general.r.emphasis
  },
  not_current: {},
  type: {
    color: colors.general.r.light
  },
  emphasis: {
    color: colors.general.r["default"]
  }
};

DocTypeparameterComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocTypeparameterComponent);



},{"./colors/color-definition":7,"./doc-detail-parameters-table-component":12,"./doc-item-component":24,"./signatures/doc-signatures-type-component":42,"radium":undefined,"react":undefined}],18:[function(require,module,exports){
var DocFactorImplementsComponent, DocItemComponent, DocSignaturesTypeComponent, DocTableComponent, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocSignaturesTypeComponent = require('./signatures/doc-signatures-type-component');

DocTableComponent = require('./doc-table-component');

DocItemComponent = require('./doc-item-component');

colors = require('./colors/color-definition');


/*
@props.current [required] current factor
@props.style
 */

DocFactorImplementsComponent = (function(superClass) {
  extend(DocFactorImplementsComponent, superClass);

  function DocFactorImplementsComponent(props) {
    DocFactorImplementsComponent.__super__.constructor.call(this, props);
  }

  DocFactorImplementsComponent.prototype.render = function() {
    var table, title;
    title = '';
    table = [];
    if (this.props.current.implementedTypes != null) {
      title = 'Implements';
      table = this.props.current.implementedTypes;
    } else if (this.props.current.implementedBy != null) {
      title = 'Implemented by';
      table = this.props.current.implementedBy;
    }
    table = table.map(function(o) {
      return [
        React.createElement("span", {
          "style": styles.type
        }, React.createElement(DocSignaturesTypeComponent, {
          "type": o,
          "emphasisStyle": styles.emphasis
        }))
      ];
    });
    return React.createElement(DocItemComponent, {
      "title": title,
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement(DocTableComponent, {
      "table": table
    }));
  };

  return DocFactorImplementsComponent;

})(React.Component);

styles = {
  base: {},
  type: {
    color: colors.general.r.light
  },
  emphasis: {
    color: colors.general.r["default"]
  }
};

DocFactorImplementsComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocFactorImplementsComponent);



},{"./colors/color-definition":7,"./doc-item-component":24,"./doc-table-component":27,"./signatures/doc-signatures-type-component":42,"radium":undefined,"react":undefined}],19:[function(require,module,exports){
var DocFactorItemComponent, DocFactorTableComponent, DocItemComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocFactorTableComponent = require('./doc-factor-table-component');

DocItemComponent = require('./doc-item-component');


/*
@props.group [required] parent of current factor
@props.current [required] current factor
@props.collapsed [required]
@props.style
 */

DocFactorItemComponent = (function(superClass) {
  extend(DocFactorItemComponent, superClass);

  function DocFactorItemComponent(props) {
    DocFactorItemComponent.__super__.constructor.call(this, props);
  }

  DocFactorItemComponent.prototype.render = function() {
    var dstyle;
    dstyle = {};
    if (this.props.collapsed) {
      dstyle = {
        base: {
          marginBottom: 30
        },
        subtitle: {
          marginLeft: 0,
          fontSize: 15
        },
        content: {
          marginTop: 8
        }
      };
    }
    return React.createElement(DocItemComponent, {
      "title": this.props.group.title,
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style, dstyle.base]),
      "subtitleStyle": dstyle.subtitle
    }, React.createElement(DocFactorTableComponent, {
      "group": this.props.group,
      "current": this.props.current,
      "style": [dstyle.content],
      "collapsed": this.props.collapsed
    }));
  };

  return DocFactorItemComponent;

})(React.Component);

styles = {
  base: {}
};

DocFactorItemComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocFactorItemComponent);



},{"./doc-factor-table-component":20,"./doc-item-component":24,"radium":undefined,"react":undefined}],20:[function(require,module,exports){
var DocFactorTableComponent, DocTableComponent, Link, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('./link-component');

DocTableComponent = require('./doc-table-component');

colors = require('./colors/color-definition');


/*
@props.group [required] parent of current factor
@props.current [required] current factor
@prrops.collapsed [required]
@props.style
 */

DocFactorTableComponent = (function(superClass) {
  extend(DocFactorTableComponent, superClass);

  function DocFactorTableComponent(props) {
    DocFactorTableComponent.__super__.constructor.call(this, props);
  }

  DocFactorTableComponent.prototype.render = function() {
    var alt_text, c, cellStyles, child, dstyle, flags, i, id, table, table_row;
    dstyle = {};
    if (this.props.collapsed) {
      dstyle = {
        tb_key: {
          minWidth: 210
        }
      };
    }
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, ((function() {
      var j, k, len, len1, ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7, ref8;
      table = [];
      ref = this.props.group.children;
      for (i = j = 0, len = ref.length; j < len; i = ++j) {
        id = ref[i];
        child = null;
        ref1 = this.props.current.children;
        for (k = 0, len1 = ref1.length; k < len1; k++) {
          c = ref1[k];
          if (c.id === id) {
            child = c;
          }
        }
        if (child != null) {
          alt_text = 'no description';
          table_row = [];
          table_row.push(React.createElement(Link, {
            "style": styles.link,
            "uniqRoute": "class:local:.+?:" + this.props.current.id + ":" + child.id
          }, child.name));
          table_row.push(React.createElement("span", null, (flags = [], child.flags.isPrivate ? flags.push(React.createElement("span", {
            "style": styles.flag,
            "className": 'icon-lock'
          })) : child.flags.isProtected ? flags.push(React.createElement("span", {
            "style": styles.flag,
            "className": 'icon-unlock-alt'
          })) : flags.push(React.createElement("span", {
            "style": styles.flag,
            "className": 'icon-unlock'
          })), child.flags.isStatic ? flags.push(React.createElement("span", {
            "style": styles.flag,
            "className": 'icon-thumb-tack'
          })) : void 0, flags)));
          table_row.push(React.createElement("span", null, ((ref2 = child.comment) != null ? ref2.shortText : void 0) || ((ref3 = child.signatures) != null ? (ref4 = ref3[0].comment) != null ? ref4.shortText : void 0 : void 0) || ((ref5 = child.getSignature) != null ? (ref6 = ref5[0].comment) != null ? ref6.shortText : void 0 : void 0) || ((ref7 = child.setSignature) != null ? (ref8 = ref7[0].comment) != null ? ref8.shortText : void 0 : void 0) || alt_text));
          table.push(table_row);
        }
      }
      cellStyles = [dstyle.tb_key, void 0];
      return React.createElement(DocTableComponent, {
        "prefix": this.props.current.id + "-" + this.props.group.kind,
        "table": table,
        "cellStyles": cellStyles
      });
    }).call(this)));
  };

  return DocFactorTableComponent;

})(React.Component);

styles = {
  base: {},
  flag: {
    marginRight: 10
  },
  link: {
    color: colors.general.r.emphasis,
    textDecoration: 'none',
    cursor: 'pointer',
    ':hover': {
      textDecoration: 'underline'
    }
  }
};

DocFactorTableComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocFactorTableComponent);



},{"./colors/color-definition":7,"./doc-table-component":27,"./link-component":33,"radium":undefined,"react":undefined}],21:[function(require,module,exports){
var DocFactorTitleComponent, DocFlagtagsComponent, DocTitleComponent, Link, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('./link-component');

DocTitleComponent = require('./doc-title-component');

DocFlagtagsComponent = require('./doc-flagtags-component');

colors = require('./colors/color-definition');


/*
@props.current [required]
@props.from [required]
@props.collapsed
@props.style
 */

DocFactorTitleComponent = (function(superClass) {
  extend(DocFactorTitleComponent, superClass);

  function DocFactorTitleComponent(props) {
    DocFactorTitleComponent.__super__.constructor.call(this, props);
  }

  DocFactorTitleComponent.prototype.render = function() {
    var dstyle;
    dstyle = {};
    if (this.props.collapsed) {
      dstyle = {
        base: {
          marginBottom: 30
        },
        kind_string: {
          fontSize: 14,
          paddingTop: 3,
          paddingBottom: 1,
          paddingLeft: 12,
          paddingRight: 12,
          marginLeft: 0,
          marginRight: 12,
          textAlign: 'center',
          float: 'none',
          display: 'inline-block'
        },
        title: {
          fontSize: 20,
          paddingLeft: 0,
          paddingRight: 0,
          float: 'none',
          marginTop: 10,
          marginLeft: 0
        }
      };
    }
    return React.createElement(DocTitleComponent, {
      "title": this.props.current.name,
      "kindString": this.props.current.kindString,
      "dstyle": dstyle,
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, (!this.props.collapsed ? React.createElement("div", {
      "style": styles.from
    }, React.createElement("span", null, React.createElement("span", null, this.props.current.kindString + " in "), React.createElement("a", {
      "style": styles.link,
      "target": '_new',
      "href": "https://github.com/jThreeJS/jThree/tree/develop/jThree/src/" + (this.props.from.name.replace(/"/g, '')) + ".ts"
    }, "" + (this.props.from.name.replace(/"/g, '').replace(/$/, '.ts'))))) : void 0), (!this.props.collapsed ? React.createElement(DocFlagtagsComponent, {
      "flags": this.props.current.flags,
      "style": styles.tags
    }) : void 0));
  };

  return DocFactorTitleComponent;

})(React.Component);

styles = {
  base: {},
  from: {
    marginBottom: 4
  },
  tags: {
    marginTop: 11,
    marginBottom: 11
  },
  link: {
    color: colors.general.r.light
  }
};

DocFactorTitleComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocFactorTitleComponent);



},{"./colors/color-definition":7,"./doc-flagtags-component":22,"./doc-title-component":28,"./link-component":33,"radium":undefined,"react":undefined}],22:[function(require,module,exports){
var DocFlagtagsComponent, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

colors = require('./colors/color-definition');


/*
@props.flags [required]
@props.style
 */

DocFlagtagsComponent = (function(superClass) {
  extend(DocFlagtagsComponent, superClass);

  function DocFlagtagsComponent(props) {
    DocFlagtagsComponent.__super__.constructor.call(this, props);
  }

  DocFlagtagsComponent.prototype.render = function() {
    var dstyle, elm, ref, ref1, ref2, ref3, ref4, ref5;
    dstyle = {};
    if (!(((ref = this.props.flags) != null ? ref.isProtected : void 0) || ((ref1 = this.props.flags) != null ? ref1.isPrivate : void 0) || ((ref2 = this.props.flags) != null ? ref2.isStatic : void 0))) {
      dstyle.base = {
        marginBottom: 0
      };
    }
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style, dstyle.base])
    }, (elm = [], ((ref3 = this.props.flags) != null ? ref3.isProtected : void 0) ? elm.push(React.createElement("span", {
      "style": styles.tag
    }, React.createElement("span", {
      "style": styles.tag_icon,
      "className": 'icon-unlock-alt'
    }), React.createElement("span", null, "Protected"))) : void 0, ((ref4 = this.props.flags) != null ? ref4.isPrivate : void 0) ? elm.push(React.createElement("span", {
      "style": styles.tag
    }, React.createElement("span", {
      "style": styles.tag_icon,
      "className": 'icon-lock'
    }), React.createElement("span", null, "Private"))) : void 0, ((ref5 = this.props.flags) != null ? ref5.isStatic : void 0) ? elm.push(React.createElement("span", {
      "style": styles.tag
    }, React.createElement("span", {
      "style": styles.tag_icon,
      "className": 'icon-thumb-tack'
    }), React.createElement("span", null, "Static"))) : void 0, elm));
  };

  return DocFlagtagsComponent;

})(React.Component);

styles = {
  base: {
    marginBottom: 11
  },
  tag: {
    display: 'inline-block',
    borderRadius: 13,
    borderWidth: 1,
    borderStyle: 'solid',
    borderColor: colors.inverse.n.moderate,
    backgroundColor: colors.inverse.n.moderate,
    color: colors.inverse.r.emphasis,
    fontSize: 11,
    paddingTop: 6,
    paddingBottom: 3,
    paddingLeft: 12,
    paddingRight: 12,
    marginRight: 16
  },
  tag_icon: {
    marginRight: 5
  }
};

DocFlagtagsComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocFlagtagsComponent);



},{"./colors/color-definition":7,"radium":undefined,"react":undefined}],23:[function(require,module,exports){
var DocIncrementalComponent, Link, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('./link-component');

colors = require('./colors/color-definition');


/*
@props.list [required] list array contains hash
hash overview:
{target: (string), content: [ReactElement, 'match', ...]}
target: target of search
content: elements array which is inserted to result list. if array factor
is 'match', it is replace to matched result element.
@props.style
@props.styles apply for each elements
 */

DocIncrementalComponent = (function(superClass) {
  extend(DocIncrementalComponent, superClass);

  function DocIncrementalComponent(props) {
    DocIncrementalComponent.__super__.constructor.call(this, props);
  }

  DocIncrementalComponent.prototype.componentWillMount = function() {
    var list;
    list = this.props.list;
    list.sort(function(v1, v2) {
      if (v1.target > v2.target) {
        return 1;
      } else {
        return -1;
      }
    });
    this.setState({
      text: '',
      result: [],
      list: list
    });
    return this.updateSearch('', list);
  };

  DocIncrementalComponent.prototype.componentDidMount = function() {
    return this.refs.input.getDOMNode().focus();
  };

  DocIncrementalComponent.prototype.updateText = function(e) {
    var text;
    text = e.target.value;
    this.setState({
      text: text
    });
    return this.updateSearch(text);
  };

  DocIncrementalComponent.prototype.updateSearch = function(text, list) {
    var j, l, len, match, match_all, md_all, md_all_completely, md_all_forward, md_part, ref, regexp, regexp_all, result;
    list || (list = (ref = this.state.list) != null ? ref : []);
    text = text.replace(/\s/g, '');
    result = [];
    md_all_completely = [];
    md_all_forward = [];
    md_all = [];
    md_part = [];
    regexp_all = new RegExp('^(.*?)(' + text.replace(/([^0-9A-Za-z_])/g, '\\$1') + ')(.*?)$', 'i');
    regexp = new RegExp('^(.*?)(' + text.split('').map(function(v) {
      return v.replace(/([^0-9A-Za-z_])/g, '\\$1');
    }).join(')(.*?)(') + ')(.*?)$', 'i');
    for (j = 0, len = list.length; j < len; j++) {
      l = list[j];
      match = l.target.match(regexp);
      if (match) {
        match_all = l.target.match(regexp_all);
        if (match_all) {
          if (match_all[1] === '') {
            if (match_all[match_all.length - 1] === '') {
              md_all_completely.push({
                match: match_all,
                content: l.content,
                href: l.href
              });
            } else {
              md_all_forward.push({
                match: match_all,
                content: l.content,
                href: l.href
              });
            }
          } else {
            md_all.push({
              match: match_all,
              content: l.content,
              href: l.href
            });
          }
        } else {
          md_part.push({
            match: match,
            content: l.content,
            href: l.href
          });
        }
      }
    }
    result = [].concat(md_all_completely, md_all_forward, md_all, md_part);
    return this.setState({
      result: result
    });
  };

  DocIncrementalComponent.prototype.render = function() {
    var dstyle, e, elm, i, m, md, return_elm;
    dstyle = [styles["default"], styles.emphasis];
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement("input", {
      "type": "text",
      "value": this.state.text,
      "onChange": this.updateText.bind(this),
      "style": this.props.styles.input,
      "placeholder": 'Search',
      "ref": 'input'
    }), React.createElement("ul", {
      "style": this.props.styles.ul
    }, (return_elm = (function() {
      var j, k, len, len1, ref, ref1, results;
      ref = this.state.result.slice(0, 15);
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        md = ref[j];
        elm = [];
        ref1 = md.match.slice(1);
        for (i = k = 0, len1 = ref1.length; k < len1; i = ++k) {
          m = ref1[i];
          if (m !== '') {
            elm.push(React.createElement("span", {
              "style": dstyle[i % 2],
              "key": i
            }, m));
          }
        }
        results.push(React.createElement("li", {
          "style": this.props.styles.li,
          "key": md.href
        }, React.createElement("span", {
          "style": this.props.styles.item
        }, (function() {
          var len2, n, ref2, results1;
          ref2 = md.content;
          results1 = [];
          for (i = n = 0, len2 = ref2.length; n < len2; i = ++n) {
            e = ref2[i];
            if (e === 'match') {
              results1.push(React.createElement(Link, {
                "href": md.href,
                "style": [styles.link, this.props.styles.match],
                "key": 'match'
              }, elm));
            } else {
              results1.push(React.cloneElement(e, {
                key: "icon-" + i
              }));
            }
          }
          return results1;
        }).call(this))));
      }
      return results;
    }).call(this), this.state.result.length >= 16 ? return_elm.push(React.createElement("li", {
      "style": [styles.more, this.props.styles.li],
      "key": 'more'
    }, React.createElement("span", null, (this.state.result.length - 15) + " more"))) : void 0, return_elm)));
  };

  return DocIncrementalComponent;

})(React.Component);

styles = {
  base: {},
  emphasis: {
    color: colors.main.n.moderate,
    fontWeight: 'bold'
  },
  "default": {
    color: colors.general.r.moderate
  },
  more: {
    color: colors.general.r.light
  },
  link: {
    color: colors.general.r.moderate,
    textDecoration: 'none',
    cursor: 'pointer',
    ':hover': {
      textDecoration: 'underline'
    }
  }
};

DocIncrementalComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocIncrementalComponent);



},{"./colors/color-definition":7,"./link-component":33,"radium":undefined,"react":undefined}],24:[function(require,module,exports){
var DocItemComponent, DocTableComponent, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocTableComponent = require('./doc-table-component');

colors = require('./colors/color-definition');


/*
@props.title [required] subtitle of this item
@props.subtitleStyle
@props.style
@props.children
 */

DocItemComponent = (function(superClass) {
  extend(DocItemComponent, superClass);

  function DocItemComponent(props) {
    DocItemComponent.__super__.constructor.call(this, props);
  }

  DocItemComponent.prototype.render = function() {
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.subtitle, this.props.subtitleStyle])
    }, this.props.title), React.Children.map(this.props.children, function(child) {
      return React.cloneElement(child, {
        style: Array.prototype.concat.apply([], [styles.content, child.props.style])
      });
    }));
  };

  return DocItemComponent;

})(React.Component);

styles = {
  base: {
    marginBottom: 40
  },
  subtitle: {
    fontSize: 23,
    fontWeight: 'bold',
    color: colors.general.r["default"]
  },
  content: {
    fontSize: 15,
    marginTop: 15
  }
};

DocItemComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocItemComponent);



},{"./colors/color-definition":7,"./doc-table-component":27,"radium":undefined,"react":undefined}],25:[function(require,module,exports){
var CharIconComponent, DocIncrementalSearchComponent, DocSearchContainerComponent, Radium, React, colors, find, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

find = require('lodash.find');

DocIncrementalSearchComponent = require('./doc-incremental-search-component');

CharIconComponent = require('./char-icon-component');

colors = require('./colors/color-definition');


/*
@props.style
 */

DocSearchContainerComponent = (function(superClass) {
  extend(DocSearchContainerComponent, superClass);

  function DocSearchContainerComponent(props) {
    DocSearchContainerComponent.__super__.constructor.call(this, props);
  }

  DocSearchContainerComponent.prototype.componentWillMount = function() {
    return this.setState({
      routes: this.context.ctx.routeStore.get().routes,
      dir_tree: this.context.ctx.docStore.get().dir_tree
    });
  };

  DocSearchContainerComponent.prototype.genKindStringStyle = function(kindString) {
    var color, style;
    color = colors.general.r["default"];
    switch (kindString) {
      case 'Class':
        color = '#337BFF';
        break;
      case 'Constructor':
        color = '#337BFF';
        break;
      case 'Interface':
        color = '#598213';
        break;
      case 'Property':
        color = '#598213';
        break;
      case 'Enumeration':
        color = '#B17509';
        break;
      case 'Enumeration member':
        color = '#B17509';
        break;
      case 'Module':
        color = '#D04C35';
        break;
      case 'Accessor':
        color = '#D04C35';
        break;
      case 'Function':
        color = '#6E00FF';
        break;
      case 'Method':
        color = '#6E00FF';
        break;
      default:
        color = colors.general.r["default"];
    }
    return style = {
      color: color,
      borderColor: color
    };
  };

  DocSearchContainerComponent.prototype.callDirTreeByArray = function(arr) {
    var dir_tree, i, j, len, ref, ref1, v;
    dir_tree = this.state.dir_tree;
    for (i = j = 0, len = arr.length; j < len; i = ++j) {
      v = arr[i];
      if (i !== arr.length - 1) {
        dir_tree = (ref = dir_tree.dir) != null ? ref[v] : void 0;
      } else {
        return (ref1 = dir_tree.file) != null ? ref1[v] : void 0;
      }
      if (dir_tree == null) {
        return void 0;
      }
    }
  };

  DocSearchContainerComponent.prototype.render = function() {
    var char_elm, char_elm_child, fragment, list, m, obj, obj_child, route;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, ((function() {
      var ref;
      list = [];
      ref = this.state.routes;
      for (fragment in ref) {
        route = ref[fragment];
        if (route.split(':')[1] === 'global') {
          obj = this.callDirTreeByArray(fragment.split('/').slice(1));
          if (obj == null) {
            continue;
          }
          char_elm = React.createElement(CharIconComponent, {
            "char": obj.kindString,
            "style": this.genKindStringStyle(obj.kindString)
          });
          list.push({
            target: fragment.match(/.+\/(.+?)$/)[1],
            content: [char_elm, 'match'],
            href: "/" + fragment
          });
        } else if (route.split(':')[1] === 'local') {
          m = fragment.match(/.+\/(.+?)\/(.+?)$/);
          obj = this.callDirTreeByArray(fragment.split('/').slice(1, -1));
          if (obj == null) {
            continue;
          }
          obj_child = find(obj.children, function(v) {
            return v.name === fragment.split('/').slice(-1)[0];
          });
          char_elm = React.createElement(CharIconComponent, {
            "char": obj.kindString,
            "style": this.genKindStringStyle(obj.kindString)
          });
          char_elm_child = React.createElement(CharIconComponent, {
            "char": obj_child.kindString,
            "style": [
              this.genKindStringStyle(obj_child.kindString), {
                borderRadius: 2
              }
            ]
          });
          list.push({
            target: m[1] + "." + m[2],
            content: [char_elm, char_elm_child, 'match'],
            href: "/" + fragment
          });
        }
      }
      return React.createElement(DocIncrementalSearchComponent, {
        "list": list,
        "styles": styles
      });
    }).call(this)));
  };

  return DocSearchContainerComponent;

})(React.Component);

styles = {
  base: {},
  input: {
    paddingTop: 5,
    paddingBottom: 5,
    paddingRight: 12,
    paddingLeft: 12,
    fontSize: 16,
    fontFamily: '-webkit-body',
    fontFamily: '-moz-body',
    fontWeight: 'normal',
    outline: 'none',
    borderColor: colors.general.r.moderate,
    borderWidth: 1,
    borderStyle: 'solid',
    display: 'block',
    width: '100%',
    boxSizing: 'border-box',
    marginBottom: 20,
    ':focus': {
      outline: 'none',
      borderColor: colors.general.r.moderate,
      boxShadow: "0 0 4px 0 " + colors.general.r.light
    }
  },
  ul: {
    listStyle: 'none',
    paddingLeft: 0
  },
  li: {
    fontSize: 14,
    marginBottom: 8
  }
};

DocSearchContainerComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocSearchContainerComponent);



},{"./char-icon-component":5,"./colors/color-definition":7,"./doc-incremental-search-component":23,"lodash.find":undefined,"radium":undefined,"react":undefined}],26:[function(require,module,exports){
var DocSlideWrapperComponent, Radium, React, clone, colors, objectAssign, slide, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

objectAssign = require('object-assign');

clone = require('lodash.clone');

colors = require('./colors/color-definition');


/*
@props.children[0] [require] to be left
@props.children[1] [require] to be right
@props.style
 */

DocSlideWrapperComponent = (function(superClass) {
  extend(DocSlideWrapperComponent, superClass);

  function DocSlideWrapperComponent(props) {
    DocSlideWrapperComponent.__super__.constructor.call(this, props);
  }

  DocSlideWrapperComponent.prototype.handleEvent = function(e) {
    if (e.type === 'resize') {
      return this.updateWrapperWidth();
    }
  };

  DocSlideWrapperComponent.prototype.updateWrapperWidth = function() {
    var wrapperWidth;
    wrapperWidth = React.findDOMNode(this.refs.docWrapper).clientWidth - slide.from;
    if (this.state.wrapperWidth !== wrapperWidth) {
      return this.setState({
        wrapperWidth: wrapperWidth
      });
    }
  };

  DocSlideWrapperComponent.prototype.componentDidMount = function() {
    this.updateWrapperWidth();
    return window.addEventListener('resize', this);
  };

  DocSlideWrapperComponent.prototype.componentWillUnmount = function() {
    return window.removeEventListener('resize', this);
  };

  DocSlideWrapperComponent.prototype.close = function() {
    var ref;
    if (((ref = this.props.argu.route_arr[1]) != null ? ref.toString() : void 0) === 'local') {
      return this.context.ctx.routeAction.navigate(document.location.pathname.match(/^(.+)\/[^\/]+$/)[1]);
    }
  };

  DocSlideWrapperComponent.prototype.search = function() {
    return this.context.ctx.routeAction.navigate('/class');
  };

  DocSlideWrapperComponent.prototype.render = function() {
    var collapsed, dstyle, k, props, ref, ref1, v;
    dstyle = {};
    collapsed = false;
    if (((ref = this.props.argu.route_arr[1]) != null ? ref.toString() : void 0) === 'local') {
      collapsed = true;
    }
    if (collapsed) {
      dstyle.left = {
        boxSizing: 'border-box',
        flexGrow: '0',
        WebkitFlexGrow: '0',
        width: slide.from,
        paddingLeft: 18,
        paddingRight: 0,
        overflow: 'hidden',
        whiteSpace: 'nowrap',
        transitionProperty: 'all',
        transitionDuration: '0.1s',
        transitionTimingFunction: 'ease-in-out',
        ':hover': {
          width: slide.to
        }
      };
    }
    if (this.state.wrapperWidth) {
      dstyle.wrapper = {
        width: this.state.wrapperWidth
      };
    }
    props = {};
    ref1 = this.props;
    for (k in ref1) {
      v = ref1[k];
      if (k !== 'children' && k !== 'style') {
        props[k] = clone(v, true);
      }
    }
    objectAssign(props, {
      collapsed: collapsed
    });
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style]),
      "ref": 'docWrapper'
    }, React.createElement("div", {
      "style": [styles.left, dstyle.left],
      "ref": 'docLeft',
      "onClick": this.close.bind(this)
    }, React.Children.map(this.props.children, function(c, i) {
      if (i === 0) {
        return React.cloneElement(c, props);
      }
    })), (collapsed ? React.createElement("div", {
      "style": styles.right,
      "ref": 'docRight'
    }, React.createElement("div", {
      "style": styles.close,
      "onClick": this.close.bind(this)
    }, React.createElement("span", {
      "className": 'icon-close',
      "style": styles.close_icon,
      "key": 'icon-close'
    })), React.createElement("div", {
      "style": [styles.wrapper, dstyle.wrapper]
    }, React.Children.map(this.props.children, function(c, i) {
      if (i === 1) {
        return React.cloneElement(c, props);
      }
    }))) : void 0), (this.props.argu.route_arr[0] === 'class' && this.props.argu.route_arr.length !== 1 ? React.createElement("div", {
      "style": styles.search,
      "onClick": this.search.bind(this)
    }, React.createElement("span", {
      "className": 'icon-search',
      "style": styles.search_icon,
      "key": 'icon-search'
    })) : void 0));
  };

  return DocSlideWrapperComponent;

})(React.Component);

slide = {
  from: 120,
  to: 210
};

styles = {
  base: {
    display: 'flex',
    display: '-webkit-flex',
    flexDirection: 'row',
    WebkitFlexDirection: 'row',
    flexWrap: 'nowrap',
    WebkitFlexWrap: 'nowrap',
    flexGrow: '1',
    WebkitFlexGrow: '1',
    position: 'relative'
  },
  left: {
    paddingLeft: 50,
    paddingRight: 50,
    paddingTop: 30,
    paddingBottom: 30,
    boxSizing: 'border-box',
    flexGrow: '1',
    WebkitFlexGrow: '1'
  },
  right: {
    flexGrow: '1',
    WebkitFlexGrow: '1',
    position: 'relative',
    overflow: 'hidden',
    boxShadow: '0 0 3px 0 rgba(0, 0, 0, 0.4)',
    backgroundColor: '#fff'
  },
  close: {
    position: 'absolute',
    top: 7,
    left: 8,
    cursor: 'pointer',
    zIndex: '1'
  },
  close_icon: {
    fontSize: 20,
    color: colors.general.r.light,
    transitionProperty: 'all',
    transitionDuration: '0.1s',
    transitionTimingFunction: 'ease-in-out',
    ':hover': {
      color: colors.general.r["default"]
    }
  },
  search: {
    position: 'absolute',
    top: 7,
    right: 8,
    cursor: 'pointer',
    zIndex: '1'
  },
  search_icon: {
    fontSize: 23,
    color: colors.general.r.light,
    transitionProperty: 'all',
    transitionDuration: '0.1s',
    transitionTimingFunction: 'ease-in-out',
    ':hover': {
      color: colors.general.r["default"]
    }
  },
  wrapper: {
    position: 'absolute',
    top: 0,
    left: 0,
    bottom: 0,
    paddingLeft: 50,
    paddingRight: 50,
    paddingTop: 30,
    paddingBottom: 30,
    boxSizing: 'border-box',
    zIndex: '0'
  }
};

DocSlideWrapperComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocSlideWrapperComponent);



},{"./colors/color-definition":7,"lodash.clone":undefined,"object-assign":undefined,"radium":undefined,"react":undefined}],27:[function(require,module,exports){
var DocTableComponent, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

colors = require('./colors/color-definition');


/*
@props.table [required] 2 dimension array of ReactElement data
@props.prefix [required] unique text for key's prefix
@props.cellStyles array of styles applied to column
@props.style
 */

DocTableComponent = (function(superClass) {
  extend(DocTableComponent, superClass);

  function DocTableComponent(props) {
    DocTableComponent.__super__.constructor.call(this, props);
  }

  DocTableComponent.prototype.render = function() {
    var cell, dstyle, i, j, odd_even_style, row;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement("table", {
      "style": styles.table
    }, React.createElement("tbody", null, (function() {
      var k, len, ref, results;
      ref = this.props.table;
      results = [];
      for (i = k = 0, len = ref.length; k < len; i = ++k) {
        row = ref[i];
        odd_even_style = i % 2 === 1 ? {} : {
          backgroundColor: '#F2F2F2'
        };
        results.push(React.createElement("tr", {
          "key": this.props.prefix + "-" + i,
          "style": [styles.tb_row, odd_even_style]
        }, (function() {
          var l, len1, ref1, results1;
          results1 = [];
          for (j = l = 0, len1 = row.length; l < len1; j = ++l) {
            cell = row[j];
            dstyle = j === 0 ? styles.tb_key : styles.tb_desc;
            results1.push(React.createElement("td", {
              "key": this.props.prefix + "-" + i + "-" + j,
              "style": [styles.tb_item, dstyle, (ref1 = this.props.cellStyles) != null ? ref1[j] : void 0]
            }, cell));
          }
          return results1;
        }).call(this)));
      }
      return results;
    }).call(this))));
  };

  return DocTableComponent;

})(React.Component);

styles = {
  base: {},
  table: {
    borderSpacing: 0
  },
  tb_row: {
    ':hover': {
      backgroundColor: colors.main.n.light
    }
  },
  tb_item: {
    paddingTop: 9,
    paddingBottom: 7,
    paddingLeft: 20,
    paddingRight: 20
  },
  tb_key: {
    paddingRight: 20,
    color: colors.general.r.emphasis
  },
  tb_desc: {
    color: colors.general.r.moderate
  }
};

DocTableComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocTableComponent);



},{"./colors/color-definition":7,"radium":undefined,"react":undefined}],28:[function(require,module,exports){
var DocTitleComponent, Link, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('./link-component');

colors = require('./colors/color-definition');


/*
@props.title [required]
@props.kindString [required]
@props.children
@props.dstyle
@props.style
 */

DocTitleComponent = (function(superClass) {
  extend(DocTitleComponent, superClass);

  function DocTitleComponent(props) {
    DocTitleComponent.__super__.constructor.call(this, props);
  }

  DocTitleComponent.prototype.genKindStringStyle = function(kindString) {
    var color, style;
    color = colors.general.r["default"];
    switch (kindString) {
      case 'Class':
        color = '#337BFF';
        break;
      case 'Constructor':
        color = '#337BFF';
        break;
      case 'Interface':
        color = '#598213';
        break;
      case 'Property':
        color = '#598213';
        break;
      case 'Enumeration':
        color = '#B17509';
        break;
      case 'Enumeration member':
        color = '#B17509';
        break;
      case 'Module':
        color = '#D04C35';
        break;
      case 'Accessor':
        color = '#D04C35';
        break;
      case 'Function':
        color = '#6E00FF';
        break;
      case 'Method':
        color = '#6E00FF';
        break;
      default:
        color = colors.general.r["default"];
    }
    return style = {
      color: color,
      borderColor: color
    };
  };

  DocTitleComponent.prototype.render = function() {
    var dstyle;
    dstyle = this.props.dstyle != null ? this.props.dstyle : {};
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style, dstyle.base])
    }, React.createElement("div", {
      "style": styles.title_wrap
    }, React.createElement("div", {
      "style": [styles.kind_string, this.genKindStringStyle(this.props.kindString), dstyle.kind_string]
    }, this.props.kindString), React.createElement("div", {
      "style": [styles.title, dstyle.title]
    }, this.props.title)), React.createElement("div", {
      "style": styles.info
    }, this.props.children));
  };

  return DocTitleComponent;

})(React.Component);

styles = {
  base: {
    marginBottom: 40
  },
  title_wrap: {
    overflow: 'hidden',
    marginBottom: 10
  },
  kind_string: {
    fontSize: 18,
    borderStyle: 'solid',
    borderWidth: 1,
    paddingTop: 6,
    paddingBottom: 6,
    paddingLeft: 12,
    paddingRight: 12,
    marginTop: 3,
    marginRight: 10,
    float: 'left'
  },
  title: {
    fontSize: 35,
    paddingLeft: 12,
    paddingRight: 12,
    color: colors.general.r.emphasis,
    float: 'left',
    fontWeight: 'bold'
  },
  info: {
    fontSize: 15,
    color: colors.general.r.light
  }
};

DocTitleComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocTitleComponent);



},{"./colors/color-definition":7,"./link-component":33,"radium":undefined,"react":undefined}],29:[function(require,module,exports){
var DocDetailParametersTableComponent, DocItemComponent, DocTypeparameterComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocDetailParametersTableComponent = require('./doc-detail-parameters-table-component');

DocItemComponent = require('./doc-item-component');


/*
@props.current [required] current factor or local current which is child of current factor
@props.style
 */

DocTypeparameterComponent = (function(superClass) {
  extend(DocTypeparameterComponent, superClass);

  function DocTypeparameterComponent(props) {
    DocTypeparameterComponent.__super__.constructor.call(this, props);
  }

  DocTypeparameterComponent.prototype.render = function() {
    return React.createElement(DocItemComponent, {
      "title": 'Type parameters',
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement(DocDetailParametersTableComponent, {
      "parameters": this.props.current.typeParameter,
      "current_id": this.props.current.id
    }));
  };

  return DocTypeparameterComponent;

})(React.Component);

styles = {
  base: {}
};

DocTypeparameterComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocTypeparameterComponent);



},{"./doc-detail-parameters-table-component":12,"./doc-item-component":24,"radium":undefined,"react":undefined}],30:[function(require,module,exports){
var ErrorComponent, React,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

ErrorComponent = (function(superClass) {
  extend(ErrorComponent, superClass);

  function ErrorComponent(props) {
    ErrorComponent.__super__.constructor.call(this, props);
  }

  ErrorComponent.prototype.render = function() {
    return React.createElement("div", null, React.createElement("h1", null, "404 NotFound"));
  };

  return ErrorComponent;

})(React.Component);

ErrorComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = ErrorComponent;



},{"react":undefined}],31:[function(require,module,exports){
var HeaderComponent, Link, Radium, React, Route, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Route = require('./route-component');

Link = require('./link-component');

colors = require('./colors/color-definition');

HeaderComponent = (function(superClass) {
  extend(HeaderComponent, superClass);

  function HeaderComponent(props) {
    HeaderComponent.__super__.constructor.call(this, props);
  }

  HeaderComponent.prototype.render = function() {
    return React.createElement("div", {
      "style": styles.base
    }, React.createElement("div", {
      "style": styles.head
    }, React.createElement("span", {
      "style": styles.title
    }, "jThree"), React.createElement("span", {
      "style": styles.subtitle
    }, "Reference")), React.createElement("nav", {
      "style": styles.nav
    }, React.createElement(Route, {
      "addStyle": styles.active,
      "style": styles.li_cont
    }, React.createElement("li", {
      "route": 'index',
      "key": 'index',
      "style": [styles.li]
    }, React.createElement(Link, {
      "href": '/',
      "style": styles.link
    }, "Top")), React.createElement("li", {
      "route": 'forum',
      "key": 'forum',
      "style": [styles.li, styles.left_separator]
    }, React.createElement("a", {
      "href": '//forum.jthree.io',
      "style": styles.link
    }, "Forum")), React.createElement("li", {
      "route": 'overview',
      "key": 'overview',
      "style": [styles.li, styles.left_separator]
    }, React.createElement(Link, {
      "href": '/overview',
      "style": styles.link
    }, "Overview")), React.createElement("li", {
      "route": 'class',
      "key": 'class',
      "style": [styles.li, styles.left_separator]
    }, React.createElement(Link, {
      "href": '/class',
      "style": styles.link
    }, "Reference")))));
  };

  return HeaderComponent;

})(React.Component);

styles = {
  base: {
    backgroundColor: colors.main.n["default"],
    height: 80,
    position: 'relative',
    WebkitUserSelect: 'none',
    MozUserSelect: 'none'
  },
  head: {
    position: 'absolute',
    top: '50%',
    transform: 'translateY(-50%)',
    WebkitTransform: 'translateY(-50%)',
    left: 40
  },
  title: {
    color: colors.main.r.emphasis,
    marginRight: 20,
    fontSize: 30,
    fontWeight: 'bold',
    cursor: 'default'
  },
  subtitle: {
    color: colors.main.r["default"],
    cursor: 'default'
  },
  nav: {
    position: 'absolute',
    top: '50%',
    transform: 'translateY(-50%)',
    WebkitTransform: 'translateY(-50%)',
    right: 40
  },
  active: {
    color: colors.main.r.emphasis
  },
  li_cont: {
    clear: 'both',
    overflow: 'hidden'
  },
  li: {
    listStyle: 'none',
    float: 'left',
    paddingLeft: 20,
    paddingRight: 20
  },
  left_separator: {
    borderLeftColor: colors.main.r.moderate,
    borderLeftStyle: 'solid',
    borderLeftWidth: 1
  },
  link: {
    textDecoration: 'none',
    color: colors.main.r["default"],
    ':hover': {
      color: colors.main.r.emphasis
    }
  }
};

HeaderComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(HeaderComponent);



},{"./colors/color-definition":7,"./link-component":33,"./route-component":38,"radium":undefined,"react":undefined}],32:[function(require,module,exports){
var IndexComponent, Link, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

colors = require('./colors/color-definition');

Link = require('./link-component');

IndexComponent = (function(superClass) {
  extend(IndexComponent, superClass);

  function IndexComponent(props) {
    IndexComponent.__super__.constructor.call(this, props);
  }

  IndexComponent.prototype.render = function() {
    return React.createElement("div", {
      "style": styles.base
    }, React.createElement("div", {
      "style": styles.logo_area
    }, React.createElement("div", {
      "style": styles.logo_wrapper
    }, React.createElement("div", {
      "style": styles.logo
    }, React.createElement("div", {
      "style": styles.logo_icon
    }, React.createElement("span", {
      "className": 'icon-cube'
    })), React.createElement("div", {
      "style": styles.logo_text
    }, React.createElement("span", {
      "style": styles.logo_jthree
    }, "jThree"), React.createElement("span", {
      "style": styles.logo_v3
    }, "v3"))), React.createElement("div", {
      "style": styles.description
    }, React.createElement("span", null, "The more simple, the more Web3D is interesting.")))), React.createElement("div", {
      "style": styles.wrapper
    }, React.createElement("div", {
      "style": styles.link_container,
      "key": 'overview'
    }, React.createElement(Link, {
      "href": '/overview',
      "style": styles.link
    }, React.createElement("div", {
      "style": styles.link_icon_wrap
    }, React.createElement("span", {
      "className": 'icon-earth'
    })), React.createElement("div", {
      "style": styles.link_label
    }, "OverView"), React.createElement("div", {
      "style": styles.link_desc
    }, "Tutorial, tags, tips. You can post sample codes and share."))), React.createElement("div", {
      "style": styles.link_container,
      "key": 'reference'
    }, React.createElement(Link, {
      "href": '/class',
      "style": styles.link
    }, React.createElement("div", {
      "style": styles.link_icon_wrap
    }, React.createElement("span", {
      "className": 'icon-books'
    })), React.createElement("div", {
      "style": styles.link_label
    }, "Reference"), React.createElement("div", {
      "style": styles.link_desc
    }, "jThree API reference. You can search classes, methods, properties...")))));
  };

  return IndexComponent;

})(React.Component);

styles = {
  base: {
    WebkitUserSelect: 'none',
    MozUserSelect: 'none'
  },
  logo_area: {
    backgroundColor: colors.main.n["default"],
    height: 500,
    position: 'relative'
  },
  logo_wrapper: {
    position: 'absolute',
    top: '50%',
    left: '50%',
    transform: 'translate(-50%, -50%)',
    WebkitTransform: 'translate(-50%, -50%)',
    paddingBottom: 30,
    cursor: 'default'
  },
  logo: {
    fontSize: 50
  },
  logo_jthree: {
    fontWeight: 'bold',
    marginRight: 20,
    color: colors.main.r.emphasis,
    textShadow: '0 0 2px rgba(0, 0, 0, 0.5)'
  },
  logo_v3: {
    fontSize: 30,
    paddingTop: 13,
    paddingBottom: 10,
    paddingLeft: 13,
    paddingRight: 13,
    backgroundColor: colors.main.r.emphasis,
    color: colors.main.n["default"],
    boxShadow: '0 0 2px 0 rgba(0, 0, 0, 0.5)',
    borderRadius: 4
  },
  logo_icon: {
    textAlign: 'center',
    fontSize: 180,
    height: 210,
    color: colors.main.r.emphasis,
    textShadow: '0 0 2px rgba(0, 0, 0, 0.5)'
  },
  logo_text: {
    textAlign: 'center'
  },
  description: {
    textAlign: 'center',
    color: colors.main.r["default"],
    fontSize: 18,
    marginTop: 20
  },
  wrapper: {
    paddingTop: 50,
    paddingBottom: 50,
    paddingRight: 100,
    paddingLeft: 100,
    display: 'flex',
    display: '-webkit-flex',
    flexDirection: 'row',
    WebkitFlexDirection: 'row',
    flexWrap: 'nowrap',
    WebkitFlexWrap: 'nowrap',
    justifyContent: 'space-around',
    WebkitJustifyContent: 'space-around'
  },
  link_container: {
    boxSizing: 'border-box',
    paddingTop: 20,
    paddingBottom: 20,
    paddingRight: 20,
    paddingLeft: 20,
    width: 300
  },
  link: {
    display: 'block',
    textDecoration: 'none',
    cursor: 'pointer',
    transitionProperty: 'all',
    transitionDuration: '0.1s',
    transitionTimingFunction: 'ease-in-out',
    ':hover': {
      opacity: '0.8'
    }
  },
  link_icon_wrap: {
    fontSize: 50,
    textAlign: 'center',
    color: colors.main.n["default"]
  },
  link_label: {
    fontSize: 20,
    textAlign: 'center',
    color: colors.main.n["default"]
  },
  link_desc: {
    marginTop: 10,
    fontSize: 13,
    textAlign: 'center',
    color: colors.main.n.moderate
  }
};

IndexComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(IndexComponent);



},{"./colors/color-definition":7,"./link-component":33,"radium":undefined,"react":undefined}],33:[function(require,module,exports){
var LinkComponent, Radium, React,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');


/*
Routing support component

*** Props ***
@props.href {obj|array} url path of link location
@props.style {obj|array} this style object or array of it

*** Usage ***

-- General Usage
Specify url path to @props.href same as <a> tag, then navigate path on clicking.
If you want to navigate other pages except relative route, normaly use <a> tag.

Example:
<Link href='/index'>Index</Link>

-- By specifying path including RegExp
If @props.to is specified, seach path by using RegExp from RouteStore and give set to component's href attribute.
Warning: routes are not always up-to-date because @state.routes is not link to
RouteStore state due to a performance probrem.

Example:
<Link to='/.* /deeppage'>DeepPage</Link>

-- By specifying unique route
If @props.uniqRoute is specified, search path by using RegExp from RouteStore and give set to component's
href attribute.
Warning: Even if uniqRoute is not unique, path(for exapmle '.*' including regexp
in the path) is permanently set to href.
Warning: routes are not always up-to-date because @state.routes is not link to
RouteStore state due to a performance probrem.

Example:
<Link uniqRoute='index'>Index</Link>
 */

LinkComponent = (function(superClass) {
  extend(LinkComponent, superClass);

  function LinkComponent(props) {
    LinkComponent.__super__.constructor.call(this, props);
  }

  LinkComponent.prototype.componentWillMount = function() {
    if (this.props.uniqRoute || this.props.to) {
      this.setState({
        routes: this.context.ctx.routeStore.get().routes
      });
    }
    return this.href = '#';
  };

  LinkComponent.prototype.navigate = function(e) {
    e.preventDefault();
    e.stopPropagation();
    return this.context.ctx.routeAction.navigate(this.href);
  };

  LinkComponent.prototype.render = function() {
    var fragment, ref, ref1, route;
    this.href = '#';
    if (this.props.href) {
      this.href = this.props.href;
    } else if (this.props.to) {
      ref = this.state.routes;
      for (fragment in ref) {
        route = ref[fragment];
        if (fragment.match(new RegExp("^" + (this.props.to.replace(/^\//, '').replace(/\//g, '\/')) + "$"))) {
          this.href = "/" + fragment;
          break;
        }
      }
    } else if (this.props.uniqRoute != null) {
      ref1 = this.state.routes;
      for (fragment in ref1) {
        route = ref1[fragment];
        if (route.match(new RegExp("^" + this.props.uniqRoute + "$"))) {
          this.href = "/" + fragment;
          break;
        }
      }
    }
    return React.createElement("a", {
      "href": this.href,
      "onClick": this.navigate.bind(this),
      "style": this.props.style
    }, this.props.children);
  };

  return LinkComponent;

})(React.Component);

LinkComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(LinkComponent);



},{"radium":undefined,"react":undefined}],34:[function(require,module,exports){
var CharIconComponent, Link, ListComponent, ListFolderComponent, ListItemComponent, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('./link-component');

ListFolderComponent = require('./list-folder-component');

ListItemComponent = require('./list-item-component');

CharIconComponent = require('./char-icon-component');

colors = require('./colors/color-definition');

ListComponent = (function(superClass) {
  extend(ListComponent, superClass);

  function ListComponent(props) {
    ListComponent.__super__.constructor.call(this, props);
  }

  ListComponent.prototype.constructNestedList = function(dir_tree) {
    var dir, file, folded, highlight, highlight_styles, return_elm, top, tree;
    return React.createElement("ul", {
      "style": styles.ul
    }, ((function() {
      var ref, ref1;
      return_elm = [];
      if (dir_tree.dir != null) {
        ref = dir_tree.dir;
        for (dir in ref) {
          tree = ref[dir];
          folded = !tree.path.every((function(_this) {
            return function(v, i) {
              return v === _this.props.argu.fragment_arr.slice(1, +tree.path.length + 1 || 9e9)[i];
            };
          })(this));
          return_elm.push((function(_this) {
            return function() {
              return React.createElement("li", {
                "key": dir
              }, React.createElement(ListFolderComponent, {
                "folded": folded,
                "name": dir
              }, React.createElement(ListItemComponent, {
                "type": 'folder',
                "style": styles.item,
                "name": dir
              }, React.createElement("span", {
                "style": styles.item_text
              }, React.createElement("span", {
                "style": styles.clickable
              }, dir))), React.createElement("div", {
                "type": 'children'
              }, _this.constructNestedList(tree))));
            };
          })(this)());
        }
      }
      if (dir_tree.file != null) {
        ref1 = dir_tree.file;
        for (file in ref1) {
          top = ref1[file];
          highlight = top.path.every((function(_this) {
            return function(v, i) {
              return v === _this.props.argu.fragment_arr.slice(1, +top.path.length + 1 || 9e9)[i];
            };
          })(this));
          highlight_styles = {};
          if (highlight) {
            highlight_styles = {
              wrap: {
                backgroundColor: colors.main.n.moderate
              },
              content: {
                color: colors.main.r.emphasis
              }
            };
          }
          return_elm.push((function(_this) {
            return function() {
              return React.createElement("li", {
                "key": file
              }, React.createElement(ListItemComponent, {
                "style": styles.item,
                "update": highlight,
                "name": top.name
              }, React.createElement(CharIconComponent, {
                "char": top.kindString[0],
                "style": [_this.genKindStringStyle(top.kindString), styles.icon]
              }), React.createElement("span", {
                "style": [styles.item_text, highlight_styles.wrap]
              }, React.createElement(Link, {
                "href": "/class/" + (top.path.join('/')),
                "style": [styles.clickable, styles.link, highlight_styles.content]
              }, top.name))));
            };
          })(this)());
        }
      }
      return return_elm;
    }).call(this)));
  };

  ListComponent.prototype.genKindStringStyle = function(kindString) {
    var color, style;
    color = colors.general.r["default"];
    switch (kindString) {
      case 'Class':
        color = '#337BFF';
        break;
      case 'Interface':
        color = '#598213';
        break;
      case 'Enumeration':
        color = '#B17509';
        break;
      case 'Module':
        color = '#D04C35';
        break;
      case 'Function':
        color = '#6E00FF';
        break;
      default:
        color = colors.general.r["default"];
    }
    style = {
      color: color,
      borderColor: color
    };
    return style;
  };

  ListComponent.prototype.shouldComponentUpdate = function(nextProps, nextState) {
    return this.props.argu.route !== nextProps.argu.route;
  };

  ListComponent.prototype.render = function() {
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, this.constructNestedList(this.props.dir_tree));
  };

  return ListComponent;

})(React.Component);

styles = {
  base: {},
  ul: {
    listStyle: 'none',
    paddingLeft: 22
  },
  clickable: {
    cursor: 'pointer'
  },
  link: {
    textDecoration: 'none',
    color: colors.general.r["default"]
  },
  item: {
    display: 'flex',
    display: '-webkit-flex',
    flexDirection: 'row',
    WebkitFlexDirection: 'row',
    flexWrap: 'nowrap',
    WebkitFlexWrap: 'nowrap'
  },
  icon: {
    fontWeight: 'normal',
    cursor: 'default'
  },
  item_text: {
    paddingTop: 5,
    paddingLeft: 6,
    marginRight: 10,
    flexGrow: '1',
    WebkitFlexGrow: '1'
  }
};

ListComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(ListComponent);



},{"./char-icon-component":5,"./colors/color-definition":7,"./link-component":33,"./list-folder-component":35,"./list-item-component":36,"radium":undefined,"react":undefined}],35:[function(require,module,exports){
var CharIconComponent, ListFolderComponent, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

CharIconComponent = require('./char-icon-component');

colors = require('./colors/color-definition');

ListFolderComponent = (function(superClass) {
  extend(ListFolderComponent, superClass);

  function ListFolderComponent(props) {
    ListFolderComponent.__super__.constructor.call(this, props);
  }

  ListFolderComponent.prototype.componentWillMount = function() {
    var ref;
    return this.state = {
      folded: (ref = this.props.folded) != null ? ref : true
    };
  };

  ListFolderComponent.prototype.componentWillReceiveProps = function(nextProps) {
    if (this.state.folded) {
      return this.setState({
        folded: nextProps.folded
      });
    }
  };

  ListFolderComponent.prototype.shouldComponentUpdate = function(nextProps, nextState) {
    return nextState.folded === false || this.state.folded !== nextState.folded;
  };

  ListFolderComponent.prototype.toggle_fold = function() {
    return this.setState({
      folded: !this.state.folded
    });
  };

  ListFolderComponent.prototype.render = function() {
    var return_elm;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, (return_elm = [], React.Children.forEach(this.props.children, (function(_this) {
      return function(child) {
        if (child.props.type === 'folder') {
          return_elm.push((function() {
            return React.createElement("div", {
              "key": 'folder',
              "onClick": _this.toggle_fold.bind(_this)
            }, React.cloneElement(child, {
              prepend: React.createElement(CharIconComponent, {
                "icomoon": (_this.state.folded ? 'plus' : 'minus'),
                "style": styles.toggle
              })
            }));
          })());
        }
        if (child.props.type === 'children') {
          return return_elm.push((function() {
            return React.createElement("div", {
              "key": 'children',
              "style": styles[_this.state.folded ? 'folded' : 'expanded']
            }, child);
          })());
        }
      };
    })(this)), return_elm));
  };

  return ListFolderComponent;

})(React.Component);

styles = {
  base: {},
  folded: {
    display: 'none'
  },
  toggle: {
    cursor: 'pointer',
    color: colors.main.r.emphasis,
    backgroundColor: colors.main.n.moderate,
    borderColor: colors.main.n.moderate
  },
  expanded: {
    display: 'block'
  }
};

ListFolderComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(ListFolderComponent);



},{"./char-icon-component":5,"./colors/color-definition":7,"radium":undefined,"react":undefined}],36:[function(require,module,exports){
var ListItemComponent, Radium, React, colors, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

colors = require('./colors/color-definition');

ListItemComponent = (function(superClass) {
  extend(ListItemComponent, superClass);

  function ListItemComponent(props) {
    ListItemComponent.__super__.constructor.call(this, props);
  }

  ListItemComponent.prototype.shouldComponentUpdate = function(nextProps, nextState) {
    return (this.props.update !== void 0 && nextProps.update !== void 0 && this.props.update !== nextProps.update) || this.props.update === void 0;
  };

  ListItemComponent.prototype.render = function() {
    var append, prepend, return_elm;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, (return_elm = [], prepend = [], append = [], this.props.prepend != null ? (prepend = this.props.prepend instanceof Array ? this.props.prepend : [this.props.prepend], prepend = prepend.map(function(elm, i) {
      return React.cloneElement(elm, {
        key: 'p' + i
      });
    }), return_elm = return_elm.concat(prepend)) : void 0, React.Children.forEach(this.props.children, function(child, i) {
      return return_elm.push((function() {
        return React.cloneElement(child, {
          key: i
        });
      })());
    }), this.props.append != null ? (append = this.props.append instanceof Array ? this.props.append : [this.props.append], append = append.map(function(elm, i) {
      return React.cloneElement(elm, {
        key: 'a' + i
      });
    }), return_elm = return_elm.concat(append)) : void 0, return_elm));
  };

  return ListItemComponent;

})(React.Component);

styles = {
  base: {
    height: 30,
    fontSize: 14,
    WebkitUserSelect: 'none',
    MozUserSelect: 'none',
    color: colors.general.r["default"]
  }
};

ListItemComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(ListItemComponent);



},{"./colors/color-definition":7,"radium":undefined,"react":undefined}],37:[function(require,module,exports){
var App, React, RootComponent,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

App = require('./app-component');

RootComponent = (function(superClass) {
  extend(RootComponent, superClass);

  function RootComponent(props) {
    RootComponent.__super__.constructor.call(this, props);
  }

  RootComponent.prototype.getChildContext = function() {
    return {
      ctx: this.props.context
    };
  };

  RootComponent.prototype.render = function() {
    return React.createElement(App, null);
  };

  return RootComponent;

})(React.Component);

RootComponent.childContextTypes = {
  ctx: React.PropTypes.any
};

module.exports = RootComponent;



},{"./app-component":4,"react":undefined}],38:[function(require,module,exports){
var Radium, React, RouteComponent, Router,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Router = require('../lib/router');


/*
Routing support component

*** Props ***
@props.addStyle {obj|array} active children's style object or array of it
@props.style {obj|array} this style object or array of it

*** Usage ***

-- General routing
Only rendered child component which has @props.route equal to current routing.

Example:
<Route>
  <Index route='index' />
  <About route='about' />
</Route>


-- Inverse routing
Only rendered child component which has @props.route not equal to current routing.

Example:
<Route>
  <Header notroute='index' />
</Route>


-- Only add styles
If @props.addStyle is provided, all children components are visibled, but child
component which has @props.route equals to current routing is given @props.style
specified by @props.addStyle.

Example:
<Route addStyle={styles.active}>
  <li route='index'>Index</li>
  <li route='about'>About</li>
</Route>
styles =
  active:
    backgroundColor: '#f00'


-- Special routing
If children components has no @props.route, always all components are visible.
Children components can get routing by @props.argu and construct individual
routing inside its component. @props.argu is always given in other style of usage.

Summary of @props.argu object:
@props.argu.match {array} match data from fragment
@props.argu.route {string} current route
@props.argu.route_arr {array} current route string splited by ":"
@props.argu.fragment {string} current url fragment
@props.argu.fragment_arr {array} current url fragment splited by "/"

Example:
<Route>
  <List />
</Route>
 */

RouteComponent = (function(superClass) {
  extend(RouteComponent, superClass);

  function RouteComponent(props) {
    RouteComponent.__super__.constructor.call(this, props);
  }

  RouteComponent.prototype._onChange = function() {
    return this.setState(this.store.get());
  };

  RouteComponent.prototype.componentWillMount = function() {
    var state;
    this.store = this.context.ctx.routeStore;
    state = this.store.get();
    this.setState(state);
    this.router = new Router(state.root, state.routes);
    return this.router.setAuth(state.auth);
  };

  RouteComponent.prototype.componentDidMount = function() {
    return this.store.onChange(this._onChange.bind(this));
  };

  RouteComponent.prototype.componentWillUnmount = function() {
    return this.store.removeChangeListener(this._onChange.bind(this));
  };

  RouteComponent.prototype.render = function() {
    return React.createElement("div", {
      "style": this.props.style
    }, this.router.route(this.state.fragment, this.props.logined, (function(_this) {
      return function(route, argu, default_route, fragment, default_fragment) {
        if ((default_route != null) && (default_fragment != null)) {
          _this.context.ctx.routeAction.navigate(fragment, {
            replace: true,
            silent: true
          });
        }
        return React.Children.map(_this.props.children, function(child) {
          var match, route_arr;
          if ((child.props.route != null) || (child.props.notroute != null)) {
            match = false;
            route_arr = route.split(':');
            (child.props.route || child.props.notroute).split(':').forEach(function(r, i) {
              if (r === route_arr[i]) {
                return match = true;
              } else {
                return match = false;
              }
            });
            if (child.props.notroute != null) {
              match = !match;
            }
            if (match) {
              if (_this.props.addStyle != null) {
                return React.cloneElement(child, {
                  argu: argu,
                  style: Array.prototype.concat.apply([], [child.props.style, _this.props.addStyle])
                });
              } else {
                return React.cloneElement(child, {
                  argu: argu
                });
              }
            } else {
              if (_this.props.addStyle != null) {
                return React.cloneElement(child, {
                  argu: argu
                });
              } else {
                return null;
              }
            }
          } else {
            return React.cloneElement(child, {
              argu: argu
            });
          }
        });
      };
    })(this), (function(_this) {
      return function(route, argu, default_route) {
        return React.createElement("h1", null, "404 NotFound");
      };
    })(this)));
  };

  return RouteComponent;

})(React.Component);

RouteComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(RouteComponent);



},{"../lib/router":46,"radium":undefined,"react":undefined}],39:[function(require,module,exports){
var DocSignaturesComponent, DocSignaturesNameComponent, DocSignaturesParametersComponent, DocSignaturesTypeComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocSignaturesNameComponent = require('./doc-signatures-name-component');

DocSignaturesTypeComponent = require('./doc-signatures-type-component');

DocSignaturesParametersComponent = require('./doc-signatures-parameters-component');


/*
name(name?: type.name<typeArgument, ...>[], ...): type.name<typeArgument, ...>[]

@props.signature [required]
@props.name if Accessor, use this as name
@props.emphasisStyle
@props.style
 */

DocSignaturesComponent = (function(superClass) {
  extend(DocSignaturesComponent, superClass);

  function DocSignaturesComponent(props) {
    DocSignaturesComponent.__super__.constructor.call(this, props);
  }

  DocSignaturesComponent.prototype.render = function() {
    var elm, params;
    return React.createElement("span", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, (elm = [], elm.push(React.createElement(DocSignaturesNameComponent, {
      "base": this.props.signature,
      "emphasisStyle": this.props.emphasisStyle,
      "name": this.props.name
    })), params = this.props.signature.parameters, (params == null) && (this.props.signature.kindString === 'Get signature' || this.props.signature.kindString === 'Set signature' || this.props.signature.kindString === 'Call signature' || this.props.signature.kindString === 'Constructor signature') ? params = [] : void 0, params != null ? elm.push(React.createElement(DocSignaturesParametersComponent, {
      "parameters": params,
      "emphasisStyle": this.props.emphasisStyle
    })) : void 0, elm.push(React.createElement("span", null, ": ")), elm.push(React.createElement(DocSignaturesTypeComponent, {
      "type": this.props.signature.type,
      "emphasisStyle": this.props.emphasisStyle
    })), elm));
  };

  return DocSignaturesComponent;

})(React.Component);

styles = {
  base: {}
};

DocSignaturesComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocSignaturesComponent);



},{"./doc-signatures-name-component":40,"./doc-signatures-parameters-component":41,"./doc-signatures-type-component":42,"radium":undefined,"react":undefined}],40:[function(require,module,exports){
var DocSignaturesNameComponent, DocSignaturesTypeargumentsComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocSignaturesTypeargumentsComponent = require('./doc-signatures-typearguments-component');


/*
name?

@props.base [required]
@props.name if Accessor, use this as name
@props.emphasisStyle
@props.style
 */

DocSignaturesNameComponent = (function(superClass) {
  extend(DocSignaturesNameComponent, superClass);

  function DocSignaturesNameComponent(props) {
    DocSignaturesNameComponent.__super__.constructor.call(this, props);
  }

  DocSignaturesNameComponent.prototype.render = function() {
    var elm, name, ref;
    return React.createElement("span", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, (elm = [], this.props.base.kindString === 'Get signature' ? elm.push(React.createElement("span", null, "get ")) : this.props.base.kindString === 'Set signature' ? elm.push(React.createElement("span", null, "set ")) : void 0, name = this.props.base.name, this.props.base.kindString === 'Get signature' || this.props.base.kindString === 'Set signature' ? name = this.props.name : void 0, elm.push(React.createElement("span", {
      "style": this.props.emphasisStyle
    }, name)), (this.props.base.defaultValue != null) || ((ref = this.props.base.flags) != null ? ref.isOptional : void 0) === true ? elm.push(React.createElement("span", null, '?')) : void 0, elm));
  };

  return DocSignaturesNameComponent;

})(React.Component);

styles = {
  base: {}
};

DocSignaturesNameComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocSignaturesNameComponent);



},{"./doc-signatures-typearguments-component":43,"radium":undefined,"react":undefined}],41:[function(require,module,exports){
var DocSignaturesNameComponent, DocSignaturesParametersComponent, DocSignaturesTypeComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocSignaturesNameComponent = require('./doc-signatures-name-component');

DocSignaturesTypeComponent = require('./doc-signatures-type-component');


/*
(name?: type.name<typeArgument, ...>, ...)

@props.parameters [required]
@props.emphasisStyle
@props.style
 */

DocSignaturesParametersComponent = (function(superClass) {
  extend(DocSignaturesParametersComponent, superClass);

  function DocSignaturesParametersComponent(props) {
    DocSignaturesParametersComponent.__super__.constructor.call(this, props);
  }

  DocSignaturesParametersComponent.prototype.render = function() {
    var elm;
    return React.createElement("span", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, (elm = [], elm.push(React.createElement("span", null, "(")), this.props.parameters.forEach((function(_this) {
      return function(prm, i) {
        elm.push(React.createElement(DocSignaturesNameComponent, {
          "base": prm,
          "emphasisStyle": _this.props.emphasisStyle
        }));
        elm.push(React.createElement("span", null, ": "));
        elm.push(React.createElement(DocSignaturesTypeComponent, {
          "type": prm.type,
          "emphasisStyle": _this.props.emphasisStyle
        }));
        if (i !== _this.props.parameters.length - 1) {
          return elm.push(React.createElement("span", null, ", "));
        }
      };
    })(this)), elm.push(React.createElement("span", null, ")")), elm));
  };

  return DocSignaturesParametersComponent;

})(React.Component);

styles = {
  base: {}
};

DocSignaturesParametersComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocSignaturesParametersComponent);



},{"./doc-signatures-name-component":40,"./doc-signatures-type-component":42,"radium":undefined,"react":undefined}],42:[function(require,module,exports){
var DocSignaturesTypeComponent, DocSignaturesTypeargumentsComponent, Link, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('../link-component');

DocSignaturesTypeargumentsComponent = require('./doc-signatures-typearguments-component');


/*
type.name<typeArgument, ...>[]

@props.type [required]
@props.emphasisStyle
@props.style
 */

DocSignaturesTypeComponent = (function(superClass) {
  extend(DocSignaturesTypeComponent, superClass);

  function DocSignaturesTypeComponent(props) {
    DocSignaturesTypeComponent.__super__.constructor.call(this, props);
  }

  DocSignaturesTypeComponent.prototype.render = function() {
    var elm, name, ref, ref1, ref2;
    return React.createElement("span", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, (elm = [], this.props.type == null ? void 0 : (this.props.type.name == null) && this.props.type.type === 'reflection' ? (name = '', ((ref = this.props.type.declaration) != null ? ref.signatures : void 0) != null ? name = 'function' : (((ref1 = this.props.type.declaration) != null ? ref1.children : void 0) != null) || (((ref2 = this.props.type.declaration) != null ? ref2.indexSignature : void 0) != null) ? name = 'object' : void 0, elm.push(React.createElement("span", {
      "style": [this.props.emphasisStyle, styles.oblique]
    }, name))) : (name = this.props.type.type === 'reference' ? React.createElement(Link, {
      "uniqRoute": "class:global:.+:" + this.props.type.id,
      "style": [styles.link, this.props.emphasisStyle, styles.oblique]
    }, this.props.type.name) : React.createElement("span", null, this.props.type.name), elm.push(React.createElement("span", {
      "style": [this.props.emphasisStyle, styles.oblique]
    }, name)), this.props.type.typeArguments ? elm.push(React.createElement(DocSignaturesTypeargumentsComponent, {
      "typeArguments": this.props.type.typeArguments,
      "emphasisStyle": this.props.emphasisStyle
    })) : void 0, this.props.type.isArray ? elm.push(React.createElement("span", null, "[]")) : void 0), elm));
  };

  return DocSignaturesTypeComponent;

})(React.Component);

styles = {
  base: {},
  oblique: {
    fontStyle: 'italic'
  },
  link: {
    textDecoration: 'none',
    cursor: 'pointer',
    ':hover': {
      textDecoration: 'underline'
    }
  }
};

DocSignaturesTypeComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocSignaturesTypeComponent);



},{"../link-component":33,"./doc-signatures-typearguments-component":43,"radium":undefined,"react":undefined}],43:[function(require,module,exports){
var DocSignaturesTypeargumentsComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');


/*
<typeArguments, ...>

@props.typeArguments [required]
@props.emphasisStyle
@props.style
 */

DocSignaturesTypeargumentsComponent = (function(superClass) {
  extend(DocSignaturesTypeargumentsComponent, superClass);

  function DocSignaturesTypeargumentsComponent(props) {
    DocSignaturesTypeargumentsComponent.__super__.constructor.call(this, props);
  }

  DocSignaturesTypeargumentsComponent.prototype.render = function() {
    var elm;
    return React.createElement("span", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, (elm = [], elm.push(React.createElement("span", null, '<')), this.props.typeArguments.forEach((function(_this) {
      return function(targ, i) {
        elm.push(React.createElement("span", {
          "style": [_this.props.emphasisStyle, styles.oblique]
        }, targ.name));
        if (i !== _this.props.typeArguments.length - 1) {
          return elm.push(React.createElement("span", null, ", "));
        }
      };
    })(this)), elm.push(React.createElement("span", null, '>')), elm));
  };

  return DocSignaturesTypeargumentsComponent;

})(React.Component);

styles = {
  base: {},
  oblique: {
    fontStyle: 'italic'
  }
};

DocSignaturesTypeargumentsComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocSignaturesTypeargumentsComponent);



},{"radium":undefined,"react":undefined}],44:[function(require,module,exports){
var Context, DocAction, DocStore, Flux, RouteAction, RouteStore,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Flux = require('material-flux');

RouteAction = require('./actions/route-action');

RouteStore = require('./stores/route-store');

DocAction = require('./actions/doc-action');

DocStore = require('./stores/doc-store');

Context = (function(superClass) {
  extend(Context, superClass);


  /**
   * construct context for flux
   * @param  {Object} initialStates initialize state for stores
   * @return {Context}
   */

  function Context(initialStates) {
    Context.__super__.constructor.apply(this, arguments);
    this.initialStates = initialStates;
    this.routeAction = new RouteAction(this);
    this.routeStore = new RouteStore(this);
    this.docAction = new DocAction(this);
    this.docStore = new DocStore(this);
  }

  return Context;

})(Flux.Context);

module.exports = Context;



},{"./actions/doc-action":2,"./actions/route-action":3,"./stores/doc-store":47,"./stores/route-store":48,"material-flux":undefined}],45:[function(require,module,exports){

/**
 * keys linked to actions
 * @type {Object}
 */
module.exports = {
  route: 'route',
  updateDoc: 'updateDoc'
};



},{}],46:[function(require,module,exports){
var Router, objectAssign;

objectAssign = require('object-assign');

Router = (function() {

  /**
   * Routing support for flux architecture
   * @param  {String} root   root path for pushState
   * @param  {Object} routes object that contains routes corresponed to fragments
   * @return {Router}
   */
  function Router(root, routes) {
    root = '/';
    this.routes = {};
    this.auth = {};
    this.setRoot(root);
    this.setRoute(routes);
  }


  /**
   * set root path for pushState
   * @param {String} root root path for pushState
   */

  Router.prototype.setRoot = function(root) {
    return this.root = (root != null) && root !== '/' ? '/' + this.clearSlashes(root) + '/' : '/';
  };


  /**
   * set object that contains routes corresponed to fragments
   * @param {Object} routes object that contains routes corresponed to fragments
   */

  Router.prototype.setRoute = function(routes) {
    if (routes != null) {
      return this.routes = routes;
    }
  };


  /**
   * add routes
   * @param {String|Object} path fragment; if Object is specifyed, object is used as fragment of routes
   * @param {String?} route      route
   */

  Router.prototype.addRoute = function(path, route) {
    var routes;
    if (route == null) {
      routes = path;
    } else {
      routes = {};
      routes[path] = route;
    }
    return this.routes = objectAssign(this.routes, routes);
  };


  /**
   * set routes for authenticated only
   * @param {String|Object} route if required and renavigate is not specifyed, object is set as unit of auth
   * @param {Boolean} required    if true, renavigate when not authorized. if false, renavigate when authorized
   * @param {String} renavigate   path of renavigation(like redirect)
   */

  Router.prototype.setAuth = function(route, required, renavigate) {
    var auth;
    if (!((required != null) && (renavigate != null))) {
      auth = route;
    } else {
      auth = {};
      auth[route] = {
        required: required,
        renavigate: renavigate
      };
    }
    return this.auth = objectAssign(this.auth, auth);
  };


  /**
   * routing process
   * @param  {String} fragment  fragment of path to route
   * @param  {Boolean} logined  authenticated or not
   * @param  {Function} resolve callback function called when routing succeeded
   * @param  {Function} reject  callback function called when routing failed
   * @return {Any}              returned from callback function
   */

  Router.prototype.route = function(fragment, logined, resolve, reject) {
    var argu, auth, match, match_, r, r_, re, re_, ref, ref1, res;
    if (typeof logined === 'function' && (reject == null)) {
      reject = resolve;
      resolve = logined;
      logined = void 0;
    }
    fragment = fragment.replace(/\?(.*)$/, '');
    fragment = this.clearSlashes(fragment.replace(new RegExp("^" + this.root), ''));
    res = [];
    ref = this.routes;
    for (re in ref) {
      r = ref[re];
      match = fragment.match(new RegExp("^" + re + "$"));
      if (match != null) {
        match.shift();
        argu = {};
        argu.route = r;
        argu.route_arr = r.split(':');
        argu.fragment = fragment;
        argu.fragment_arr = fragment.split('/');
        argu.match = match;
        if (logined != null) {
          auth = this.auth[r];
          if (((auth != null ? auth.required : void 0) === true && !logined) || ((auth != null ? auth.required : void 0) === false && logined)) {
            if (auth.renavigate != null) {
              ref1 = this.routes;
              for (re_ in ref1) {
                r_ = ref1[re_];
                match_ = auth.renavigate.match(new RegExp("^" + re_ + "$"));
                if (match_ != null) {
                  match_.shift();
                  argu = {};
                  argu.route = r_;
                  argu.route_arr = r_.split(':');
                  argu.fragment = auth.renavigate;
                  argu.fragment_arr = auth.renavigate.split('/');
                  argu.match = match_;
                  return typeof resolve === "function" ? resolve(r_, argu, r, auth.renavigate, fragment) : void 0;
                }
              }
              console.warn('\'renavigate\' fragment is not found in routes.');
            } else {
              console.warn('\'renavigate\' is not specified in authenticated route.');
            }
          }
        }
        return typeof resolve === "function" ? resolve(r, argu, null, fragment, null) : void 0;
      }
    }
    return typeof reject === "function" ? reject(null, [], null, fragment, null) : void 0;
  };

  Router.prototype.clearSlashes = function(path) {
    return path.toString().replace(/\/$/, '').replace(/^\//, '');
  };

  return Router;

})();

module.exports = Router;



},{"object-assign":undefined}],47:[function(require,module,exports){
var DocStore, Flux, keys, merge, objectAssign,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Flux = require('material-flux');

keys = require('../keys');

objectAssign = require('object-assign');

merge = require('lodash.merge');

DocStore = (function(superClass) {
  extend(DocStore, superClass);


  /**
   * flux store for doc
   * stores doc objects and tree formed structure of doc
   * @param  {Context} context flux context instance use for initializing state
   * @return {DocStore}
   */

  function DocStore(context) {
    DocStore.__super__.constructor.call(this, context);
    this.state = {
      dir_tree: {},
      doc_data: {}
    };
    this.state = objectAssign(this.state, context.initialStates.DocStore);
    this.register(keys.updateDoc, this.updateDoc);
  }


  /**
   * update doc objects
   * @param  {Object} data fragment of doc data
   */

  DocStore.prototype.updateDoc = function(data) {
    var doc_data;
    doc_data = this.state.doc_data;
    doc_data = merge({}, doc_data, data);
    return this.setState({
      doc_data: doc_data
    });
  };


  /**
   * getter for component
   * @return {Object} stored state
   */

  DocStore.prototype.get = function() {
    return this.state;
  };

  return DocStore;

})(Flux.Store);

module.exports = DocStore;



},{"../keys":45,"lodash.merge":undefined,"material-flux":undefined,"object-assign":undefined}],48:[function(require,module,exports){
var Flux, RouteStore, keys, objectAssign,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Flux = require('material-flux');

keys = require('../keys');

objectAssign = require('object-assign');

RouteStore = (function(superClass) {
  extend(RouteStore, superClass);


  /**
   * flux store for routing
   * stores currnt fragment and route, routes for routing and root for pushState
   * @param  {Context} context flux context instance use for initializing state
   * @return {RouteStore}
   */

  function RouteStore(context) {
    RouteStore.__super__.constructor.call(this, context);
    this.state = {
      fragment: '/',
      root: '/',
      routes: null,
      auth: null
    };
    this.state = objectAssign(this.state, context.initialStates.RouteStore);
    this.register(keys.route, this.route);
    if (this.state.routes == null) {
      throw new Error('state.routes must be specifyed by initialState.');
    }
  }


  /**
   * update current fragment and route
   * @param  {fragment} fragment current fragment
   */

  RouteStore.prototype.route = function(fragment) {
    console.log('route:', this.state.fragment, '->', fragment);
    return this.setState({
      fragment: fragment
    });
  };


  /**
   * getter for component
   * @return {Object} stored state
   */

  RouteStore.prototype.get = function() {
    return this.state;
  };

  return RouteStore;

})(Flux.Store);

module.exports = RouteStore;



},{"../keys":45,"material-flux":undefined,"object-assign":undefined}],49:[function(require,module,exports){

/*
@providesModule Docs
 */
var Docs, Promise, clone, config, fs, request;

fs = require('fs');

config = require('./stateInitializer/initializeStateConfig');

clone = require('lodash.clone');

request = require('request');

Promise = require('bluebird');

Docs = (function() {

  /**
   * Convert TypeDoc json to Docs object
   * @return {Docs}
   */
  function Docs() {
    this.json = {};
  }


  /**
   * set periodic interval timer to get json
   * @param  {Number}   interval timer interval (second)
   * @param  {Function} cb       callback function called on reseived json
   */

  Docs.prototype.getJsonScheduler = function(interval, cb) {
    if ("production" === 'production') {
      this.getRemoteJson(cb);
    } else if ("production" === 'development') {
      this.getLocalJson(cb);
    }
    console.log('got json');
    return setTimeout((function(_this) {
      return function() {
        return _this.getJsonScheduler(interval, cb);
      };
    })(this), interval * 1000);
  };


  /**
   * set external json object
   * @param {Object} json doc json object
   */

  Docs.prototype.setJson = function(json) {
    return this.json = json;
  };


  /**
   * load json from directory
   * @param  {Function} cb callback function on loaded
   */

  Docs.prototype.getLocalJson = function(cb) {
    this.json = JSON.parse(fs.readFileSync(config.typedoc.path_to_json));
    return cb();
  };


  /**
   * request json
   * @param  {Function} cb callback function on resolved request
   */

  Docs.prototype.getRemoteJson = function(cb) {
    var options;
    options = {
      url: 'https://raw.githubusercontent.com/jThreeJS/jThree/gh-pages/docs/develop.json',
      json: true
    };
    return new Promise(function(resolve, reject) {
      return request.get(options, function(error, response, body) {
        if (!error && response.statusCode === 200) {
          return resolve(body);
        } else {
          return reject(error);
        }
      });
    }).then((function(_this) {
      return function(res) {
        _this.json = res;
        return cb();
      };
    })(this))["catch"](function(err) {
      return console.log("get error: " + err);
    });
  };


  /**
   * get global class(factor) typedoc json as object
   * @param  {String|Number} file_id   id of child of doc root
   * @param  {String|Number} factor_id id of grandchild of doc root
   * @return {Object}                  object of specifyed class(factor) in typedoc
   */

  Docs.prototype.getGlobalClassById = function(file_id, factor_id) {
    var child, gchild, i, j, len, len1, ref, ref1;
    ref = this.json.children;
    for (i = 0, len = ref.length; i < len; i++) {
      child = ref[i];
      if (child.id === parseInt(file_id, 10)) {
        ref1 = child.children;
        for (j = 0, len1 = ref1.length; j < len1; j++) {
          gchild = ref1[j];
          if (gchild.id === parseInt(factor_id, 10)) {
            return gchild;
          }
        }
      }
    }
    return null;
  };


  /**
   * get global file typedoc json as object not including children
   * @param  {String|Number} file_id id of child of doc root
   * @return {Object}                object of specifyed file in typedoc
   */

  Docs.prototype.getGlobalFileById = function(file_id) {
    var c, child, i, len, ref;
    ref = this.json.children;
    for (i = 0, len = ref.length; i < len; i++) {
      child = ref[i];
      if (child.id === parseInt(file_id, 10)) {
        c = clone(child, true);
        delete c.children;
        delete c.groups;
        return c;
      }
    }
    return null;
  };


  /**
   * Costruct doc_data object formed for doc store
   * @param  {String|Number} file_id   id of child of doc root
   * @param  {String|Number} factor_id id of grandchild of doc root
   * @return {Object}                  object of doc_data specifyed by id of file and factor
   */

  Docs.prototype.getDocDataById = function(file_id, factor_id) {
    var data, doc_data, from;
    data = this.getGlobalClassById(file_id, factor_id);
    from = this.getGlobalFileById(file_id);
    doc_data = {};
    if ((from != null) && (data != null)) {
      doc_data[file_id] = {};
      doc_data[file_id].from = from;
      doc_data[file_id][factor_id] = data;
    }
    return doc_data;
  };

  return Docs;

})();

module.exports = Docs;



},{"./stateInitializer/initializeStateConfig":52,"bluebird":undefined,"fs":undefined,"lodash.clone":undefined,"request":undefined}],50:[function(require,module,exports){
var DirTree, Docs, InitializeState, Router, RoutesGen, config;

RoutesGen = require('./stateInitializer/routes-gen');

config = require('./stateInitializer/initializeStateConfig');

DirTree = require('./stateInitializer/dir-tree');

Docs = require('./docs');

Router = require('../renderer/lib/router');

InitializeState = (function() {

  /**
   * initialize state for stores in client
   * @return {InitializeState}
   */
  function InitializeState(docs) {
    this.docs = docs;
    this.routeGen = new RoutesGen();
    this.dirTree = new DirTree();
    this.router = new Router(config.router.root, this.routeGen.routes);
  }


  /**
   * resetup state initializer
   */

  InitializeState.prototype.gen = function() {
    this.routeGen.gen(this.docs.json);
    this.dirTree.gen(this.docs.json);
    return this.router.setRoute(this.routeGen.routes);
  };


  /**
   * initialize state
   * @param  {Object} req request from express
   * @return {Object}     initialized state
   */

  InitializeState.prototype.initialize = function(req) {
    var initialState, initial_doc_data;
    initial_doc_data = {};
    this.router.route(req.originalUrl, (function(_this) {
      return function(route, argu) {
        var factor_id, file_id, ref, ref1;
        file_id = (ref = argu.route_arr[2]) != null ? ref.toString() : void 0;
        factor_id = (ref1 = argu.route_arr[3]) != null ? ref1.toString() : void 0;
        if ((file_id != null) && (factor_id != null)) {
          return initial_doc_data = _this.docs.getDocDataById(file_id, factor_id);
        }
      };
    })(this));
    initialState = {
      RouteStore: {
        fragment: req.originalUrl,
        root: config.router.root,
        routes: this.router.routes
      },
      DocStore: {
        dir_tree: this.dirTree.dir_tree,
        doc_data: initial_doc_data
      }
    };
    return initialState;
  };

  return InitializeState;

})();

module.exports = InitializeState;



},{"../renderer/lib/router":46,"./docs":49,"./stateInitializer/dir-tree":51,"./stateInitializer/initializeStateConfig":52,"./stateInitializer/routes-gen":53}],51:[function(require,module,exports){

/*
@providesModule DirTree
 */
var DirTree, merge, objectAssign;

objectAssign = require('object-assign');

merge = require('lodash.merge');


/*
Construt tree formed object by analizing the name of
the global class in typedoc json.

Construct dir_tree like below.

-- path
a/file1 obj1
a/b/file2 obj2

-- routes
{
  dir: {
    a: {
      dir: {
        b: {
          file: {
            class2: obj2
          }
        }
      },
      file: {
        class1: obj1
      }
    }
  }
}
 */

DirTree = (function() {
  var arrayToDirTree, constructDirTree;

  function DirTree(json) {
    this.dir_tree = constructDirTree(json);
  }


  /**
   * Construt tree formed object by analizing the name of
   * the global class in typedoc json.
   * @param  {Object} json typedoc json
   */

  DirTree.prototype.gen = function(json) {
    return this.dir_tree = constructDirTree(json);
  };


  /**
   * construct tree formed object from docs json
   * @param  {Object} json typedoc json
   * @return {Object}      tree formed object
   */

  constructDirTree = function(json) {
    var dir_tree, ref;
    dir_tree = {};
    if (json != null) {
      if ((ref = json.children) != null) {
        ref.forEach(function(child, i) {
          var arr;
          arr = child.name.replace(/"/g, '').split('/');
          return dir_tree = merge({}, dir_tree, arrayToDirTree(arr, child));
        });
      }
    }
    return dir_tree;
  };


  /**
   * construct no branched tree recursively by array
   * @param  {Array} arr     construct nested hash by following this
   * @param  {Object} top    the top of nested hash
   * @param  {Array} def_arr this parameter used in recurrence
   * @return {Object}        fragment of tree formed object
   */

  arrayToDirTree = function(arr, top, def_arr) {
    var ref, res;
    res = {};
    if (def_arr == null) {
      res.path = [];
    } else {
      res.path = def_arr.slice(0, +(-(arr.length + 1)) + 1 || 9e9);
    }
    if (arr.length === 1) {
      res.file = {};
      if ((ref = top.children) != null) {
        ref.forEach(function(gchild) {
          return res.file[gchild.name] = {
            name: gchild.name,
            kindString: gchild.kindString,
            path: (def_arr != null ? def_arr : arr).slice(0, -1).concat([gchild.name]),
            children: (gchild.children || []).map(function(ggchild) {
              return {
                name: ggchild.name,
                kindString: ggchild.kindString
              };
            })
          };
        });
      }
    } else {
      res.dir = {};
      res.dir[arr[0]] = arrayToDirTree(arr.slice(1), top, def_arr != null ? def_arr : arr);
    }
    return res;
  };

  return DirTree;

})();

module.exports = DirTree;



},{"lodash.merge":undefined,"object-assign":undefined}],52:[function(require,module,exports){
var fs;

fs = require('fs');


/**
 * configuration of stateInitializer
 * @type {Object}
 */

module.exports = {
  typedoc: {
    path_to_json: './src/server/doc.json'
  },
  router: {
    root: '/'
  }
};



},{"fs":undefined}],53:[function(require,module,exports){
var RoutesGen, objectAssign;

objectAssign = require('object-assign');

RoutesGen = (function() {

  /**
   * Routes generator
   * @param  {Object} json typedoc json
   * @return {RoutesGen}
   */
  var constructClassRoutes, constructErrorRoutes, constructIndexRoutes;

  function RoutesGen(json) {
    this.routes = {};
    this._constructRoutes(json);
  }


  /**
   * regenerate routes
   * @param  {Object} json typedoc json
   * @return {Object}      routes
   */

  RoutesGen.prototype.gen = function(json) {
    return this._constructRoutes(json);
  };


  /**
   * construct routes
   * @param  {Object} json typedoc json
   * @return {Object}      merged fragment of routes
   */

  RoutesGen.prototype._constructRoutes = function(json) {
    this.routes = {};
    this.routes = objectAssign({}, this.routes, constructClassRoutes(json));
    this.routes = objectAssign({}, this.routes, constructIndexRoutes());
    return this.routes = objectAssign({}, this.routes, constructErrorRoutes());
  };


  /**
   * construct class route
   * @param  {Object} json typedoc json
   * @return {Object}      fragment of routes
   */

  constructClassRoutes = function(json) {
    var prefix, ref, routes;
    prefix = 'class';
    routes = {};
    if (json != null) {
      if ((ref = json.children) != null) {
        ref.forEach(function(child, i) {
          var dir, dir_arr;
          dir = child.name.replace(/\"/g, '');
          dir_arr = dir.split('/');
          return dir_arr.forEach(function(d, j) {
            var ref1;
            if (j !== dir_arr.length - 1) {
              return routes[prefix + "/" + (dir_arr.slice(0, +j + 1 || 9e9).join('/'))] = prefix + ":global";
            } else {
              return (ref1 = child.children) != null ? ref1.forEach(function(gchild) {
                var ref2;
                routes["" + prefix + (dir_arr.length === 1 ? '' : '/' + dir_arr.slice(0, +(j - 1) + 1 || 9e9).join('/')) + "/" + gchild.name] = prefix + ":global:" + child.id + ":" + gchild.id;
                return (ref2 = gchild.children) != null ? ref2.forEach(function(ggchild) {
                  return routes["" + prefix + (dir_arr.length === 1 ? '' : '/' + dir_arr.slice(0, +(j - 1) + 1 || 9e9).join('/')) + "/" + gchild.name + "/" + ggchild.name] = prefix + ":local:" + child.id + ":" + gchild.id + ":" + ggchild.id;
                }) : void 0;
              }) : void 0;
            }
          });
        });
      }
    }
    routes["" + prefix] = "" + prefix;
    return routes;
  };


  /**
   * construct index route
   * @return {Object} fragment of routes
   */

  constructIndexRoutes = function() {
    var routes;
    routes = {
      '': 'index'
    };
    return routes;
  };


  /**
   * construct error routes
   * @return {Object} fragment of routes
   */

  constructErrorRoutes = function() {
    var routes;
    routes = {
      '.*': 'error'
    };
    return routes;
  };

  return RoutesGen;

})();

module.exports = RoutesGen;



},{"object-assign":undefined}]},{},[1])

