###*
 * Generate KindString color
 * @param  {String} kindString
 * @return {String}            hex color string
###
module.exports = (kindString) ->
  color = null
  switch kindString
    when 'Class'
      color = '#337BFF'
    when 'Constructor'
      color = '#337BFF'
    when 'Interface'
      color = '#598213'
    when 'Property'
      color = '#598213'
    when 'Enumeration'
      color = '#B17509'
    when 'Enumeration member'
      color = '#B17509'
    when 'Module'
      color = '#D04C35'
    when 'Accessor'
      color = '#D04C35'
    when 'Function'
      color = '#6E00FF'
    when 'Method'
      color = '#6E00FF'
  return color
