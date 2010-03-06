module Melbourne

  module AST

    class ReducedGraph

      def initialize(ast)
        @graph = {}
        graph_node(ast)
      end

      def to_hash
        @graph
      end

      private

        def graph_node(node, parent = @graph)
          return if node.kind_of?(Nil)
          name         = format_class_name(node.class)
          parent[name] = {}

          node.instance_variables.each do |instance_variable|
            next if instance_variable == '@compiler'
            value = node.instance_variable_get(instance_variable)
            graph_instance_variable(instance_variable, value, parent[name])
          end
        end

        def graph_instance_variable(variable, value, parent)
          if value.kind_of?(Node)
            graph_node(value, parent[variable.to_sym] = {})
          elsif value.kind_of?(Array)
            parent = parent[variable.to_sym] = []
            value.each do |element|
              if element.kind_of?(Node)
                graph_node(element, (parent << {}).last)
              else
                parent << format_value(element)
              end
            end
          else
            parent[variable.to_sym] = format_value(value)
          end
        end

        def format_value(value)
          case value
            when NilClass, TrueClass, FalseClass, Symbol, Fixnum
              value
            else
              value.to_s.empty? ? :'<blank>' : value.to_s.to_sym
            end
        end

        def format_class_name(klass)
          klass.to_s.split('::').last.downcase.to_sym
        end

    end

  end

end
