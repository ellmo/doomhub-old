module SimpleForm

  module Inputs
    class ZurbBoolean < BooleanInput

      def label_input
        html_to_wrap = ''
        if options[:label] == false
          html_to_wrap = input
        elsif nested_boolean_style?
          html_options = label_html_options.dup
          html_options[:class].push :checkbox
          html_options[:class].push "zurb-checkbox-container-label"

          html_to_wrap = @builder.label(label_target, html_options) {
            build_check_box_without_hidden_field
          }
        else
          html_to_wrap = label + input
        end
        template.content_tag(:div, {:class => 'zurb-checkbox-row'}) { html_to_wrap }
      end

      def build_check_box(unchecked_value='0')
        name = "#{object_name}[#{attribute_name}]"
        checked = object[attribute_name]
        hidden_input = template.tag(:input, {
<<<<<<< .merge_file_vfCKR8
          :type => "checkbox",
          :tabindex => -1,
          :style => "display: none;",
          :name => name,
          :id => [object_name.to_s, attribute_name.to_s].join("_"),
          :checked => checked
=======
          :type => "text",
          :tabindex => -1,
          :value => checked ? "1" : "0",
          :style => "display: none;",
          :name => name,
          :id => [object_name.to_s, attribute_name.to_s].join("_")
>>>>>>> .merge_file_WXo9c8
        })
        dummy_span = template.content_tag(:span, "", {
          :rel => name,
          :tabindex => 0,
          :class => "custom checkbox zurb-checkbox-span-thingy#{checked ? ' checked' : ''}"
        })
        label_span = template.content_tag(:span, {:class => 'zurb-checkbox-label'}) {label_text}
        hidden_input + dummy_span + label_span
      end

    end
  end

  class FormBuilder
    map_type :zurb_boolean, :to => SimpleForm::Inputs::ZurbBoolean
  end

end