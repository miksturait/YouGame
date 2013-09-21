Array::partition = (length) ->
  result = []
  i = 0
  while i < @length
    result.push []  if i % length is 0
    result[result.length - 1].push this[i]
    i++
  result

Array::shuffle = ->
  j = undefined
  x = undefined
  i = @length

  while i
    j = parseInt(Math.random() * i)
    x = @[--i]
    @[i] = @[j]
    @[j] = x
  @