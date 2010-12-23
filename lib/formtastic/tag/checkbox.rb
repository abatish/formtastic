module Formtastic
  module Checkbox
    protected
    # Outputs a fieldset containing a legend for the label text, and an ordered list (ol) of list
    # items, one for each possible choice in the belongs_to association.  Each li contains a
    # label and a check_box input.
    #
    # This is an alternative for has many and has and belongs to many associations.
    #
    # Example:
    #
    #   f.input :author, :as => :check_boxes
    #
    # Output:
    #
    #   <fieldset>
    #     <legend class="label"><label>Authors</label></legend>
    #     <ol>
    #       <li>
    #         <input type="hidden" name="book[author_id][1]" value="">
    #         <label for="book_author_id_1"><input id="book_author_id_1" name="book[author_id][1]" type="checkbox" value="1" /> Justin French</label>
    #       </li>
    #       <li>
    #         <input type="hidden" name="book[author_id][2]" value="">
    #         <label for="book_author_id_2"><input id="book_author_id_2" name="book[owner_id][2]" type="checkbox" value="2" /> Kate French</label>
    #       </li>
    #     </ol>
    #   </fieldset>
    #
    # Notice that the value of the checkbox is the same as the id and the hidden
    # field has empty value. You can override the hidden field value using the
    # unchecked_value option.
    #
    # You can customize the options available in the set by passing in a collection (Array) of
    # ActiveRecord objects through the :collection option.  If not provided, the choices are found
    # by inferring the parent's class name from the method name and simply calling all on
    # it (Author.all in the example above).
    #
    # Examples:
    #
    #   f.input :author, :as => :check_boxes, :collection => @authors
    #   f.input :author, :as => :check_boxes, :collection => Author.all
    #   f.input :author, :as => :check_boxes, :collection => [@justin, @kate]
    #
    # The :label_method option allows you to customize the label for each checkbox two ways:
    #
    # * by naming the correct method to call on each object in the collection as a symbol (:name, :login, etc)
    # * by passing a Proc that will be called on each object in the collection, allowing you to use helpers or multiple model attributes together
    #
    # Examples:
    #
    #   f.input :author, :as => :check_boxes, :label_method => :full_name
    #   f.input :author, :as => :check_boxes, :label_method => :login
    #   f.input :author, :as => :check_boxes, :label_method => :full_name_with_post_count
    #   f.input :author, :as => :check_boxes, :label_method => Proc.new { |a| "#{a.name} (#{pluralize("post", a.posts.count)})" }
    #
    # The :value_method option provides the same customization of the value attribute of each checkbox input tag.
    #
    # Examples:
    #
    #   f.input :author, :as => :check_boxes, :value_method => :full_name
    #   f.input :author, :as => :check_boxes, :value_method => :login
    #   f.input :author, :as => :check_boxes, :value_method => Proc.new { |a| "author_#{a.login}" }
    #
    # Formtastic works around a bug in rails handling of check box collections by
    # not generating the hidden fields for state checking of the checkboxes
    # The :hidden_fields option provides a way to re-enable these hidden inputs by
    # setting it to true.
    #
    #   f.input :authors, :as => :check_boxes, :hidden_fields => false
    #   f.input :authors, :as => :check_boxes, :hidden_fields => true
    #
    # Finally, you can set :value_as_class => true if you want the li wrapper around each checkbox / label
    # combination to contain a class with the value of the radio button (useful for applying specific
    # CSS or Javascript to a particular checkbox).
    #
    def check_boxes_input(method, options)
      # get collection and static values
      collection = find_collection_for_column(method, options)
      html_options = options.delete(:input_html) || {}

      input_name      = generate_association_input_name(method)
      hidden_fields   = options.delete(:hidden_fields)
      value_as_class  = options.delete(:value_as_class)
      unchecked_value = options.delete(:unchecked_value) || ''
      html_options    = { :name => "#{@object_name}[#{input_name}][]" }.merge(html_options)

      selected_values = find_selected_values_for_column(method, options)
      disabled_option_is_present = options.key?(:disabled)
      disabled_values = [*options[:disabled]] if disabled_option_is_present

      li_options = value_as_class ? { :class => [method.to_s.singularize, 'default'].join('_') } : {}

      tag_builder.new.fieldset do |fieldset|
        fieldset.content legend_tag(method, options)
        fieldset.content self.create_hidden_field_for_check_boxes(input_name, value_as_class) unless hidden_fields

        fieldset.ol do |ol|
          collection.each do |item|
            label = item.is_a?(Array) ? item.first : item
            value = item.is_a?(Array) ? item.last : item
            input_id = generate_html_id(input_name, value.to_s.gsub(/\s/, '_').gsub(/\W/, '').downcase)

            html_options[:checked] = selected_values.include?(value)
            html_options[:disabled] = disabled_values.include?(value) if disabled_option_is_present
            html_options[:id] = input_id

            li_options = value_as_class ? { :class => [method.to_s.singularize, value.to_s.downcase].join('_') } : {}

            ol.li(li_options) do |li|
              checkbox_html = Formtastic::Util.html_safe("#{self.create_check_boxes(input_name, html_options, value, unchecked_value, hidden_fields)} #{escape_html_entities(label)}")
              li.label( checkbox_html, :for => input_id )
            end
          end
        end
      end
    end

    def build_li(ol, item, options)
      html_options = options[:html_options]
      input_name = options[:input_name]
      input_id = options[:input_id]

      label = item.is_a?(Array) ? item.first : item
      value = item.is_a?(Array) ? item.last : item
      input_id = generate_html_id(input_name, value.to_s.gsub(/\s/, '_').gsub(/\W/, '').downcase)

      html_options[:checked] = selected_values.include?(value)
      html_options[:disabled] = disabled_values.include?(value) if disabled_option_is_present
      html_options[:id] = input_id
    end
  end
end
