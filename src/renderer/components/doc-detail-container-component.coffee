React = require 'react'
Radium = require 'radium'
DocSlideWrapperComponent = require './doc-slide-wrapper-component'
DocDescriptionComponent = require './doc-description-component'
DocDetailTitleComponent = require './doc-detail-title-component'
DocDetailParametersComponent = require './doc-detail-parameters-component'
DocDetailReturnComponent = require './doc-detail-return-components'
DocTypeparameterComponent = require './doc-typeparameter-component'

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
              text = []
              if current_local.signatures?
                text = [current_local.signatures[0].comment?.shortText, current_local.signatures[0].comment?.text]
              else if current_local.getSignature?
                text = [current_local.getSignature[0].comment?.shortText, current_local.getSignature[0].comment?.text]
              else if current_local.setSignature?
                text = [current_local.setSignature[0].comment?.shortText, current_local.setSignature[0].comment?.text]
              else
                text = [current_local.comment?.shortText, current_local.comment?.text]
              <div>
                <DocDetailTitleComponent current={current_local} from={current} />
                <DocDescriptionComponent text={text} />
                {
                  if current_local.typeParameter?
                    <DocTypeparameterComponent current={current_local} />
                }
                {
                  if current_local.signatures?.every((s) -> s.parameters?)
                    <DocDetailParametersComponent current={current_local} />
                }
                {
                  if current_local.signatures? || current_local.getSignature? || current_local.setSignature?
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
