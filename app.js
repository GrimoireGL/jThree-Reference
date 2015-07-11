(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Context, Docs, Handlebars, InitializeState, React, Root, docs, express, fs, initializeState, server, template;

if ("production" === 'development') {
  require('source-map-support').install();
}

express = require('express');

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

template = Handlebars.compile(fs.readFileSync((fs.realpathSync('./')) + "/view/index.hbs").toString());

server.get('/favicon.ico', function(req, res) {});

docs = new Docs();

initializeState = new InitializeState(docs);

docs.getJsonScheduler(3 * 60 * 60, function() {
  return initializeState.gen();
});

server.get('/api/class/global/:file_id/:factor_id', function(req, res) {
  console.log(req.originalUrl);
  return res.json(docs.getDocDataById(req.params.file_id, req.params.factor_id));
});

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



},{"./renderer/components/root-component":29,"./renderer/context":31,"./server/docs":36,"./server/initializeState":37,"express":undefined,"fs":undefined,"handlebars":undefined,"react":undefined,"source-map-support":undefined}],2:[function(require,module,exports){
var DocAction, Flux, Promise, keys, request,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Flux = require('material-flux');

keys = require('../keys');

request = require('superagent');

Promise = require('bluebird');

DocAction = (function(superClass) {
  extend(DocAction, superClass);

  function DocAction() {
    DocAction.__super__.constructor.apply(this, arguments);
  }

  DocAction.prototype.updateDoc = function(file_id, factor_id) {
    console.log('request', (+new Date()).toString().slice(-4));
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
        console.log(res);
        console.log('request end', (+new Date()).toString().slice(-4));
        return _this.dispatch(keys.updateDoc, res);
      };
    })(this))["catch"](function(err) {
      return console.error(err);
    });
  };

  return DocAction;

})(Flux.Action);

module.exports = DocAction;



},{"../keys":32,"bluebird":undefined,"material-flux":undefined,"superagent":undefined}],3:[function(require,module,exports){
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

  RouteAction.prototype.clearSlashes = function(path) {
    return path.toString().replace(/\/$/, '').replace(/^\//, '');
  };

  return RouteAction;

})(Flux.Action);

module.exports = RouteAction;



},{"../keys":32,"html5-history":undefined,"material-flux":undefined}],4:[function(require,module,exports){
var AppComponent, ClassDocComponent, ErrorComponent, HeaderComponent, IndexComponent, Link, React, Route,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

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

  AppComponent.prototype.render = function() {
    return React.createElement("div", null, React.createElement(HeaderComponent, null), React.createElement(Route, null, React.createElement(IndexComponent, {
      "route": 'index'
    }), React.createElement(ClassDocComponent, {
      "route": 'class'
    }), React.createElement(ErrorComponent, {
      "route": 'error'
    })));
  };

  return AppComponent;

})(React.Component);

AppComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = AppComponent;



},{"./classdoc-component":6,"./error-component":22,"./header-component":23,"./index-component":24,"./link-component":25,"./route-component":30,"react":undefined}],5:[function(require,module,exports){
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
    return React.createElement("span", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
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
    textAlign: 'center'
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
    flexDirection: 'row',
    flexWrap: 'nowrap'
  },
  list: {
    boxSizing: 'border-box',
    paddingLeft: 10,
    paddingTop: 10,
    width: 360,
    minWidth: 360,
    borderRightWidth: 1,
    borderRightColor: '#ccc',
    borderRightStyle: 'solid'
  },
  container: {
    flexGrow: '1',
    display: 'flex',
    flexDirection: 'column',
    flexWrap: 'nowrap'
  },
  doc_wrapper: {
    display: 'flex',
    flexDirection: 'row',
    flexWrap: 'nowrap',
    flex: '1'
  },
  doc_container: {},
  doc_detail_container: {
    flexGrow: '1'
  }
};

ClassDocComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(ClassDocComponent);



},{"./doc-container-component":7,"./doc-detail-container-component":9,"./doc-slide-wrapper-component":19,"./list-component":26,"./route-component":30,"radium":undefined,"react":undefined}],7:[function(require,module,exports){
var DocContainerComponents, DocDescriptionComponent, DocFactorItemComponent, DocTitleComponent, Link, Radium, React, Route, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Route = require('./route-component');

Link = require('./link-component');

DocTitleComponent = require('./doc-title-component');

DocDescriptionComponent = require('./doc-description-component');

DocFactorItemComponent = require('./doc-factor-item-component');

DocContainerComponents = (function(superClass) {
  extend(DocContainerComponents, superClass);

  function DocContainerComponents(props) {
    DocContainerComponents.__super__.constructor.call(this, props);
  }

  DocContainerComponents.prototype.close = function() {
    var ref;
    if (((ref = this.props.argu.route_arr[1]) != null ? ref.toString() : void 0) === 'local') {
      return this.context.ctx.routeAction.navigate(document.location.pathname.match(/^(.+)\/[^\/]+$/)[1]);
    }
  };

  DocContainerComponents.prototype.render = function() {
    var current, factor_id, file_id, group, ref, ref1;
    file_id = (ref = this.props.argu.route_arr[2]) != null ? ref.toString() : void 0;
    factor_id = (ref1 = this.props.argu.route_arr[3]) != null ? ref1.toString() : void 0;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, ((function() {
      var ref2, ref3;
      if ((file_id != null) && (factor_id != null)) {
        current = (ref2 = this.props.doc_data[file_id]) != null ? ref2[factor_id] : void 0;
        if (current != null) {
          return React.createElement("div", null, React.createElement(DocTitleComponent, {
            "current": current,
            "from": this.props.doc_data[file_id].from,
            "collapsed": this.props.collapsed
          }), (!this.props.collapsed ? React.createElement(DocDescriptionComponent, {
            "text": ((ref3 = current.comment) != null ? ref3.shortText : void 0)
          }) : void 0), ((function() {
            var i, len, ref4, results;
            if (current.groups != null) {
              ref4 = current.groups;
              results = [];
              for (i = 0, len = ref4.length; i < len; i++) {
                group = ref4[i];
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
            this.context.ctx.docAction.updateDoc(file_id, factor_id);
          } else {
            throw new Error('doc_data must be initialized by initialStates');
          }
          return React.createElement("span", null, "Loading...");
        }
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



},{"./doc-description-component":8,"./doc-factor-item-component":15,"./doc-title-component":21,"./link-component":25,"./route-component":30,"radium":undefined,"react":undefined}],8:[function(require,module,exports){
var DocDescriptionComponent, DocItemComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocItemComponent = require('./doc-item-component');


/*
@props.text description text
 */

DocDescriptionComponent = (function(superClass) {
  extend(DocDescriptionComponent, superClass);

  function DocDescriptionComponent(props) {
    DocDescriptionComponent.__super__.constructor.call(this, props);
  }

  DocDescriptionComponent.prototype.render = function() {
    var alt_text, ref;
    alt_text = 'no description';
    return React.createElement(DocItemComponent, {
      "title": 'Description',
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement("div", {
      "style": styles.content
    }, (ref = this.props.text) != null ? ref : alt_text));
  };

  return DocDescriptionComponent;

})(React.Component);

styles = {
  base: {},
  content: {
    color: '#333'
  }
};

DocDescriptionComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocDescriptionComponent);



},{"./doc-item-component":17,"radium":undefined,"react":undefined}],9:[function(require,module,exports){
var DocDescriptionComponent, DocDetailContainerComponent, DocDetailParameterComponent, DocDetailReturnComponent, DocDetailTitleComponent, DocSlideWrapperComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocDetailTitleComponent = require('./doc-detail-title-component');

DocSlideWrapperComponent = require('./doc-slide-wrapper-component');

DocDescriptionComponent = require('./doc-description-component');

DocDetailParameterComponent = require('./doc-detail-parameters-component');

DocDetailReturnComponent = require('./doc-detail-return-components');

DocDetailContainerComponent = (function(superClass) {
  extend(DocDetailContainerComponent, superClass);

  function DocDetailContainerComponent(props) {
    DocDetailContainerComponent.__super__.constructor.call(this, props);
  }

  DocDetailContainerComponent.prototype.render = function() {
    var c, current, current_local, factor_id, file_id, local_factor_id, ref, ref1, ref2;
    file_id = (ref = this.props.argu.route_arr[2]) != null ? ref.toString() : void 0;
    factor_id = (ref1 = this.props.argu.route_arr[3]) != null ? ref1.toString() : void 0;
    local_factor_id = (ref2 = this.props.argu.route_arr[4]) != null ? ref2.toString() : void 0;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, ((function() {
      var i, len, ref3, ref4, ref5, ref6, ref7, ref8;
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
            return React.createElement("div", null, React.createElement(DocDetailTitleComponent, {
              "current": current_local,
              "from": current
            }), React.createElement(DocDescriptionComponent, {
              "text": ((ref6 = current_local.signatures) != null ? (ref7 = ref6[0].comment) != null ? ref7.shortText : void 0 : void 0)
            }), (((ref8 = current_local.signatures) != null ? ref8[0].parameters : void 0) != null ? React.createElement(DocDetailParameterComponent, {
              "current": current_local
            }) : void 0), (current_local.signatures != null ? React.createElement(DocDetailReturnComponent, {
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



},{"./doc-description-component":8,"./doc-detail-parameters-component":11,"./doc-detail-return-components":12,"./doc-detail-title-component":14,"./doc-slide-wrapper-component":19,"radium":undefined,"react":undefined}],10:[function(require,module,exports){
var DocDetailParameterTableComponent, DocTableComponent, Link, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('./link-component');

DocTableComponent = require('./doc-table-component');


/*
@props.current [required] local current which is child of current factor
 */

DocDetailParameterTableComponent = (function(superClass) {
  extend(DocDetailParameterTableComponent, superClass);

  function DocDetailParameterTableComponent(props) {
    DocDetailParameterTableComponent.__super__.constructor.call(this, props);
  }

  DocDetailParameterTableComponent.prototype.render = function() {
    var alt_text, elm, i, prm, table, table_row;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, ((function() {
      var j, len, ref, ref1, ref2, ref3, ref4;
      table = [];
      ref = this.props.current.signatures[0].parameters;
      for (i = j = 0, len = ref.length; j < len; i = ++j) {
        prm = ref[i];
        alt_text = 'no description';
        table_row = [];
        table_row.push(React.createElement("span", null, prm.name));
        elm = [];
        elm.push(React.createElement("span", {
          "style": [styles.emphasis, styles.oblique]
        }, prm.type.name));
        if (prm.type.typeArguments != null) {
          elm.push(React.createElement("span", null, '<'));
          prm.type.typeArguments.forEach(function(targ, i) {
            elm.push(React.createElement("span", {
              "style": [styles.emphasis, styles.oblique]
            }, targ.name));
            if (i !== prm.type.typeArguments.length - 1) {
              return elm.push(React.createElement("span", null, ", "));
            }
          });
          elm.push(React.createElement("span", null, '>'));
        }
        if (prm.type.isArray) {
          elm.push(React.createElement("span", null, "[]"));
        }
        table_row.push(React.createElement("span", {
          "style": styles.type
        }, elm));
        table_row.push(React.createElement("span", null, (ref1 = (ref2 = prm.comment) != null ? ref2.shortText : void 0) != null ? ref1 : (ref3 = (ref4 = prm.comment) != null ? ref4.text : void 0) != null ? ref3 : alt_text));
        table.push(table_row);
      }
      return React.createElement(DocTableComponent, {
        "prefix": this.props.current.id + "-prm",
        "table": table
      });
    }).call(this)));
  };

  return DocDetailParameterTableComponent;

})(React.Component);

styles = {
  base: {},
  type: {
    color: '#bbb'
  },
  oblique: {
    fontStyle: 'italic'
  },
  emphasis: {
    color: '#333'
  },
  link: {
    color: '#000',
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



},{"./doc-table-component":20,"./link-component":25,"radium":undefined,"react":undefined}],11:[function(require,module,exports){
var DocDetailParameterTableComponent, DocDetailParametersComponent, DocItemComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocDetailParameterTableComponent = require('./doc-detail-parameter-table-component');

DocItemComponent = require('./doc-item-component');


/*
@props.current [required] local current which is child of current factor
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
    }, React.createElement(DocDetailParameterTableComponent, {
      "current": this.props.current,
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



},{"./doc-detail-parameter-table-component":10,"./doc-item-component":17,"radium":undefined,"react":undefined}],12:[function(require,module,exports){
var DocDetailReturnComponent, DocDetailReturnTableComponent, DocItemComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocDetailReturnTableComponent = require('./doc-detail-return-table-component');

DocItemComponent = require('./doc-item-component');


/*
@props.current [required] local current which is child of current factor
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



},{"./doc-detail-return-table-component":13,"./doc-item-component":17,"radium":undefined,"react":undefined}],13:[function(require,module,exports){
var DocDetailReturnTableComponent, DocTableComponent, Link, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('./link-component');

DocTableComponent = require('./doc-table-component');


/*
@props.current [required] local current which is child of current factor
 */

DocDetailReturnTableComponent = (function(superClass) {
  extend(DocDetailReturnTableComponent, superClass);

  function DocDetailReturnTableComponent(props) {
    DocDetailReturnTableComponent.__super__.constructor.call(this, props);
  }

  DocDetailReturnTableComponent.prototype.render = function() {
    var alt_text, elm, prm, table, table_row;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, (table = [], alt_text = 'no description', table_row = [], prm = this.props.current.signatures[0], elm = [], elm.push(React.createElement("span", {
      "style": [styles.emphasis, styles.oblique]
    }, prm.type.name)), prm.type.typeArguments != null ? (elm.push(React.createElement("span", null, '<')), prm.type.typeArguments.forEach(function(targ, i) {
      elm.push(React.createElement("span", {
        "style": [styles.emphasis, styles.oblique]
      }, targ.name));
      if (i !== prm.type.typeArguments.length - 1) {
        return elm.push(React.createElement("span", null, ", "));
      }
    }), elm.push(React.createElement("span", null, '>'))) : void 0, prm.type.isArray ? elm.push(React.createElement("span", null, "[]")) : void 0, table_row.push(React.createElement("span", {
      "style": styles.type
    }, elm)), table_row.push(React.createElement("span", null, alt_text)), table.push(table_row), React.createElement(DocTableComponent, {
      "prefix": this.props.current.id + "-rtn",
      "table": table
    })));
  };

  return DocDetailReturnTableComponent;

})(React.Component);

styles = {
  base: {},
  type: {
    color: '#bbb'
  },
  oblique: {
    fontStyle: 'italic'
  },
  emphasis: {
    color: '#333'
  },
  link: {
    color: '#000',
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



},{"./doc-table-component":20,"./link-component":25,"radium":undefined,"react":undefined}],14:[function(require,module,exports){
var DocDetailTitleComponent, DocSignaturesComponent, Link, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('./link-component');

DocSignaturesComponent = require('./doc-signatures-component');

DocDetailTitleComponent = (function(superClass) {
  extend(DocDetailTitleComponent, superClass);

  function DocDetailTitleComponent(props) {
    DocDetailTitleComponent.__super__.constructor.call(this, props);
  }

  DocDetailTitleComponent.prototype.genKindStringStyle = function(kindString) {
    var color, style;
    color = '#333333';
    switch (kindString) {
      case 'Constructor':
        color = '#337BFF';
        break;
      case 'Property':
        color = '#598213';
        break;
      case 'Method':
        color = '#6E00FF';
        break;
      case 'Accessor':
        color = '#D04C35';
        break;
      case 'Enumeration member':
        color = '#B17509';
        break;
      default:
        color = '#333333';
    }
    return style = {
      color: color,
      borderColor: color
    };
  };

  DocDetailTitleComponent.prototype.render = function() {
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement("div", {
      "style": styles.title_wrap
    }, React.createElement("div", {
      "style": [styles.kind_string, this.genKindStringStyle(this.props.current.kindString)]
    }, this.props.current.kindString), React.createElement("div", {
      "style": [styles.title]
    }, React.createElement("span", null, "."), React.createElement("span", null, this.props.current.name))), React.createElement(DocSignaturesComponent, {
      "style": styles.signatures,
      "current": this.props.current
    }));
  };

  return DocDetailTitleComponent;

})(React.Component);

styles = {
  base: {
    marginBottom: 40
  },
  title_wrap: {
    overflow: 'hidden'
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
    float: 'left',
    borderRadius: 7
  },
  title: {
    fontSize: 35,
    paddingLeft: 12,
    paddingRight: 12,
    marginLeft: 10,
    color: '#000',
    float: 'left',
    fontWeight: 'bold'
  },
  title_from: {
    textDecoration: 'underline',
    cursor: 'pointer'
  },
  signatures: {
    marginTop: 23
  }
};

DocDetailTitleComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocDetailTitleComponent);



},{"./doc-signatures-component":18,"./link-component":25,"radium":undefined,"react":undefined}],15:[function(require,module,exports){
var DocFactorItemComponent, DocFactorTableComponent, DocItemComponent, Radium, React,
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
      "style": Array.prototype.concat.apply([], [this.props.style, dstyle.base]),
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

DocFactorItemComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocFactorItemComponent);



},{"./doc-factor-table-component":16,"./doc-item-component":17,"radium":undefined,"react":undefined}],16:[function(require,module,exports){
var DocFactorTableComponent, DocTableComponent, Link, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('./link-component');

DocTableComponent = require('./doc-table-component');


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
    var alt_text, c, cellStyles, child, dstyle, i, id, table, table_row;
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
      var j, k, len, len1, ref, ref1, ref2, ref3;
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
          table_row.push(React.createElement("span", null, (ref2 = (ref3 = child.comment) != null ? ref3.shortText : void 0) != null ? ref2 : alt_text));
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
  link: {
    color: '#000',
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



},{"./doc-table-component":20,"./link-component":25,"radium":undefined,"react":undefined}],17:[function(require,module,exports){
var DocItemComponent, DocTableComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocTableComponent = require('./doc-table-component');


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
    fontWeight: 'bold'
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



},{"./doc-table-component":20,"radium":undefined,"react":undefined}],18:[function(require,module,exports){
var DocSignaturesComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocSignaturesComponent = (function(superClass) {
  extend(DocSignaturesComponent, superClass);

  function DocSignaturesComponent(props) {
    DocSignaturesComponent.__super__.constructor.call(this, props);
  }

  DocSignaturesComponent.prototype.render = function() {
    var c, dstyle, elm, ref;
    c = this.props.current;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style, styles.code])
    }, (elm = [], c.signatures != null ? (elm.push(React.createElement("span", {
      "style": styles.emphasis
    }, c.signatures[0].name)), elm.push(React.createElement("span", null, "(")), (ref = c.signatures[0].parameters) != null ? ref.forEach(function(prm, i) {
      elm.push(React.createElement("span", {
        "style": styles.emphasis
      }, prm.name));
      if (prm.defaultValue != null) {
        elm.push(React.createElement("span", null, '?'));
      }
      elm.push(React.createElement("span", null, ": "));
      elm.push(React.createElement("span", {
        "style": [styles.emphasis, styles.oblique]
      }, prm.type.name));
      if (prm.type.typeArguments != null) {
        elm.push(React.createElement("span", null, '<'));
        prm.type.typeArguments.forEach(function(targ, i) {
          elm.push(React.createElement("span", {
            "style": [styles.emphasis, styles.oblique]
          }, targ.name));
          if (i !== prm.type.typeArguments.length - 1) {
            return elm.push(React.createElement("span", null, ", "));
          }
        });
        elm.push(React.createElement("span", null, '>'));
      }
      if (prm.type.isArray) {
        elm.push(React.createElement("span", null, "[]"));
      }
      if (i !== c.signatures[0].parameters.length - 1) {
        return elm.push(React.createElement("span", null, ", "));
      }
    }) : void 0, elm.push(React.createElement("span", null, ")")), elm.push(React.createElement("span", null, ": ")), elm.push(React.createElement("span", {
      "style": [styles.emphasis, styles.oblique]
    }, c.signatures[0].type.name))) : c.type != null ? (elm.push(React.createElement("span", {
      "style": styles.emphasis
    }, c.name)), elm.push(React.createElement("span", null, ": ")), elm.push(React.createElement("span", {
      "style": [styles.emphasis, styles.oblique]
    }, c.type.name)), c.type.typeArguments != null ? (elm.push(React.createElement("span", null, '<')), c.type.typeArguments.forEach(function(targ, i) {
      elm.push(React.createElement("span", {
        "style": [styles.emphasis, styles.oblique]
      }, targ.name));
      if (i !== c.type.typeArguments.length - 1) {
        return elm.push(React.createElement("span", null, ", "));
      }
    }), elm.push(React.createElement("span", null, '>'))) : void 0, c.type.isArray ? elm.push(React.createElement("span", null, "[]")) : void 0) : (c.getSignature != null) || (c.setSignature != null) ? (dstyle = {}, (c.getSignature != null) && (c.setSignature != null) ? dstyle = {
      get_signature: {
        paddingBottom: 11,
        borderBottomWidth: 1,
        borderBottomStyle: 'solid',
        borderBottomColor: '#555'
      },
      set_signature: {
        paddingTop: 10
      }
    } : void 0, c.getSignature != null ? elm.push((function() {
      return React.createElement("div", {
        "style": dstyle.get_signature
      }, React.createElement("span", null, "get "), React.createElement("span", {
        "style": styles.emphasis
      }, c.name), React.createElement("span", null, "(): "), React.createElement("span", {
        "style": [styles.emphasis, styles.oblique]
      }, c.getSignature[0].type.name), (c.getSignature[0].type.isArray ? React.createElement("span", null, "[]") : void 0));
    })()) : void 0, c.setSignature != null ? elm.push((function() {
      var prm_elm;
      return React.createElement("div", {
        "style": dstyle.set_signature
      }, React.createElement("span", null, "set "), React.createElement("span", {
        "style": styles.emphasis
      }, c.name), React.createElement("span", null, "("), (prm_elm = [], c.setSignature[0].parameters.forEach(function(prm, i) {
        prm_elm.push(React.createElement("span", null, prm.name));
        prm_elm.push(React.createElement("span", null, ": "));
        prm_elm.push(React.createElement("span", {
          "style": [styles.emphasis, styles.oblique]
        }, prm.type.name));
        if (i !== c.setSignature[0].parameters.length - 1) {
          return prm_elm.push(React.createElement("span", null, ", "));
        }
      }), prm_elm), React.createElement("span", null, "): "), React.createElement("span", {
        "style": [styles.emphasis, styles.oblique]
      }, c.getSignature[0].type.name), (c.getSignature[0].type.isArray ? React.createElement("span", null, "[]") : void 0));
    })()) : void 0) : c.name ? (elm.push(React.createElement("span", {
      "style": styles.emphasis
    }, c.name)), elm.push(React.createElement("span", null, ":"))) : void 0, elm));
  };

  return DocSignaturesComponent;

})(React.Component);

styles = {
  base: {
    backgroundColor: '#333',
    color: '#999',
    paddingTop: 14,
    paddingBottom: 13,
    paddingLeft: 50,
    paddingRight: 50,
    marginRight: -50,
    marginLeft: -50
  },
  emphasis: {
    color: '#eee'
  },
  oblique: {
    fontStyle: 'italic'
  },
  code: {
    fontFamily: 'Menlo, Monaco, Consolas, "Courier New", monospace',
    fontSize: 13
  }
};

DocSignaturesComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocSignaturesComponent);



},{"radium":undefined,"react":undefined}],19:[function(require,module,exports){
var DocSlideWrapperComponent, Radium, React, clone, objectAssign, slide, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

objectAssign = require('object-assign');

clone = require('lodash.clone');


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
    return this.setState({
      wrapperWidth: React.findDOMNode(this.refs.docWrapper).clientWidth - slide.from
    });
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

  DocSlideWrapperComponent.prototype.render = function() {
    var collapsed, dstyle, k, props, ref, ref1, v;
    dstyle = {};
    collapsed = false;
    if (((ref = this.props.argu.route_arr[1]) != null ? ref.toString() : void 0) === 'local') {
      collapsed = true;
    }
    if (this.state.wrapperWidth) {
      dstyle.wrapper = {
        width: this.state.wrapperWidth
      };
    }
    if (collapsed) {
      dstyle.left = {
        boxSizing: 'border-box',
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
      "style": styles.close_icon
    })), React.createElement("div", {
      "style": [styles.wrapper, dstyle.wrapper]
    }, React.Children.map(this.props.children, function(c, i) {
      if (i === 1) {
        return React.cloneElement(c, props);
      }
    }))) : void 0));
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
    flexDirection: 'row',
    flexWrap: 'nowrap',
    flexGrow: '1'
  },
  left: {
    paddingLeft: 50,
    paddingRight: 50,
    paddingTop: 30,
    paddingBottom: 30,
    boxSizing: 'border-box'
  },
  right: {
    flexGrow: '1',
    position: 'relative',
    overflow: 'hidden',
    boxShadow: '0 0 3px 0 rgba(0, 0, 0, 0.4)',
    backgroundColor: '#fff'
  },
  close: {
    position: 'absolute',
    top: 7,
    left: 8,
    cursor: 'pointer'
  },
  close_icon: {
    borderWidth: 0,
    fontSize: 20,
    color: '#ccc',
    transitionProperty: 'all',
    transitionDuration: '0.1s',
    transitionTimingFunction: 'ease-in-out',
    ':hover': {
      color: '#111'
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
    boxSizing: 'border-box'
  }
};

DocSlideWrapperComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocSlideWrapperComponent);



},{"lodash.clone":undefined,"object-assign":undefined,"radium":undefined,"react":undefined}],20:[function(require,module,exports){
var DocTableComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');


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
          "style": [styles.tb_item, odd_even_style]
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
  tb_item: {
    paddingTop: 9,
    paddingBottom: 7,
    paddingLeft: 20,
    paddingRight: 20
  },
  tb_key: {
    paddingRight: 20
  },
  tb_desc: {
    color: '#666'
  }
};

DocTableComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocTableComponent);



},{"radium":undefined,"react":undefined}],21:[function(require,module,exports){
var DocTitleComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocTitleComponent = (function(superClass) {
  extend(DocTitleComponent, superClass);

  function DocTitleComponent(props) {
    DocTitleComponent.__super__.constructor.call(this, props);
  }

  DocTitleComponent.prototype.genKindStringStyle = function(kindString) {
    var color, style;
    color = '#333333';
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
        color = '#333333';
    }
    return style = {
      color: color,
      borderColor: color
    };
  };

  DocTitleComponent.prototype.render = function() {
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
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style, dstyle.base])
    }, React.createElement("div", {
      "style": styles.title_wrap
    }, React.createElement("div", {
      "style": [styles.kind_string, this.genKindStringStyle(this.props.current.kindString), dstyle.kind_string]
    }, this.props.current.kindString), React.createElement("div", {
      "style": [styles.title, dstyle.title]
    }, this.props.current.name)), (!this.props.collapsed ? React.createElement("div", {
      "style": styles.from
    }, this.props.current.kindString + " in " + this.props.from.name) : void 0));
  };

  return DocTitleComponent;

})(React.Component);

styles = {
  base: {
    marginBottom: 40
  },
  title_wrap: {
    overflow: 'hidden'
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
    float: 'left'
  },
  title: {
    fontSize: 35,
    paddingLeft: 12,
    paddingRight: 12,
    marginLeft: 10,
    color: '#000',
    float: 'left',
    fontWeight: 'bold'
  },
  from: {
    marginTop: 10,
    fontSize: 15,
    color: '#aaa'
  }
};

DocTitleComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocTitleComponent);



},{"radium":undefined,"react":undefined}],22:[function(require,module,exports){
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



},{"react":undefined}],23:[function(require,module,exports){
var HeaderComponent, Link, Radium, React, Route, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Route = require('./route-component');

Link = require('./link-component');

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
      "key": '0',
      "style": [styles.li]
    }, React.createElement(Link, {
      "href": '/',
      "style": styles.link
    }, "Overview")), React.createElement("li", {
      "route": 'class',
      "key": '1',
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
    backgroundColor: '#444',
    height: 80,
    position: 'relative',
    WebkitUserSelect: 'none',
    MozUserSelect: 'none'
  },
  head: {
    position: 'absolute',
    top: '50%',
    transform: 'translateY(-50%)',
    left: 40
  },
  title: {
    color: '#eee',
    marginRight: 20,
    fontSize: 30,
    cursor: 'default'
  },
  subtitle: {
    color: '#ccc',
    cursor: 'default'
  },
  nav: {
    position: 'absolute',
    top: '50%',
    transform: 'translateY(-50%)',
    right: 40
  },
  active: {},
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
    borderLeftColor: '#aaa',
    borderLeftStyle: 'solid',
    borderLeftWidth: 1
  },
  link: {
    textDecoration: 'none',
    color: '#ccc'
  }
};

HeaderComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(HeaderComponent);



},{"./link-component":25,"./route-component":30,"radium":undefined,"react":undefined}],24:[function(require,module,exports){
var IndexComponent, React,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

IndexComponent = (function(superClass) {
  extend(IndexComponent, superClass);

  function IndexComponent(props) {
    IndexComponent.__super__.constructor.call(this, props);
  }

  IndexComponent.prototype.render = function() {
    return React.createElement("div", null, React.createElement("h1", null, "Index"));
  };

  return IndexComponent;

})(React.Component);

IndexComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = IndexComponent;



},{"react":undefined}],25:[function(require,module,exports){
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

-- By specifying unique route
If uniqRoute is specified, search path from RouteStore and give set to component's
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
    var state;
    this.store = this.context.ctx.routeStore;
    state = this.store.get();
    this.setState({
      routes: state.routes
    });
    return this.href = '#';
  };

  LinkComponent.prototype.navigate = function(e) {
    e.preventDefault();
    e.stopPropagation();
    return this.context.ctx.routeAction.navigate(this.href);
  };

  LinkComponent.prototype.render = function() {
    var fragment, ref, route;
    this.href = '#';
    if (this.props.href) {
      this.href = this.props.href;
    } else if (this.props.uniqRoute != null) {
      ref = this.state.routes;
      for (fragment in ref) {
        route = ref[fragment];
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



},{"radium":undefined,"react":undefined}],26:[function(require,module,exports){
var CharIconComponent, Link, ListComponent, ListFolderComponent, ListItemComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('./link-component');

ListFolderComponent = require('./list-folder-component');

ListItemComponent = require('./list-item-component');

CharIconComponent = require('./char-icon-component');

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
                backgroundColor: '#666'
              },
              content: {
                color: '#fff'
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
    color = '#333333';
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
        color = '#333333';
    }
    style = {
      color: color,
      borderColor: color
    };
    return style;
  };

  ListComponent.prototype.shouldComponentUpdate = function(nextProps, nextState) {
    return JSON.stringify(this.props.argu) !== JSON.stringify(nextProps.argu);
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
    color: '#333'
  },
  item: {
    display: 'flex',
    flexDirection: 'row',
    flexWrap: 'nowrap'
  },
  icon: {
    fontWeight: 'normal',
    cursor: 'default'
  },
  item_text: {
    paddingTop: 5,
    paddingLeft: 6,
    marginRight: 10,
    flexGrow: '1'
  }
};

ListComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(ListComponent);



},{"./char-icon-component":5,"./link-component":25,"./list-folder-component":27,"./list-item-component":28,"radium":undefined,"react":undefined}],27:[function(require,module,exports){
var CharIconComponent, ListFolderComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

CharIconComponent = require('./char-icon-component');

ListFolderComponent = (function(superClass) {
  extend(ListFolderComponent, superClass);

  function ListFolderComponent(props) {
    var ref;
    ListFolderComponent.__super__.constructor.call(this, props);
    this.state = {
      folded: (ref = this.props.folded) != null ? ref : true
    };
  }

  ListFolderComponent.prototype.toggle_fold = function() {
    return this.setState({
      folded: !this.state.folded
    });
  };

  ListFolderComponent.prototype.shouldComponentUpdate = function(nextProps, nextState) {
    return nextState.folded === false || this.state.folded !== nextState.folded;
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
    color: '#fff',
    backgroundColor: '#666',
    borderColor: '#666'
  },
  expanded: {
    display: 'block'
  }
};

ListFolderComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(ListFolderComponent);



},{"./char-icon-component":5,"radium":undefined,"react":undefined}],28:[function(require,module,exports){
var ListItemComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

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
    color: '#333'
  }
};

ListItemComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(ListItemComponent);



},{"radium":undefined,"react":undefined}],29:[function(require,module,exports){
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



},{"./app-component":4,"react":undefined}],30:[function(require,module,exports){
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
Only rendered child component which has @props.route equals to current routing.

Example:
<Route>
  <Index route='index' />
  <About route='about' />
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
    var ref, ref1, ref2, ref3, ref4, ref5;
    return React.createElement("div", {
      "style": this.props.style
    }, (console.log('route', (+new Date()).toString().slice(-4), ((ref = this.props.children.type) != null ? ref.displayName : void 0) || ((ref1 = this.props.children.type) != null ? ref1.name : void 0) || ((ref2 = this.props.children[0]) != null ? (ref3 = ref2.type) != null ? ref3.displayName : void 0 : void 0) || ((ref4 = this.props.children[0]) != null ? (ref5 = ref4.type) != null ? ref5.name : void 0 : void 0)), this.router.route(this.state.fragment, this.props.logined, (function(_this) {
      return function(route, argu, default_route, fragment, default_fragment) {
        if ((default_route != null) && (default_fragment != null)) {
          _this.context.ctx.routeAction.navigate(fragment, {
            replace: true,
            silent: true
          });
        }
        return React.Children.map(_this.props.children, function(child) {
          var match, route_arr;
          if (child.props.route != null) {
            match = false;
            route_arr = route.split(':');
            child.props.route.split(':').forEach(function(r, i) {
              if (r === route_arr[i]) {
                return match = true;
              } else {
                return match = false;
              }
            });
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
    })(this))));
  };

  return RouteComponent;

})(React.Component);

RouteComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(RouteComponent);



},{"../lib/router":33,"radium":undefined,"react":undefined}],31:[function(require,module,exports){
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



},{"./actions/doc-action":2,"./actions/route-action":3,"./stores/doc-store":34,"./stores/route-store":35,"material-flux":undefined}],32:[function(require,module,exports){
module.exports = {
  route: 'route',
  updateDoc: 'updateDoc'
};



},{}],33:[function(require,module,exports){
var Router, objectAssign;

objectAssign = require('object-assign');

Router = (function() {
  function Router(root, routes) {
    root = '/';
    this.routes = {};
    this.auth = {};
    this.setRoot(root);
    this.setRoute(routes);
  }

  Router.prototype.setRoot = function(root) {
    return this.root = (root != null) && root !== '/' ? '/' + this.clearSlashes(root) + '/' : '/';
  };

  Router.prototype.setRoute = function(routes) {
    if (routes != null) {
      return this.routes = routes;
    }
  };

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



},{"object-assign":undefined}],34:[function(require,module,exports){
var DocStore, Flux, keys, merge, objectAssign,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Flux = require('material-flux');

keys = require('../keys');

objectAssign = require('object-assign');

merge = require('lodash.merge');

DocStore = (function(superClass) {
  extend(DocStore, superClass);

  function DocStore(context) {
    DocStore.__super__.constructor.call(this, context);
    this.state = {
      dir_tree: {},
      doc_data: {}
    };
    this.state = objectAssign(this.state, context.initialStates.DocStore);
    this.register(keys.updateDoc, this.updateDoc);
  }

  DocStore.prototype.updateDoc = function(data) {
    var doc_data;
    doc_data = this.state.doc_data;
    doc_data = merge({}, doc_data, data);
    return this.setState({
      doc_data: doc_data
    });
  };

  DocStore.prototype.get = function() {
    return this.state;
  };

  return DocStore;

})(Flux.Store);

module.exports = DocStore;



},{"../keys":32,"lodash.merge":undefined,"material-flux":undefined,"object-assign":undefined}],35:[function(require,module,exports){
var Flux, RouteStore, keys, objectAssign,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Flux = require('material-flux');

keys = require('../keys');

objectAssign = require('object-assign');

RouteStore = (function(superClass) {
  extend(RouteStore, superClass);

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

  RouteStore.prototype.route = function(fragment) {
    console.log('route:', this.state.fragment, '->', fragment);
    return this.setState({
      fragment: fragment
    });
  };

  RouteStore.prototype.get = function() {
    return this.state;
  };

  return RouteStore;

})(Flux.Store);

module.exports = RouteStore;



},{"../keys":32,"material-flux":undefined,"object-assign":undefined}],36:[function(require,module,exports){

/*
@providesModule Docs
 */
var Docs, Promise, clone, config, fs, request;

fs = require('fs');

config = require('./stateInitializer/initializeStateConfig');

clone = require('lodash.clone');

request = require('request');

Promise = require('bluebird');


/*
Convert TypeDoc json to Docs object

@param {string} path to json
 */

Docs = (function() {
  function Docs(path) {
    this.json = {};
  }

  Docs.prototype.getJsonScheduler = function(interval, cb) {
    if ("production" === 'production') {
      this.getDocsJson(cb);
    } else if ("production" === 'development') {
      this.json = JSON.parse(fs.readFileSync(config.typedoc.path_to_json));
      cb();
    }
    console.log('got json');
    return setTimeout((function(_this) {
      return function() {
        return _this.getJsonScheduler(interval, cb);
      };
    })(this), interval * 1000);
  };

  Docs.prototype.getDocsJson = function(cb) {
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


  /*
  get global class typedoc json as object
  
  @param {string|number} id of child of doc root
  @param {string|number} id of grandchild of doc root
  @api public
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
            console.log(gchild.name);
            return gchild;
          }
        }
      }
    }
    return null;
  };


  /*
  get global file typedoc json as object not including children
  
  @param {string|number} id of child of doc root
  @api public
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


  /*
  Costruct doc_data object formed for doc store.
  
  @param {string|number} id of child of doc root
  @param {string|number} id of grandchild of doc root
  @api public
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



},{"./stateInitializer/initializeStateConfig":39,"bluebird":undefined,"fs":undefined,"lodash.clone":undefined,"request":undefined}],37:[function(require,module,exports){
var DirTree, Docs, InitializeState, Router, RoutesGen, config;

RoutesGen = require('./stateInitializer/routes-gen');

config = require('./stateInitializer/initializeStateConfig');

DirTree = require('./stateInitializer/dir-tree');

Docs = require('./docs');

Router = require('../renderer/lib/router');

InitializeState = (function() {
  function InitializeState(docs) {
    this.docs = docs;
    this.routeGen = new RoutesGen();
    this.dirTree = new DirTree();
    this.router = new Router(config.router.root, this.routeGen.routes);
  }

  InitializeState.prototype.gen = function() {
    this.routeGen.gen(this.docs.json);
    this.dirTree.gen(this.docs.json);
    return this.router.setRoute(this.routeGen.routes);
  };

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



},{"../renderer/lib/router":33,"./docs":36,"./stateInitializer/dir-tree":38,"./stateInitializer/initializeStateConfig":39,"./stateInitializer/routes-gen":40}],38:[function(require,module,exports){

/*
@providesModule DirTree
 */
var DirTree, merge, objectAssign;

objectAssign = require('object-assign');

merge = require('lodash.merge');


/*
Construt tree formed object by analizing the name of
the global class in typedoc json.

@param {object} json object converted from typedoc

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


  /*
  construct tree formed object from docs json
  
  @api public
   */

  DirTree.prototype.gen = function(json) {
    return this.dir_tree = constructDirTree(json);
  };


  /*
  construct tree formed object from docs json
  
  @api private
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


  /*
  construct no branched tree recursively by array
  
  @param {array} construct nested hash by following this
  @param {any} the top of nested hash
  @api private
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
            path: (def_arr != null ? def_arr : arr).slice(0, -1).concat([gchild.name])
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



},{"lodash.merge":undefined,"object-assign":undefined}],39:[function(require,module,exports){
var fs;

fs = require('fs');

module.exports = {
  typedoc: {
    path_to_json: './src/server/doc.json'
  },
  router: {
    root: '/'
  }
};



},{"fs":undefined}],40:[function(require,module,exports){
var RoutesGen, objectAssign;

objectAssign = require('object-assign');

RoutesGen = (function() {
  var constructClassRoutes, constructErrorRoutes;

  function RoutesGen(json) {
    this.routes = {};
    this._constructRoutes(json);
  }

  RoutesGen.prototype.gen = function(json) {
    return this._constructRoutes(json);
  };

  RoutesGen.prototype._constructRoutes = function(json) {
    this.routes = {};
    this.routes = objectAssign(this.routes, constructClassRoutes(json));
    return this.routes = objectAssign(this.routes, constructErrorRoutes());
  };

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

