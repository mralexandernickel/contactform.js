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
  form_element: null

methods =
  init: (options) ->
    # set the container
    config.container = $(this)
    # set options
    $.extend config, options
    # insert form
    methods.insert_form()
    
  insert_form: ->
    if config.container?
      # insert form into DOM
      config.container.html Handlebars.templates.form()
      # save the Element to config, to prevent DOM queries
      config.form_element = $("#form_contactform")
      # add submit handler to contactform
      methods.add_submit_handler()
      # insert textarea
      methods.insert_textarea()
      # generate inputs
      methods.generate_inputs()
  
  insert_textarea: ->
    if config.form_element?
      config.form_element.prepend Handlebars.templates.textarea name: "message"
    else
      $.error "no form element in DOM"
    
  generate_inputs: ->
    for element in config.form_inputs
      config.form_element.prepend Handlebars.templates.input element
  
  add_submit_handler: ->
    if config.form_element?
      config.form_element.submit (e) ->
        e.preventDefault()
    else
      $.error "no form element in DOM"


$.fn.contactform = (method,options...) ->
  if methods[method]
    methods[method].apply this, options
  else if typeof method is "object" or not method
    methods.init.apply this, arguments
  else
    $.error "Method #{method} does not exist in contactform.js"