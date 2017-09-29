updateNotificationCounter = (element) ->
  counter = $(element).data('notification')
  nextContent = ''
  if counter > 0
    nextContent = counter
  $(element).text(nextContent)

$(document).ready ->
  $('span[data-notification]').each ->
    updateNotificationCounter(this)

$(document).on 'incoming-notification', 'span[data-notification]', ->
  count = $(this).data('notification') || 0
  $(this).data('notification', count + 1)
  updateNotificationCounter(this)

$(document).on 'reset-notification-counter', 'span[data-notification]', ->
  $(this).data('notification', 0)
  updateNotificationCounter(this)
