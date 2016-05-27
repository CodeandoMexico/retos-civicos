# Helpers for the Brigades object.
module BrigadesHelper
  def submit_button_text(f)
    f.object.new_record? ? I18n.t('brigades.new.submit') : I18n.t('brigades.edit.submit')
  end

  def render_failed_modification(format, action, errors)
    format.html { render layout: 'aquila', action: action }
    format.json { render json: errors, status: :unprocessable_entity }
  end

  def validate_url(record, attribute, value, pattern, error)
    valid = value =~ pattern
    record.errors[attribute] << error unless valid
    record
  end

  def user_in_brigade?(curr_user, brig_id)
    curr_user && BrigadeUser.where(user_id: curr_user.id, brigade_id: brig_id).first
  end

  def user_is_organizer?(curr_user, brig_id)
    curr_user && Brigade.where(user_id: curr_user.id, id: brig_id).length > 0
  end
end
