###
@providesModule DirTree
###

objectAssign = require 'object-assign'
merge = require 'lodash.merge'


###
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
###
class DirTree
  constructor: (json) ->
    @dir_tree = constructDirTree(json)

  ###*
   * Construt tree formed object by analizing the name of
   * the global class in typedoc json.
   * @param  {Object} json typedoc json
  ###
  gen: (json) ->
    @dir_tree = constructDirTree(json)

  ###*
   * construct tree formed object from docs json
   * @param  {Object} json typedoc json
   * @return {Object}      tree formed object
  ###
  constructDirTree = (json) ->
    dir_tree = {}
    json?.children?.forEach (child, i) ->
      arr = child.name.replace(/"/g, '').split('/')
      dir_tree = merge {}, dir_tree, arrayToDirTree(arr, child)
    return dir_tree

  ###*
   * construct no branched tree recursively by array
   * @param  {Array} arr     construct nested hash by following this
   * @param  {Object} top    the top of nested hash
   * @param  {Array} def_arr this parameter used in recurrence
   * @return {Object}        fragment of tree formed object
  ###
  arrayToDirTree = (arr, top, def_arr) ->
    res = {}
    unless def_arr?
      res.path = []
    else
      res.path = def_arr[0..(-(arr.length + 1))]
    if arr.length == 1
      res.file = {}
      top.children?.forEach (gchild) ->
        res.file[gchild.name] =
          name: gchild.name
          kindString: gchild.kindString
          path: (def_arr ? arr)[0..-2].concat [gchild.name]
          children: (gchild.children || []).map((ggchild) -> {name: ggchild.name, kindString: ggchild.kindString})
    else
      res.dir = {}
      res.dir[arr[0]] = arrayToDirTree(arr[1..-1], top, def_arr ? arr)
    return res

module.exports = DirTree
