# 
#  jquery plugin to get a functional, dynamic and customizable contactform
#  which uses mandrill to send the emails, ReCaptcha to validate Humanity
#  and jquery.validate.js to validate user input
#  
#  @author Alexander Nickel <mr.alexander.nickel@gmail.com>
#  @date 2013-10-10T09:41:31Z
#
$ = jQuery

config =
  mandrill_api_key: ""

methods =
  init: (options) ->
    # set options
    $.extend config, options
    # generate inputs
    methods.generate_inputs()
  generate_inputs: ->
    for element in config.form_inputs
      $("#form_contactform").prepend Handlebars.templates.input element.config

$.contactform = (method,options...) ->
  if methods[method]
    methods[method].apply this, options
  else if typeof method is "object" or not method
    methods.init.apply this, arguments
  else
    $.error "Method #{method} does not exist in contactform.js"