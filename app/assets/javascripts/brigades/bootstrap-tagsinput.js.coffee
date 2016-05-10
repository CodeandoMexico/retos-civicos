(($) ->

  ###*
  # Constructor function
  ###

  TagsInput = (element, options) ->
    @itemsArray = []
    @$element = $(element)
    @$element.hide()
    @isSelect = element.tagName == 'SELECT'
    @multiple = @isSelect and element.hasAttribute('multiple')
    @objectItems = options and options.itemValue
    @placeholderText = if element.hasAttribute('placeholder') then @$element.attr('placeholder') else ''
    @inputSize = Math.max(1, @placeholderText.length)
    @$container = $('<div class="bootstrap-tagsinput"></div>')
    @$input = $('<input type="text" placeholder="' + @placeholderText + '"/>').appendTo(@$container)
    @$element.before @$container
    @build options
    return

  ###*
  # Most options support both a string or number as well as a function as
  # option value. This function makes sure that the option with the given
  # key in the given options is wrapped in a function
  ###

  makeOptionItemFunction = (options, key) ->
    if typeof options[key] != 'function'
      propertyName = options[key]

      options[key] = (item) ->
        item[propertyName]

    return

  makeOptionFunction = (options, key) ->
    if typeof options[key] != 'function'
      value = options[key]

      options[key] = ->
        value

    return

  htmlEncode = (value) ->
    if value
      htmlEncodeContainer.text(value).html()
    else
      ''

  ###*
  # Returns the position of the caret in the given input field
  # http://flightschool.acylt.com/devnotes/caret-position-woes/
  ###

  doGetCaretPosition = (oField) ->
    iCaretPos = 0
    if document.selection
      oField.focus()
      oSel = document.selection.createRange()
      oSel.moveStart 'character', -oField.value.length
      iCaretPos = oSel.text.length
    else if oField.selectionStart or oField.selectionStart == '0'
      iCaretPos = oField.selectionStart
    iCaretPos

  ###*
    * Returns boolean indicates whether user has pressed an expected key combination.
    * @param object keyPressEvent: JavaScript event object, refer
    *     http://www.w3.org/TR/2003/WD-DOM-Level-3-Events-20030331/ecma-script-binding.html
    * @param object lookupList: expected key combinations, as in:
    *     [13, {which: 188, shiftKey: true}]
  ###

  keyCombinationInList = (keyPressEvent, lookupList) ->
    found = false
    $.each lookupList, (index, keyCombination) ->
      if typeof keyCombination == 'number' and keyPressEvent.which == keyCombination
        found = true
        return false
      if keyPressEvent.which == keyCombination.which
        alt = !keyCombination.hasOwnProperty('altKey') or keyPressEvent.altKey == keyCombination.altKey
        shift = !keyCombination.hasOwnProperty('shiftKey') or keyPressEvent.shiftKey == keyCombination.shiftKey
        ctrl = !keyCombination.hasOwnProperty('ctrlKey') or keyPressEvent.ctrlKey == keyCombination.ctrlKey
        if alt and shift and ctrl
          found = true
          return false
      return
    found

  'use strict'
  defaultOptions =
    tagClass: (item) ->
      'label label-info'
    itemValue: (item) ->
      if item then item.toString() else item
    itemText: (item) ->
      @itemValue item
    itemTitle: (item) ->
      null
    freeInput: true
    addOnBlur: true
    maxTags: undefined
    maxChars: undefined
    confirmKeys: [
      13
      44
      32
    ]
    delimiter: ','
    delimiterRegex: null
    cancelConfirmKeysOnEmpty: true
    onTagExists: (item, $tag) ->
      $tag.hide().fadeIn()
      return
    trimValue: false
    allowDuplicates: false
  TagsInput.prototype =
    constructor: TagsInput
    add: (item, dontPushVal, options) ->
      self = this
      if self.options.maxTags and self.itemsArray.length >= self.options.maxTags
        return
      # Ignore falsey values, except false
      if item != false and !item
        return
      # Trim value
      if typeof item == 'string' and self.options.trimValue
        item = $.trim(item)
      # Throw an error when trying to add an object while the itemValue option was not set
      if typeof item == 'object' and !self.objectItems
        throw 'Can\'t add objects when itemValue option is not set'
      # Ignore strings only containg whitespace
      if item.toString().match(/^\s*$/)
        return
      # If SELECT but not multiple, remove current tag
      if self.isSelect and !self.multiple and self.itemsArray.length > 0
        self.remove self.itemsArray[0]
      if typeof item == 'string' and @$element[0].tagName == 'INPUT'
        delimiter = if self.options.delimiterRegex then self.options.delimiterRegex else self.options.delimiter
        items = item.split(delimiter)
        if items.length > 1
          i = 0
          while i < items.length
            @add items[i], true
            i++
          if !dontPushVal
            self.pushVal()
          return
      itemValue = self.options.itemValue(item)
      itemText = self.options.itemText(item)
      tagClass = self.options.tagClass(item)
      itemTitle = self.options.itemTitle(item)
      # Ignore items allready added
      existing = $.grep(self.itemsArray, (item) ->
        self.options.itemValue(item) == itemValue
      )[0]
      if existing and !self.options.allowDuplicates
# Invoke onTagExists
        if self.options.onTagExists
          $existingTag = $('.tag', self.$container).filter(->
            $(this).data('item') == existing
          )
          self.options.onTagExists item, $existingTag
        return
      # if length greater than limit
      if self.items().toString().length + item.length + 1 > self.options.maxInputLength
        return
      # raise beforeItemAdd arg
      beforeItemAddEvent = $.Event('beforeItemAdd',
        item: item
        cancel: false
        options: options)
      self.$element.trigger beforeItemAddEvent
      if beforeItemAddEvent.cancel
        return
      # register item in internal array and map
      self.itemsArray.push item
      # add a tag element
      $tag = $('<span class="tag ' + htmlEncode(tagClass) + (if itemTitle != null then '" title="' + itemTitle else '') + '">' + htmlEncode(itemText) + '<span data-role="remove"></span></span>')
      $tag.data 'item', item
      self.findInputWrapper().before $tag
      $tag.after ' '
      # add <option /> if item represents a value not present in one of the <select />'s options
      if self.isSelect and !$('option[value="' + encodeURIComponent(itemValue) + '"]', self.$element)[0]
        $option = $('<option selected>' + htmlEncode(itemText) + '</option>')
        $option.data 'item', item
        $option.attr 'value', itemValue
        self.$element.append $option
      if !dontPushVal
        self.pushVal()
      # Add class when reached maxTags
      if self.options.maxTags == self.itemsArray.length or self.items().toString().length == self.options.maxInputLength
        self.$container.addClass 'bootstrap-tagsinput-max'
      self.$element.trigger $.Event('itemAdded',
        item: item
        options: options)
      return
    remove: (item, dontPushVal, options) ->
      self = this
      if self.objectItems
        if typeof item == 'object'
          item = $.grep(self.itemsArray, (other) ->
            self.options.itemValue(other) == self.options.itemValue(item)
          )
        else
          item = $.grep(self.itemsArray, (other) ->
            self.options.itemValue(other) == item
          )
        item = item[item.length - 1]
      if item
        beforeItemRemoveEvent = $.Event('beforeItemRemove',
          item: item
          cancel: false
          options: options)
        self.$element.trigger beforeItemRemoveEvent
        if beforeItemRemoveEvent.cancel
          return
        $('.tag', self.$container).filter(->
          $(this).data('item') == item
        ).remove()
        $('option', self.$element).filter(->
          $(this).data('item') == item
        ).remove()
        if $.inArray(item, self.itemsArray) != -1
          self.itemsArray.splice $.inArray(item, self.itemsArray), 1
      if !dontPushVal
        self.pushVal()
      # Remove class when reached maxTags
      if self.options.maxTags > self.itemsArray.length
        self.$container.removeClass 'bootstrap-tagsinput-max'
      self.$element.trigger $.Event('itemRemoved',
        item: item
        options: options)
      return
    removeAll: ->
      self = this
      $('.tag', self.$container).remove()
      $('option', self.$element).remove()
      while self.itemsArray.length > 0
        self.itemsArray.pop()
      self.pushVal()
      return
    refresh: ->
      self = this
      $('.tag', self.$container).each ->
        $tag = $(this)
        item = $tag.data('item')
        itemValue = self.options.itemValue(item)
        itemText = self.options.itemText(item)
        tagClass = self.options.tagClass(item)
        # Update tag's class and inner text
        $tag.attr 'class', null
        $tag.addClass 'tag ' + htmlEncode(tagClass)
        $tag.contents().filter(->
          @nodeType == 3
        )[0].nodeValue = htmlEncode(itemText)
        if self.isSelect
          option = $('option', self.$element).filter(->
            $(this).data('item') == item
          )
          option.attr 'value', itemValue
        return
      return
    items: ->
      @itemsArray
    pushVal: ->
      self = this
      val = $.map(self.items(), (item) ->
        self.options.itemValue(item).toString()
      )
      self.$element.val(val, true).trigger 'change'
      return
    build: (options) ->
      self = this
      self.options = $.extend({}, defaultOptions, options)
      # When itemValue is set, freeInput should always be false
      if self.objectItems
        self.options.freeInput = false
      makeOptionItemFunction self.options, 'itemValue'
      makeOptionItemFunction self.options, 'itemText'
      makeOptionFunction self.options, 'tagClass'
      # Typeahead Bootstrap version 2.3.2
      if self.options.typeahead
        typeahead = self.options.typeahead or {}
        makeOptionFunction typeahead, 'source'
        self.$input.typeahead $.extend({}, typeahead,
          source: (query, process) ->

            processItems = (items) ->
              texts = []
              i = 0
              while i < items.length
                text = self.options.itemText(items[i])
                map[text] = items[i]
                texts.push text
                i++
              process texts
              return

            @map = {}
            map = @map
            data = typeahead.source(query)
            if $.isFunction(data.success)
# support for Angular callbacks
              data.success processItems
            else if $.isFunction(data.then)
# support for Angular promises
              data.then processItems
            else
# support for functions and jquery promises
              $.when(data).then processItems
            return
          updater: (text) ->
            self.add @map[text]
            @map[text]
          matcher: (text) ->
            text.toLowerCase().indexOf(@query.trim().toLowerCase()) != -1
          sorter: (texts) ->
            texts.sort()
          highlighter: (text) ->
            regex = new RegExp('(' + @query + ')', 'gi')
            text.replace regex, '<strong>$1</strong>'
        )
      # typeahead.js
      if self.options.typeaheadjs
        typeaheadConfig = null
        typeaheadDatasets = {}
        # Determine if main configurations were passed or simply a dataset
        typeaheadjs = self.options.typeaheadjs
        if $.isArray(typeaheadjs)
          typeaheadConfig = typeaheadjs[0]
          typeaheadDatasets = typeaheadjs[1]
        else
          typeaheadDatasets = typeaheadjs
        self.$input.typeahead(typeaheadConfig, typeaheadDatasets).on 'typeahead:selected', $.proxy(((obj, datum) ->
          if typeaheadDatasets.valueKey
            self.add datum[typeaheadDatasets.valueKey]
          else
            self.add datum
          self.$input.typeahead 'val', ''
          return
        ), self)
      self.$container.on 'click', $.proxy(((event) ->
        if !self.$element.attr('disabled')
          self.$input.removeAttr 'disabled'
        self.$input.focus()
        return
      ), self)
      if self.options.addOnBlur and self.options.freeInput
        self.$input.on 'focusout', $.proxy(((event) ->
# HACK: only process on focusout when no typeahead opened, to
#       avoid adding the typeahead text as tag
          if $('.typeahead, .twitter-typeahead', self.$container).length == 0
            self.add self.$input.val()
            self.$input.val ''
          return
        ), self)
      self.$container.on 'keydown', 'input', $.proxy(((event) ->
        $input = $(event.target)
        $inputWrapper = self.findInputWrapper()
        if self.$element.attr('disabled')
          self.$input.attr 'disabled', 'disabled'
          return
        switch event.which
# BACKSPACE
          when 8
            if doGetCaretPosition($input[0]) == 0
              prev = $inputWrapper.prev()
              if prev.length
                self.remove prev.data('item')
# DELETE
          when 46
            if doGetCaretPosition($input[0]) == 0
              next = $inputWrapper.next()
              if next.length
                self.remove next.data('item')
# LEFT ARROW
          when 37
# Try to move the input before the previous tag
            $prevTag = $inputWrapper.prev()
            if $input.val().length == 0 and $prevTag[0]
              $prevTag.before $inputWrapper
              $input.focus()
# RIGHT ARROW
          when 39
# Try to move the input after the next tag
            $nextTag = $inputWrapper.next()
            if $input.val().length == 0 and $nextTag[0]
              $nextTag.after $inputWrapper
              $input.focus()
        # ignore
        # Reset internal input's size
        textLength = $input.val().length
        wordSpace = Math.ceil(textLength / 5)
        size = textLength + wordSpace + 1
        $input.attr 'size', Math.max(@inputSize, $input.val().length)
        return
      ), self)
      self.$container.on 'keypress', 'input', $.proxy(((event) ->
        $input = $(event.target)
        if self.$element.attr('disabled')
          self.$input.attr 'disabled', 'disabled'
          return
        text = $input.val()
        maxLengthReached = self.options.maxChars and text.length >= self.options.maxChars
        if self.options.freeInput and (keyCombinationInList(event, self.options.confirmKeys) or maxLengthReached)
# Only attempt to add a tag if there is data in the field
          if text.length != 0
            self.add if maxLengthReached then text.substr(0, self.options.maxChars) else text
            $input.val ''
          # If the field is empty, let the event triggered fire as usual
          if self.options.cancelConfirmKeysOnEmpty == false
            event.preventDefault()
        # Reset internal input's size
        textLength = $input.val().length
        wordSpace = Math.ceil(textLength / 5)
        size = textLength + wordSpace + 1
        $input.attr 'size', Math.max(@inputSize, $input.val().length)
        return
      ), self)
      # Remove icon clicked
      self.$container.on 'click', '[data-role=remove]', $.proxy(((event) ->
        if self.$element.attr('disabled')
          return
        self.remove $(event.target).closest('.tag').data('item')
        return
      ), self)
      # Only add existing value as tags when using strings as tags
      if self.options.itemValue == defaultOptions.itemValue
        if self.$element[0].tagName == 'INPUT'
          self.add self.$element.val()
        else
          $('option', self.$element).each ->
            self.add $(this).attr('value'), true
            return
      return
    destroy: ->
      self = this
      # Unbind events
      self.$container.off 'keypress', 'input'
      self.$container.off 'click', '[role=remove]'
      self.$container.remove()
      self.$element.removeData 'tagsinput'
      self.$element.show()
      return
    focus: ->
      @$input.focus()
      return
    input: ->
      @$input
    findInputWrapper: ->
      elt = @$input[0]
      container = @$container[0]
      while elt and elt.parentNode != container
        elt = elt.parentNode
      $ elt

  ###*
  # Register JQuery plugin
  ###

  $.fn.tagsinput = (arg1, arg2, arg3) ->
    results = []
    @each ->
      `var retVal`
      tagsinput = $(this).data('tagsinput')
      # Initialize a new tags input
      if !tagsinput
        tagsinput = new TagsInput(this, arg1)
        $(this).data 'tagsinput', tagsinput
        results.push tagsinput
        if @tagName == 'SELECT'
          $('option', $(this)).attr 'selected', 'selected'
        # Init tags from $(this).val()
        $(this).val $(this).val()
      else if !arg1 and !arg2
# tagsinput already exists
# no function, trying to init
        results.push tagsinput
      else if tagsinput[arg1] != undefined
# Invoke function on existing tags input
        if tagsinput[arg1].length == 3 and arg3 != undefined
          retVal = tagsinput[arg1](arg2, null, arg3)
        else
          retVal = tagsinput[arg1](arg2)
        if retVal != undefined
          results.push retVal
      return
    if typeof arg1 == 'string'
# Return the results from the invoked function calls
      if results.length > 1 then results else results[0]
    else
      results

  $.fn.tagsinput.Constructor = TagsInput

  ###*
  # HtmlEncodes the given value
  ###

  htmlEncodeContainer = $('<div />')

  ###*
  # Initialize tagsinput behaviour on inputs and selects which have
  # data-role=tagsinput
  ###

  $ ->
    $('input[data-role=tagsinput], select[multiple][data-role=tagsinput]').tagsinput()
    return
  return
) window.jQuery

# ---
# generated by js2coffee 2.2.0