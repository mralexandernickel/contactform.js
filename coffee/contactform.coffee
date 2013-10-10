# 
#  jquery plugin to get a functional, dynamic and customizable contactform
#  which uses mandrill to send the emails, ReCaptcha to validate Humanity
#  and jquery.validate.js to validate user input
#
#  DEPENDENCIES:
#    - jQuery
#    - Mandrill Javascript API
#    - ReCaptcha Javascript API
#    - Handlebars Runtime --> Templates need to be Precompiled, please see <http://handlebarsjs.com/precompilation.html>
#  
#  @author Alexander Nickel <mr.alexander.nickel@gmail.com>
#  @date 2013-10-10T09:41:31Z
#
$ = jQuery

config =
  mandrill_api_key: null
  recaptcha_pubkey: null
  container: null
  form_element: null
  recipients: null
  from_email: null

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
      # insert recaptcha
      methods.insert_recaptcha()
      # insert textarea
      methods.insert_textarea()
      # generate inputs
      methods.generate_inputs()
  
  insert_recaptcha: ->
    if config.form_element?
      # insert markup
      config.form_element.prepend Handlebars.templates.recaptcha()
      # init recaptcha
      if Recaptcha?
        if config.recaptcha_pubkey?
          Recaptcha.create config.recaptcha_pubkey,
            "recaptcha_wrap",
              theme: "custom"
              custom_theme_widget: "recaptcha_widget"
          # use custom reload button
          $("#recaptcha_reload").click (e) ->
            Recaptcha.reload()
        else
          $.error "can't find you ReCaptcha Public Key... Did you set one?"
      else
        $.error "contactform.js needs the ReCaptcha Javascript API... is it available?"
    else
      $.error "No form element found in DOM!"
  
  insert_textarea: ->
    if config.form_element?
      config.form_element.prepend Handlebars.templates.textarea name: "Message"
    else
      $.error "No form element found in DOM!"
    
  generate_inputs: ->
    for element in config.form_inputs
      config.form_element.prepend Handlebars.templates.input element
  
  add_submit_handler: ->
    if config.form_element?
      config.form_element.submit (e) ->
        e.preventDefault()
    else
      $.error "no form element found in DOM"


$.fn.contactform = (method,options...) ->
  if methods[method]
    methods[method].apply this, options
  else if typeof method is "object" or not method
    methods.init.apply this, arguments
  else
    $.error "Method #{method} does not exist in contactform.js"