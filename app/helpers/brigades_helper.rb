# Helpers for the Brigades object.
module BrigadesHelper
  def submit_button_text(f)
    f.object.new_record? ? I18n.t('brigades.new.submit') : I18n.t('brigades.edit.submit')
  end

  def render_failed_modification(format, template, errors)
    format.html { render action: template }
    format.json { render json: errors, status: :unprocessable_entity }
  end

  def validate_url(record, attribute, value, pattern, error)
    valid = value =~ pattern
    record.errors[attribute] << error unless valid
    return record
  end
end
