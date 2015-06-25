objectAssign = require 'object-assign'
_ = require 'lodash'

class DirTree
  constructor: (json) ->
    @json = json
    @dir_tree = {}
    @constructDirTree()

  constructDirTree: ->
    @json.children.forEach (child, i) =>
      arr = child.name.replace(/"/g, '').split('/')
      @dir_tree = _.merge({}, @dir_tree, @arrayToDirTree(arr, child.id))

  arrayToDirTree: (arr, top) ->
    res = {}
    if arr.length == 1
      res.file = {}
      res.file[arr[0]] = top
    else
      res.dir = {}
      res.dir[arr[0]] = @arrayToDirTree(arr[1..-1], top)
    return res

module.exports = DirTree

###
* The routing asigned by path
a/file1 class:file:id1
a/b/file2 class:file:id2
a/b class:dir:id3

* construct dir_tree like below
** path
a/file1 id1
a/b/file2 id2

** routes
{
  dir: {
    a: {
      dir: {
        b: {
          file: {
            file2: id2
          }
        }
      },
      file: {
        file1: di1
      }
    }
  }
}
###
