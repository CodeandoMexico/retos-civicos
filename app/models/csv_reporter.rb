class CsvReporter
  attr_reader :record_class, :collection, :translator

  def initialize(record_class, collection, options)
    @record_class = record_class
    @collection = collection
    @translator = options.fetch(:translator)
  end

  def report_for_organization(organization)
    [file, filename: filename(organization.slug)]
  end

  def file
    CSV.generate do |csv|
      csv << report_headers
      collection.each { |record| csv << record.to_report }
    end
  end

  def filename(organization_slug)
    date = translator.l(Time.zone.now, format: :csv_filename)
    name = translator.t("#{translation_key}.csv_filename", organization: organization_slug)
    "#{date}-#{name}"
  end

  def report_headers
    csv_headers = translator.t("#{translation_key}.csv_headers")
    record_class.report_attributes.map { |attribute| csv_headers.fetch(attribute) }
  end

  def translation_key
    record_class.to_s.pluralize.underscore
  end
end
