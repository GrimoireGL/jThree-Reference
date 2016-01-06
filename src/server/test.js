// var Promise = require('bluebird');
// var request = require('request');
//
//
// var address = "https://api.github.com/repos/jThreeJS/jThree-Overview";
//
// var co = require('co');
// co(function *() {
//   var branchesUrl = address + "/branches"
//
//   var masterUrl = (yield p(branchesUrl)).filter(function (o) {
//     return o.name === "master"
//   })[0].commit.url;
//   console.log(masterUrl);
//
// });
//
// function p(url) {
//   var result;
//   return new Promise(function (resolve, reject) {
//     request.get({
//       url: url,
//       json: true,
//       headers: { 'User-Agent': 'request' }
//     }, function(error, response, body) {
//       resolve(body);
//     });
//   })
// }
