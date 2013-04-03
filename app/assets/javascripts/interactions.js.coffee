$ ->

  setTimeout ->
    hideFlashMessages()
  ,3000

  hideFlashMessages = ->
    $(".alert, .success, .notice, .error").fadeOut('slow')

  $("#i18n_locale").change ->
    $(@).parents("form").submit()

  $(".comments .box.com").on "click", ".reply", ->
    if $(@).hasClass("active")
      if $(@).siblings(".form").find("input#comment_body").val() isnt ""
        $(@).siblings(".form").find("form").submit();
      $(@).siblings(".form").slideUp()
    else
      $(@).siblings(".form").slideDown()
      $(@).siblings(".form").find("input").focus();
    $(@).toggleClass "active"
    false

  $(".comments").on "click", "a.comment", ->
    if $(@).hasClass("active")
      $(".comments .comment_form").slideUp()
    else
      $(".comments .comment_form").slideDown()
      $(".comments .comment_form textarea").focus();
    $(@).toggleClass "active"
    false
