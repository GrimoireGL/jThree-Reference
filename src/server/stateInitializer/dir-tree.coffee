###
@providesModule DirTree
###

objectAssign = require 'object-assign'
_ = require 'lodash'


###
Construt tree formed object by analizing the name of
the global class in typedoc json.

@param {object} json object converted from typedoc

Construct dir_tree like below.

-- path
a/file1 id1
a/b/file2 id2

-- routes
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
class DirTree
  constructor: (json) ->
    @json = json
    @dir_tree = {}
    constructDirTree()

  ###
  construct tree formed object from docs json

  @api private
  ###
  constructDirTree = ->
    @json.children.forEach (child, i) =>
      arr = child.name.replace(/"/g, '').split('/')
      @dir_tree = _.merge({}, @dir_tree, arrayToDirTree(arr, child.id))

  ###
  construct no branched tree recursively by array

  @param {array} construct nested hash by following this
  @param {any} the top of nested hash
  @api private
  ###
  arrayToDirTree = (arr, top) ->
    res = {}
    if arr.length == 1
      res.file = {}
      res.file[arr[0]] = top
    else
      res.dir = {}
      res.dir[arr[0]] = arrayToDirTree(arr[1..-1], top)
    return res

module.exports = DirTree
