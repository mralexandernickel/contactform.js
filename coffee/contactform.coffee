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
  container: null

methods =
  init: (options) ->
    # set the container
    config.container = $(this)
    # set options
    $.extend config, options
    # insert form
    methods.insert_form()
    # generate inputs
    methods.generate_inputs()
    
  insert_form: ->
    if container?
      config.container.html Handlebars.templates.form()
    
  generate_inputs: ->
    for element in config.form_inputs
      $("#form_contactform").prepend Handlebars.templates.input element


$.fn.contactform = (method,options...) ->
  if methods[method]
    methods[method].apply this, options
  else if typeof method is "object" or not method
    methods.init.apply this, arguments
  else
    $.error "Method #{method} does not exist in contactform.js"