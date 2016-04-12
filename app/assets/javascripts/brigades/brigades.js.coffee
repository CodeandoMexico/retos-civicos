$(window).load ->
  if window.currentController == "brigades"
    setFooterMargin = ->
      brigades = $("#brigades")
      footer = $("#footer")
      brigades_height = brigades.height()
      footer.css('top', brigades_height+150)
      footer.css('position', 'absolute')
      footer.css('width', '100%')

      $( window ).resize ->
        setFooterMargin()

    setFooterMargin()