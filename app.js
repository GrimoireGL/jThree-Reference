(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Context, Docs, Handlebars, InitializeState, React, Root, docs, express, fs, initializeState, server, template;

express = require('express');

fs = require('fs');

Handlebars = require('handlebars');

React = require('react');

Context = require('./renderer/context');

Root = require('./renderer/components/root-component');

InitializeState = require('./server/initializeState');

Docs = require('./server/docs');

server = express();

server.use('/static', express["static"]('public'));

template = Handlebars.compile(fs.readFileSync((fs.realpathSync('./')) + "/view/index.hbs").toString());

server.get('/favicon.ico', function(req, res) {});

docs = new Docs();

initializeState = new InitializeState();

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



},{"./renderer/components/root-component":19,"./renderer/context":21,"./server/docs":26,"./server/initializeState":27,"express":undefined,"fs":undefined,"handlebars":undefined,"react":undefined}],2:[function(require,module,exports){
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



},{"../keys":22,"bluebird":undefined,"material-flux":undefined,"superagent":undefined}],3:[function(require,module,exports){
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
    path = "/" + (this.clearSlashes(path));
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



},{"../keys":22,"html5-history":undefined,"material-flux":undefined}],4:[function(require,module,exports){
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



},{"./classdoc-component":6,"./error-component":12,"./header-component":13,"./index-component":14,"./link-component":15,"./route-component":20,"react":undefined}],5:[function(require,module,exports){
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
var ClassDocComponent, DocContainerComponent, ListComponent, Radium, React, Route, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Route = require('./route-component');

DocContainerComponent = require('./doc-container-component');

ListComponent = require('./list-component');

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
    }, React.createElement(Route, null, React.createElement(DocContainerComponent, {
      "doc_data": this.state.doc_data
    }))));
  };

  return ClassDocComponent;

})(React.Component);

styles = {
  base: {
    paddingTop: 10,
    paddingBottom: 10,
    paddingLeft: 10,
    paddingRight: 10,
    display: 'flex',
    flexDirection: 'row',
    flexWrap: 'nowrap'
  },
  list: {
    width: 350,
    minWidth: 350
  },
  container: {
    flexGrow: '1'
  }
};

ClassDocComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(ClassDocComponent);



},{"./doc-container-component":7,"./list-component":16,"./route-component":20,"radium":undefined,"react":undefined}],7:[function(require,module,exports){
var DocContainerComponents, DocDescriptionComponent, DocItemComponent, DocTitleComponent, Link, Radium, React, Route, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Route = require('./route-component');

Link = require('./link-component');

DocTitleComponent = require('./doc-title-component');

DocDescriptionComponent = require('./doc-description-component');

DocItemComponent = require('./doc-item-component');

DocContainerComponents = (function(superClass) {
  extend(DocContainerComponents, superClass);

  function DocContainerComponents(props) {
    DocContainerComponents.__super__.constructor.call(this, props);
  }

  DocContainerComponents.prototype.render = function() {
    var current, factor_id, file_id, group, ref, ref1;
    file_id = (ref = this.props.argu.route_arr[2]) != null ? ref.toString() : void 0;
    factor_id = (ref1 = this.props.argu.route_arr[3]) != null ? ref1.toString() : void 0;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, ((function() {
      var ref2;
      if ((file_id != null) && (factor_id != null)) {
        current = (ref2 = this.props.doc_data[file_id]) != null ? ref2[factor_id] : void 0;
        if (current != null) {
          return React.createElement("div", null, React.createElement(DocTitleComponent, {
            "current": current,
            "from": this.props.doc_data[file_id].from
          }), React.createElement(DocDescriptionComponent, {
            "current": current
          }), React.createElement("div", null, ((function() {
            var i, len, ref3, results;
            if (current.groups != null) {
              ref3 = current.groups;
              results = [];
              for (i = 0, len = ref3.length; i < len; i++) {
                group = ref3[i];
                results.push(React.createElement(DocItemComponent, {
                  "key": group.kind,
                  "group": group,
                  "current": current
                }));
              }
              return results;
            } else {
              return null;
            }
          })())));
        } else {
          if (typeof window !== "undefined" && window !== null) {
            this.context.ctx.docAction.updateDoc(file_id, factor_id);
          } else {
            throw new Error('doc_data must be initialized by initialStates');
          }
          return React.createElement("span", null, "Loading...");
        }
      } else {
        return null;
      }
    }).call(this)));
  };

  return DocContainerComponents;

})(React.Component);

styles = {
  base: {
    paddingLeft: 40,
    paddingRight: 40,
    paddingTop: 20,
    paddingBottom: 20
  }
};

DocContainerComponents.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocContainerComponents);



},{"./doc-description-component":8,"./doc-item-component":9,"./doc-title-component":11,"./link-component":15,"./route-component":20,"radium":undefined,"react":undefined}],8:[function(require,module,exports){
var DocDescriptionComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocDescriptionComponent = (function(superClass) {
  extend(DocDescriptionComponent, superClass);

  function DocDescriptionComponent(props) {
    DocDescriptionComponent.__super__.constructor.call(this, props);
  }

  DocDescriptionComponent.prototype.render = function() {
    var alt_text, ref, ref1;
    alt_text = 'no description';
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement("div", {
      "style": styles.subtitle
    }, "Description"), React.createElement("div", {
      "style": styles.content
    }, (ref = (ref1 = this.props.current.comment) != null ? ref1.shortText : void 0) != null ? ref : alt_text));
  };

  return DocDescriptionComponent;

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
    marginTop: 15,
    color: '#333'
  }
};

DocDescriptionComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocDescriptionComponent);



},{"radium":undefined,"react":undefined}],9:[function(require,module,exports){
var DocItemComponent, DocTableComponent, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

DocTableComponent = require('./doc-table-component');

DocItemComponent = (function(superClass) {
  extend(DocItemComponent, superClass);

  function DocItemComponent(props) {
    DocItemComponent.__super__.constructor.call(this, props);
  }

  DocItemComponent.prototype.render = function() {
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement("div", {
      "style": styles.subtitle
    }, this.props.group.title), React.createElement(DocTableComponent, {
      "group": this.props.group,
      "current": this.props.current,
      "style": styles.content
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



},{"./doc-table-component":10,"radium":undefined,"react":undefined}],10:[function(require,module,exports){
var DocTableComponent, Link, Radium, React, styles,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

React = require('react');

Radium = require('radium');

Link = require('./link-component');

DocTableComponent = (function(superClass) {
  extend(DocTableComponent, superClass);

  function DocTableComponent(props) {
    DocTableComponent.__super__.constructor.call(this, props);
  }

  DocTableComponent.prototype.render = function() {
    var alt_text, c, child, i, id, odd_even_style;
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement("table", {
      "style": styles.table
    }, React.createElement("tbody", null, (function() {
      var j, k, len, len1, ref, ref1, ref2, ref3, results;
      ref = this.props.group.children;
      results = [];
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
          odd_even_style = i % 2 === 1 ? {} : {
            backgroundColor: '#F2F2F2'
          };
          alt_text = 'no description';
          results.push(React.createElement("tr", {
            "key": child.id,
            "style": [styles.tb_item, odd_even_style]
          }, React.createElement("td", {
            "style": [styles.tb_item, styles.tb_key]
          }, React.createElement(Link, {
            "style": styles.link
          }, child.name)), React.createElement("td", {
            "style": [styles.tb_item, styles.tb_desc]
          }, (ref2 = (ref3 = child.comment) != null ? ref3.shortText : void 0) != null ? ref2 : alt_text)));
        } else {
          results.push(null);
        }
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
    color: '#333'
  },
  link: {
    cursor: 'pointer',
    ':hover': {
      textDecoration: 'underline'
    }
  }
};

DocTableComponent.contextTypes = {
  ctx: React.PropTypes.any
};

module.exports = Radium(DocTableComponent);



},{"./link-component":15,"radium":undefined,"react":undefined}],11:[function(require,module,exports){
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
    return React.createElement("div", {
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
    }, React.createElement("div", {
      "style": styles.title_wrap
    }, React.createElement("div", {
      "style": [styles.kind_string, this.genKindStringStyle(this.props.current.kindString)]
    }, this.props.current.kindString), React.createElement("div", {
      "style": styles.title
    }, this.props.current.name)), React.createElement("div", {
      "style": styles.from
    }, this.props.current.kindString + " in " + this.props.from.name));
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



},{"radium":undefined,"react":undefined}],12:[function(require,module,exports){
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



},{"react":undefined}],13:[function(require,module,exports){
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



},{"./link-component":15,"./route-component":20,"radium":undefined,"react":undefined}],14:[function(require,module,exports){
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



},{"react":undefined}],15:[function(require,module,exports){
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
 */

LinkComponent = (function(superClass) {
  extend(LinkComponent, superClass);

  function LinkComponent(props) {
    LinkComponent.__super__.constructor.call(this, props);
  }

  LinkComponent.prototype.navigate = function(e) {
    e.preventDefault();
    return this.context.ctx.routeAction.navigate(this.props.href);
  };

  LinkComponent.prototype.render = function() {
    return React.createElement("a", {
      "href": this.props.href,
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



},{"radium":undefined,"react":undefined}],16:[function(require,module,exports){
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
      "style": Array.prototype.concat.apply([], [styles.base, this.props.style])
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
      "style": Array.prototype.concat.apply([], [styles.wrapper, this.props.style])
    }, this.constructNestedList(this.props.dir_tree));
  };

  return ListComponent;

})(React.Component);

styles = {
  base: {
    listStyle: 'none',
    paddingLeft: 22
  },
  wrapper: {
    borderRightWidth: 1,
    borderRightColor: '#ccc',
    borderRightStyle: 'solid'
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



},{"./char-icon-component":5,"./link-component":15,"./list-folder-component":17,"./list-item-component":18,"radium":undefined,"react":undefined}],17:[function(require,module,exports){
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



},{"./char-icon-component":5,"radium":undefined,"react":undefined}],18:[function(require,module,exports){
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



},{"radium":undefined,"react":undefined}],19:[function(require,module,exports){
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



},{"./app-component":4,"react":undefined}],20:[function(require,module,exports){
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



},{"../lib/router":23,"radium":undefined,"react":undefined}],21:[function(require,module,exports){
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



},{"./actions/doc-action":2,"./actions/route-action":3,"./stores/doc-store":24,"./stores/route-store":25,"material-flux":undefined}],22:[function(require,module,exports){
module.exports = {
  route: 'route',
  updateDoc: 'updateDoc'
};



},{}],23:[function(require,module,exports){
var Router, objectAssign;

objectAssign = require('object-assign');

Router = (function() {
  function Router(root, routes) {
    this.setRoot(root);
    if (routes != null) {
      this.routes = routes;
    }
    this.auth = {};
  }

  Router.prototype.setRoot = function(root) {
    return this.root = (root != null) && root !== '/' ? '/' + this.clearSlashes(root) + '/' : '/';
  };

  Router.prototype.setRoute = function(path, route) {
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



},{"object-assign":undefined}],24:[function(require,module,exports){
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



},{"../keys":22,"lodash.merge":undefined,"material-flux":undefined,"object-assign":undefined}],25:[function(require,module,exports){
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



},{"../keys":22,"material-flux":undefined,"object-assign":undefined}],26:[function(require,module,exports){

/*
@providesModule Docs
 */
var Docs, clone, config, fs;

fs = require('fs');

config = require('./stateInitializer/initializeStateConfig');

clone = require('lodash.clone');


/*
Convert TypeDoc json to Docs object

@param {string} path to json
 */

Docs = (function() {
  function Docs(path) {
    this.json = JSON.parse(fs.readFileSync(path || config.typedoc.path_to_json));
  }


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



},{"./stateInitializer/initializeStateConfig":29,"fs":undefined,"lodash.clone":undefined}],27:[function(require,module,exports){
var DirTree, Docs, InitializeState, Router, RoutesGen, config;

RoutesGen = require('./stateInitializer/routes-gen');

config = require('./stateInitializer/initializeStateConfig');

DirTree = require('./stateInitializer/dir-tree');

Docs = require('./docs');

Router = require('../renderer/lib/router');

InitializeState = (function() {
  function InitializeState() {
    this.docs = new Docs();
    this.routes = new RoutesGen(this.docs.json).routes;
    this.dir_tree = new DirTree(this.docs.json).dir_tree;
    this.router = new Router(config.router.root, this.routes);
  }

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
        routes: this.routes
      },
      DocStore: {
        dir_tree: this.dir_tree,
        doc_data: initial_doc_data
      }
    };
    return initialState;
  };

  return InitializeState;

})();

module.exports = InitializeState;



},{"../renderer/lib/router":23,"./docs":26,"./stateInitializer/dir-tree":28,"./stateInitializer/initializeStateConfig":29,"./stateInitializer/routes-gen":30}],28:[function(require,module,exports){

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
    this.json = json;
    this.dir_tree = constructDirTree(this.json);
  }


  /*
  construct tree formed object from docs json
  
  @api private
   */

  constructDirTree = function(json) {
    var dir_tree;
    dir_tree = {};
    json.children.forEach(function(child, i) {
      var arr;
      arr = child.name.replace(/"/g, '').split('/');
      return dir_tree = merge({}, dir_tree, arrayToDirTree(arr, child));
    });
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
      if ((ref = top.groups) != null) {
        ref.forEach(function(group) {
          return group.children.forEach(function(id) {
            return top.children.forEach(function(gchild) {
              if (gchild.id === id) {
                return res.file[gchild.name] = {
                  name: gchild.name,
                  kindString: gchild.kindString,
                  path: (def_arr != null ? def_arr : arr).slice(0, -1).concat([gchild.name])
                };
              }
            });
          });
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



},{"lodash.merge":undefined,"object-assign":undefined}],29:[function(require,module,exports){
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



},{"fs":undefined}],30:[function(require,module,exports){
var RoutesGen, objectAssign;

objectAssign = require('object-assign');

RoutesGen = (function() {
  function RoutesGen(json) {
    this.json = json;
    this.routes = {};
    this.constructRoutes();
  }

  RoutesGen.prototype.updateJson = function(json) {
    this.json = json;
    return this.constructRoutes();
  };

  RoutesGen.prototype.constructRoutes = function() {
    this.routes = {};
    this.routes = objectAssign(this.routes, this.constructClassRoutes());
    return this.routes = objectAssign(this.routes, this.constructErrorRoutes());
  };

  RoutesGen.prototype.constructClassRoutes = function() {
    var prefix, routes;
    prefix = 'class';
    routes = {};
    this.json.children.forEach(function(child, i) {
      var dir, dir_arr;
      dir = child.name.replace(/\"/g, '');
      dir_arr = dir.split('/');
      return dir_arr.forEach(function(d, j) {
        var ref;
        if (j !== dir_arr.length - 1) {
          return routes[prefix + "/" + (dir_arr.slice(0, +j + 1 || 9e9).join('/'))] = prefix + ":global";
        } else {
          return (ref = child.groups) != null ? ref.forEach(function(group) {
            return group.children.forEach(function(id) {
              return child.children.forEach(function(gchild) {
                if (gchild.id === id) {
                  return routes["" + prefix + (dir_arr.length === 1 ? '' : '/' + dir_arr.slice(0, +(j - 1) + 1 || 9e9).join('/')) + "/" + gchild.name] = prefix + ":global:" + child.id + ":" + gchild.id;
                }
              });
            });
          }) : void 0;
        }
      });
    });
    routes["" + prefix] = "" + prefix;
    return routes;
  };

  RoutesGen.prototype.constructErrorRoutes = function() {
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

