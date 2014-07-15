# coding: utf-8
module Apress
  module Utils
    module Extensions
      module ActionDispatch
        module Routing
          module Mapper
            def asc_resources(*res, &block)
              resources(*res) do
                add_active_scaffold_routes
                yield if block_given?
              end
            end

            private

            def add_active_scaffold_routes
              member do
                delete :delete
              end
              collection do
                get :show_search, :update_table, :table, :nested, :delete, :row, :list, :edit_associated
              end
            end
          end
        end
      end
    end
  end
end
