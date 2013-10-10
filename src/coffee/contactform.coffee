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
#
#  TODO find a way to add extra inputs to the email
#  TODO make error-messages configurable
#  TODO add clientside input validation --> jquery.validate.js
#
#
$ = jQuery

config =
  mandrill_api_key: null
  recaptcha_pubkey: null
  recaptcha_verification_url: "recaptcha.php"
  container: null
  form_element: null
  recipients: null# an array with objects containing a key named "email" which holds the email address of one recipient
  from_email: null
  extra_inputs: null

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
      # generate inputs
      methods.generate_extra_inputs()
  
  insert_recaptcha: ->
    if config.form_element?
      # insert markup
      $("#form-actions").before Handlebars.templates.recaptcha placeholder: "Please Enter the 2 Words above"
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
          $.error "can't find your ReCaptcha Public Key... Did you set one?"
      else
        $.error "contactform.js needs the ReCaptcha Javascript API... is it available?"
    else
      $.error "No form element found in DOM!"
    
  generate_extra_inputs: ->
    if config.extra_inputs?
      for element in config.extra_inputs
        $("#contactform_extra_elements").append Handlebars.templates.input element
  
  add_submit_handler: ->
    if config.form_element?
      config.form_element.submit (e) ->
        e.preventDefault()
        # verify recaptcha
        methods.verify_recaptcha()
    else
      $.error "no form element found in DOM"
  
  verify_recaptcha: ->
    # define params for recaptcha verification
    recaptcha_params =
      recaptcha_response_field: Recaptcha.get_response()
      recaptcha_challenge_field: Recaptcha.get_challenge()
    # check recaptcha
    $.post config.recaptcha_verification_url, recaptcha_params, (response) ->
      if response is 1
        # recaptcha is right, send the form
        methods.send_form()
      else
        $.error "Your recaptcha solution is wrong!"
  
  send_form: ->
    if mandrill?
      if config.mandrill_api_key?
        # init Mandrill
        m = new mandrill.Mandrill config.mandrill_api_key
        # set mandrill params
        mandrill_params =
          message:
            from_email: $("#input_email").val()
            from_name: $("#input_name").val()
            to: config.recipients
            subject: $("#input_subject").val()
            text: $("#textarea_message").val()
        # send the form
        m.messages.send mandrill_params, (res) ->
          # reset the form
          methods.reset_form()
        , (err) ->
          $.error err
      else
        $.error "can't find your Mandrill Public Key... Did you set one?"
    else
      $.error "contactform.js needs the Mandrill Javascript API... is it available?"
  
  reset_form: ->
    # reload recaptcha
    Recaptcha.reload()
    # reset the form
    config.form_element[0].reset()


$.fn.contactform = (method,options...) ->
  if methods[method]
    methods[method].apply this, options
  else if typeof method is "object" or not method
    methods.init.apply this, arguments
  else
    $.error "Method #{method} does not exist in contactform.js"