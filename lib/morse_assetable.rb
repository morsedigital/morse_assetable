require "morse_assetable/version"

# MorseAssetable
module MorseAssetable # rubocop:disable Metrics/ModuleLength
  extend ActiveSupport::Concern

  included do
    attachment_names.each do |name|
      attr_accessor "#{name}_attachment".to_sym,
                    "#{name}_attachment_remove".to_sym
      next unless active_asset_column_names.any?
      active_asset_column_names.each do |col|
        attr_accessor "#{name}_attachment_#{col}".to_sym
      end
    end

    validate :process_attachments
    validate :process_multiple_attachments
  end

  # ClassMethods
  module ClassMethods
    def active_asset_column_names
      asset_column_names - excluded_asset_column_names
    end

    def asset_column_names
      Asset.column_names
    end

    def attachment_names
      [:asset]
    end

    def excluded_asset_column_names
      %w(id attachment assetable_id assetable_type created_at updated_at)
    end

    def multiple_attachment_names
      [:downloadables]
    end
  end

  private

  def active_asset_column_names
    self.class.active_asset_column_names
  end

  def add_asset_data(a)
    return unless active_asset_column_names.any?
    active_asset_column_names.each do |col|
      add_asset_field a, col
    end
  end

  def add_asset_field(a, col)
    n = "#{name}_attachment_#{col}".to_sym
    return unless send(n).present?
    a.send("#{col}=", send(n))
  end

  def attachment_name(name)
    "#{name}_attachment".to_sym
  end

  def attachment_name_remove(name)
    "#{name}_attachment_remove".to_sym
  end

  def attachment_names
    self.class.attachment_names
  end

  def multiple_attachment_names
    self.class.multiple_attachment_names
  end

  def process_attachment(name)
    n = attachment_name(name)
    a = Asset.new(attachment: send(n), assetable: self)
    add_asset_data(a)
    if a.save
      send("#{name}=", a)
      send("#{n}=", nil)
    else
      errors.add(thing, a.errors.full_messages.join(','))
      false
    end
  end

  def process_attachment?(name)
    n = attachment_name(name)
    respond_to?(n) && send(n).present?
  end

  def process_attachment_name(name)
    process_attachment(name) if process_attachment?(name)
    remove_attachment(name) if remove_attachment?(name)
  end

  def process_attachments
    return if attachment_names.empty?
    attachment_names.map { |n| process_attachment_name n }
  end

  def remove_attachment(name)
    return unless send(name).destroy
    n = attachment_name_remove(name)
    send("#{name}=", nil)
    send("#{n}=", nil)
  end

  def remove_attachment?(name)
    n = attachment_name_remove(name)
    respond_to?(n) &&
      send(n).present? &&
      send(n).to_i > 0 &&
      send(name).present?
  end

  # rubocop:disable all
  def process_multiple_attachments
    return if multiple_attachment_names.empty?
    multiple_attachment_names.each do |thing|
      at = "#{thing.to_s.singularize}_attachment".to_sym
      alt = "#{thing.to_s.singularize}_attachment_alt".to_sym
      att = "#{thing.to_s.singularize}_attachment_title".to_sym
      atr = "#{thing.to_s.singularize}_attachment_remove".to_sym
      atu = "#{thing.to_s.singularize}_attachment_url".to_sym
      if respond_to?(thing) && respond_to?(at) && send(at).present?
        a = Asset.new(attachment: send(at), title: send(att), alt: send(alt), assetable_type: self.class.name, assetable_id: id, url: send(atu))
        if a.alt.present? && a.title.blank?
          a.title = a.alt
        elsif a.alt.blank? && a.title.present?
          a.alt = a.title
        end
        if a.save
          send("#{at}=", nil)
          send("#{alt}=", nil)
          send("#{att}=", nil)
          send("#{atr}=", nil)
          send("#{atu}=", nil)
          send("#{thing.to_s.pluralize.to_sym}=", send("#{thing.to_s.pluralize.to_sym}") + [a])
        else
          errors.add(thing, a.errors.full_messages.join(','))
          return false
        end
      elsif respond_to?(atr) && send(atr).present? && send(atr).to_i > 0 && send(thing).present?
        send(thing).destroy_all
      end
    end
  end
  # rubocop:enable all
end
