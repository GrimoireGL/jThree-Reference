###
@providesModule DocCoverage
###

objectAssign = require 'object-assign'
merge = require 'lodash.merge'


###
Calcurate documentation coverage
###
class DocCoverage
  constructor: (json) ->
    @coverage = calcurateCoverage(json)
    # console.log JSON.stringify(@coverage, null, 2)

  gen: (json) ->
    @coverage = calcurateCoverage(json)

  ###*
   * calcurate coverage of comments inside json
   * @param  {Object} json typedoc json
   * @return {Object}      tree formed object
  ###
  calcurateCoverage = (json) ->
    children_covs = calcurateCoverageChildren json.children if json?
    coverage = {
      all: 0
      covered: 0
    }
    if children_covs
      coverage.children = children_covs
      for children_cov in children_covs
        coverage.all += children_cov.all
        coverage.covered += children_cov.covered
    return coverage

  calcurateCoverageChildren = (children) ->
    coverage = []
    children.forEach (child, i) ->
      children_covs = {}
      target = ['children', 'signatures', 'parameters', 'typeParameter']
      target.forEach (t) ->
        if child[t]
          children_covs[t] = calcurateCoverageChildren child[t]
      all = 0
      covered = 0
      all += 1 if !children_covs.signatures? && child.kindString != 'External module'
      if child?.comment?.shortText
        covered += 1
      coverage[i] =
        name: child.name
      for t, children_cov of children_covs
        for child_cov in children_cov
          all += child_cov.all
          covered += child_cov.covered
        coverage[i][t] = children_cov
      coverage[i] = objectAssign coverage[i],
        all: all
        covered: covered
    return coverage

module.exports = DocCoverage
