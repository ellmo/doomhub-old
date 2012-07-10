module SimpleForm

  module Inputs
    class ZurbBoolean < BooleanInput

      def label_input
        if options[:label] == false
          input
        elsif nested_boolean_style?
          html_options = label_html_options.dup
          html_options[:class].push :checkbox
          html_options[:class].push "zurb-checkbox-container-label"

          @builder.label(label_target, html_options) {
            template.content_tag(:label, label_text) +
            build_check_box_without_hidden_field
          }
        else
          label + input
        end
      end

      def build_check_box(unchecked_value='0')
        name = "#{object_name}[#{attribute_name}]"
        template.tag(:input, {:type => "checkbox", :tabindex => -1, :style => "display: none;",
          :name => name,
          :id => [object_name.to_s, attribute_name.to_s].join("_")}) +
        template.content_tag(:span, "", { :rel => name, :tabindex => 0, :class => "custom checkbox zurb-checkbox-span-thingy"})
      end

    end
  end

  class FormBuilder
    map_type :zurb_boolean, :to => SimpleForm::Inputs::ZurbBoolean
  end

end