$(window).load ->
  if window.currentController == "brigades"
    originalCreationFormHtml = []
    setFooterMargin = ->
      brigades = $("#brigades")
      footer = $("#footer")
      brigades_height = brigades.height()
      footer.css('top', brigades_height+150)
      footer.css('position', 'absolute')
      footer.css('width', '100%')

      $( window ).resize ->
        setFooterMargin()
    setFormAttrs = (buttonText, action, actualMethod, theoreticalMethod) ->
      $('.create-edit-project-form .positive-button').val(buttonText)
      $('.create-edit-project-form').attr('action', action)
      $('.create-edit-project-form').attr('method', actualMethod)
      $('#_method').val(theoreticalMethod)

    setFormElems = (title, description, tags) ->
      $('#brigade_project_title').val(title)
      $('#brigade_project_description').val(description)
      $('.tags-input-container').tagsinput('removeAll')
      $('.tags-input-container').tagsinput('add', "")
      $.each tags, (i) ->
        $('.tags-input-container').tagsinput('add', tags[i].name)

    setupEditModal = (elem) ->
      projectId = elem.data('project-id')
      $.ajax
        url: "/brigade-projects/#{projectId}/edit"
        type: 'GET'
        dataType: 'json'
        success: (data) ->
          data.brigade_project = JSON.parse(data.brigade_project)
          setFormAttrs(data.button_text, "/brigade-projects/#{projectId}", 'post', 'put')
          setFormElems(data.brigade_project.title, data.brigade_project.description, data.brigade_project.tags)

    setupCreateModal = ->
      $('.create-edit-project-form').html(originalCreationFormHtml)

    setOriginalCreationFormHtml = ->
      originalCreationFormHtml = $('.create-edit-project-form').html()

    setListeners = ->
      $('.edit-project-link').click(->
        elem = $(this)
        setupEditModal(elem)
      )

      $('.add-project-text').click(->
        setupCreateModal()
      )

    setup = ->
      setFooterMargin()
      setListeners()
      setOriginalCreationFormHtml()

    setup()