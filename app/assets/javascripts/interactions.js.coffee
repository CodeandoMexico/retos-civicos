window.closeChallengeCommentsForm = ->
  form = $('#new_comment')
  openButton = $('.js-open-comments-form')
  form.find('textarea').val('')
  form.slideUp => openButton.show()

$ ->

  setTimeout ->
    hideFlashMessages()
  ,3000

  hideFlashMessages = ->
    $(".flash").fadeOut('slow')

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


  $(document).on 'click', '.js-open-comments-form', (e) ->
    e.preventDefault()
    button = $(this)
    form = $('#new_comment')
    button.hide()
    form.slideDown()

  $(document).on 'click', '.js-close-comments-form', (e) ->
    e.preventDefault()
    closeChallengeCommentsForm()

  $(document).on 'click', '.js-open-reply-form', (e) ->
    e.preventDefault()
    button = $(this)
    form = $(this).siblings('form')
    button.hide()
    form.fadeIn()

  $(document).on 'click', '.js-close-reply-form', (e) ->
    e.preventDefault()
    form = $(this).parents('form')
    button = form.siblings('.js-open-reply-form')
    form.find('textarea').val('')
    form.fadeOut => button.show()


