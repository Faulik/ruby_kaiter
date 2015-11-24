#= require active_admin/base
#= require select2

$(document).on('ready page:load', ->
  $('.select2-list').select2({
    tags: true,
    placeholder: "Select an option",
    width: 'resolve'
    })
)
