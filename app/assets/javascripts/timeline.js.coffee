$ ->
  if $("#activities").length > 0
    createStoryJS {
      type:       'timeline'
      width:      '100%'
      height:     '490'
      source:     "#{location.pathname}/timeline"
      embed_id:   'timeline'
    }
