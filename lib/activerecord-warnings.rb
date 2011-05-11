require 'active_record'
require 'active_record/base'
require 'active_record/validations'

module ActiveRecord #:nodoc:
  module Warnings 
    module InstanceMethods
      # The warnings that are set on this record, equivalent to normal ActiveRecord errors but does not prevent
      # the record from saving.
      def warnings
        @warnings ||= ActiveRecord::Errors.new(self)
      end

      # Does this record have warnings?
      def warnings?
        not @warnings.empty?
      end
    end

    def self.extended(base) #:nodoc:
      base.class_eval do
        include InstanceMethods
      end
      base.singleton_class.class_eval do
        ::ActiveRecord::Validations::VALIDATIONS.each do |validation|
          alias_method(:"#{validation}_for_errors", validation)
        end
      end
    end

    # Wraps instances of ActiveRecord::Base so that the `errors` method actually uses the warnings.
    class WarningProxy < ActiveSupport::BasicObject #:nodoc:
      def initialize(owner)
        @owner = owner
      end

      def errors
        @owner.warnings
      end

      def respond_to?(name, include_private = false)
        super or @owner.respond_to?(name, include_private)
      end

      def method_missing(*args, &block)
        @owner.send(*args, &block)
      end
    end

    # Describes a set of standard ActiveRecord validations that should not prevent the instance from being
    # saved but could cause warnings that need to be presented to the user.
    def warnings(&block)
      switch_validations(:warnings)
      instance_eval(&block)
    ensure
      switch_validations(:errors)
    end

    def switch_validations(context) #:nodoc:
      singleton_class.class_eval do
        ::ActiveRecord::Validations::VALIDATIONS.each do |validation|
          alias_method(validation, :"#{validation}_for_#{context}")
        end
      end
    end
    private :switch_validations

    ::ActiveRecord::Validations::VALIDATIONS.each do |validation|
      line = __LINE__ + 1
      class_eval(%Q{
        def #{validation}_for_warnings(*args, &block)
          #{validation}_for_errors(*args) { |record| yield(WarningProxy.new(record)) }
        end
      }, __FILE__, line)
    end
  end
end

class ActiveRecord::Base #:nodoc:
  extend ActiveRecord::Warnings
end
