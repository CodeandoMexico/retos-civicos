$ ->

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
      $(".comments .row.comment_form").slideUp()
    else
      $(".comments .row.comment_form").slideDown()
      $(".comments .row.comment_form textarea").focus();
    $(@).toggleClass "active"
    false
