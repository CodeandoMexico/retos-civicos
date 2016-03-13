module ApplicationHelper
  class TargetBlankRenderer < Redcarpet::Render::HTML
    def initialize(extensions = {})
      super extensions.merge(link_attributes: { target: '_blank' })
    end
  end

  def logo(path, options = {})
    processed_path = if path.nil?
                       ENV['LOGO']
                     else
                       path
                     end
    image_tag processed_path, options
  end

  def image_url(source)
    abs_path = image_path(source)
    abs_path = "#{request.protocol}#{request.host_with_port}#{abs_path}" unless abs_path =~ /^http/
    abs_path
  end

  # Dynamic current userable method depending on the user's role
  # Example: if current_user is a member you can simply call current_member
  User::ROLES.each do |role|
    define_method "current_#{role.downcase}" do
      current_user.userable if user_signed_in?
    end
  end

  def edit_current_user_path(user, new_user = nil)
    send("edit_#{user.class.name.downcase}_path", user, new_user)
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    options = {
      underline: true,
      space_after_headers: true,
      highlight: true,
      lax_spacing: true,
      autolink: true,
      no_intra_emphasis: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end

  def markdown_for_additional_links(text)
    if text.present?
      renderer = TargetBlankRenderer.new(hard_wrap: true, filter_html: true)
      options = {
        underline: true,
        space_after_headers: true,
        highlight: true,
        lax_spacing: true,
        autolink: true,
        no_intra_emphasis: true
      }
      Redcarpet::Markdown.new(renderer, options).render(text).html_safe
    end
  end

  def tab_class(activator)
    'active' if params[:controller] == activator
  end

  def filter_class(filter)
    'active' if params[:filter] == filter
  end

  def url_with_protocol(url)
    if url[/^https?/]
      url
    else
      "http://#{url}"
    end
  end

  def preview_url(url)
    content_tag :div, class: 'url-preview js-url-preview' do
      begin
        Onebox.preview(url_with_protocol(url)).to_s.html_safe
      rescue
        "La liga: #{link_to url} tardo mucho en cargar".html_safe
      end
    end
  end

  DEFAULT_KEY_MATCHING = {
    alert:      :danger,
    notice:     :success,
    info:       :info,
    secondary:  :info,
    success:    :success,
    error:      :danger,
    warning:    :warning
  }.freeze

  def display_flash_messages
    flash.reduce '' do |message, (key, value)|
      if value.is_a?(Array)
        value.each do |val|
          message += build_message(key: key, value: val, key_match: DEFAULT_KEY_MATCHING)
        end
        message
      else
        build_message(key: key, value: value, key_match: DEFAULT_KEY_MATCHING)
      end
    end.html_safe
  end

  def humanize_percentage(value, total)
    "#{compute_percentage(value, total)}%"
  end

  def compute_percentage(value, total)
    (value * 100.0 / total).ceil
  end

  def challenge_completion_percentage_for(challenge)
    if challenge.finish_on < Date.today then 100
    elsif Phases.is_current?(:ideas, challenge) then 10
    elsif Phases.is_current?(:ideas_selection, challenge) then 25
    elsif Phases.is_current?(:prototypes, challenge) then 50
    elsif Phases.is_current?(:prototypes_selection, challenge) then 75
    end
  end

  private

  def build_message(args)
    alert_class_suffix = args[:key_match][args[:key].to_sym] || :standard
    html = content_tag :div, data: { alert: '' },
                       class: "alert alert-#{alert_class_suffix} alert-dismissible",
                       style: 'margin: 15px 0 15px 0' do
      raw "<button type='button' class='close' data-dismiss='alert' aria-label='Close'>
           <span aria-hidden='true'>&times;</span></button>
           #{args[:value]}"
    end
    html.html_safe
  end
end
