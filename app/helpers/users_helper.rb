module UsersHelper

  def devise_mapping
    Devise.mappings[:user]
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end

  class Render
    class << self
      attr_accessor :h, :options

      def render_node(h, options)
        @h, @options = h, options
        node = options[:node]
        node = node.decorate unless node.decorated?
        "<li data-node-id=#{node.id} id='node_#{h.dom_id(node)}'>
          <div class='item row'>
            #{ @options[:hide_ordering] ? '' : handle }
            #{ expand }
            #{ node.tree_show }
            #{ node.tree_controls }
          </div>
          #{children}
        </li>"
      end

      def handle
        if h.current_user.admin?
          h.icon('arrows-v handle')
        end
      end

      def expand
        unless options[:just_tree].presence
          node = options[:node]
          "<b class='expand plus#{(' empty' if node.children.nested_set.count.zero?)}'>+</b>"
        end
      end

      def children
        if options[:children].present?
          "<ol class='nested_set'>#{ options[:children] }</ol>"
        end
      end
    end
  end
end

