React = require 'react'
Radium = require 'radium'
Link = require './link-component'

class DocTableComponent extends React.Component
  constructor: (props) ->
    super props

  render: ->
    <div style={Array.prototype.concat.apply([], [styles.base, @props.style])}>
      <table style={styles.table}>
        <tbody>
          {
            for id, i in @props.group.children
              child = null
              for c in @props.current.children
                if c.id == id
                  child = c
              if child?
                odd_even_style = if i % 2 == 1 then {} else {backgroundColor: '#F2F2F2'}
                # alt_text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Incidunt libero, suscipit, rerum id ipsum provident voluptas deleniti dolor dignissimos nostrum, deserunt, vel voluptatem a. Nostrum rerum illum cum reiciendis quisquam! Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ipsa distinctio iure recusandae sapiente voluptatibus. Nobis corporis architecto numquam quibusdam, culpa quaerat voluptates, incidunt saepe dolore, velit distinctio placeat sequi accusantium."[0..Math.round(Math.random() * 478)]
                alt_text = 'no description'
                <tr key={child.id} style={[styles.tb_item, odd_even_style]}>
                  <td style={[styles.tb_item, styles.tb_key]}>
                    <Link style={styles.link}>{child.name}</Link>
                  </td>
                  <td style={[styles.tb_item, styles.tb_desc]}>{child.comment?.shortText ? alt_text}</td>
                </tr>
              else
                null
          }
        </tbody>
      </table>
    </div>

styles =
  base: {}

  table:
    borderSpacing: 0

  tb_item:
    paddingTop: 9
    paddingBottom: 7
    paddingLeft: 20
    paddingRight: 20

  tb_key:
    paddingRight: 20

  tb_desc:
    color: '#333'

  link:
    cursor: 'pointer'

    ':hover':
      textDecoration: 'underline'

DocTableComponent.contextTypes =
  ctx: React.PropTypes.any

module.exports = Radium DocTableComponent
