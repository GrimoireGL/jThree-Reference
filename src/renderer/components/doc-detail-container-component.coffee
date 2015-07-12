React = require 'react'
Radium = require 'radium'
DocDetailTitleComponent = require './doc-detail-title-component'
DocSlideWrapperComponent = require './doc-slide-wrapper-component'
DocDescriptionComponent = require './doc-description-component'
DocDetailParametersComponent = require './doc-detail-parameters-component'
DocDetailReturnComponent = require './doc-detail-return-components'

class DocDetailContainerComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    file_id = @props.argu.route_arr[2]?.toString()
    factor_id = @props.argu.route_arr[3]?.toString()
    local_factor_id = @props.argu.route_arr[4]?.toString()
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      {
        if file_id? && factor_id?
          current = @props.doc_data[file_id]?[factor_id]
          if current?
            current_local = null
            for c in current.children
              if c.id?.toString() == local_factor_id
                current_local = c
            if current_local?
              <div>
                <DocDetailTitleComponent current={current_local} from={current} />
                <DocDescriptionComponent text={current_local.signatures?[0].comment?.shortText} />
                {
                  if current_local.signatures?[0].parameters?
                    <DocDetailParametersComponent current={current_local} />
                }
                {
                  if current_local.signatures?
                    <DocDetailReturnComponent current={current_local} />
                }
              </div>
      }
    </div>

styles =
  base: {}

DocDetailContainerComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocDetailContainerComponent
