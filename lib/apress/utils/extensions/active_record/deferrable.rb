# coding: utf-8
# http://hashrocket.com/blog/posts/deferring-database-constraints
module Apress::Utils::Extensions::ActiveRecord::Deferrable
  def deferrable_uniqueness_constraints_on(column_name)
    usage = Arel::Table.new 'information_schema.constraint_column_usage'
    constraint = Arel::Table.new 'pg_constraint'
    arel = usage.project(usage[:constraint_name])
    .join(constraint).on(usage[:constraint_name].eq(constraint[:conname]))
    .where(
      (constraint[:contype].eq('u'))
      .and(constraint[:condeferrable])
      .and(usage[:table_name].eq(table_name))
      .and(usage[:column_name].eq(column_name))
    )
    connection.select_values arel
  end

  def transaction_with_deferred_constraints_on(column_name, options = {})
    transaction(options) do
      constraints = deferrable_uniqueness_constraints_on(column_name).join ","
      connection.execute("SET CONSTRAINTS %s DEFERRED" % constraints)
      yield
    end
  end
end