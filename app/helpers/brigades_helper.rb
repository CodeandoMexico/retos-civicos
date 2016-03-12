module BrigadesHelper
  def submit_button_text(f)
    f.object.new_record? ? I18n.t('brigades.new.submit') : ''
  end
end
