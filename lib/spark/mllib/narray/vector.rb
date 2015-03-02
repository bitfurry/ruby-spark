require 'narray'

module Spark
  module Mllib
    class BaseVector

      attr_reader :__vector__

      def initialize(stype, *args)
        case stype.to_s.downcase
        when 'dense'
          init_as_dense(*args)
        when 'sparse'
          init_as_sparse(*args)
        else
          raise ArgumentError, 'Vector must be Dense or Sparse.'
        end
      end

      def init_as_dense(*args)
        values = args.shift
        @__vector__ = NVector.new('float', values.size)
        self[] = values
      end

      def init_as_sparse(*args)
        size = args.shift
        @__vector__ = NVector.new('float', size)
        fill!(0)
      end

      def dot(vector)
        if vector.is_a?(BaseVector)
          self * vector.__vector__
        else
          self * vector
        end
      end

      def squared_distance(vector)
        unless vector.is_a?(BaseVector)
          raise Spark::MllibError, 'Vector must be instance of Vector'
        end

        (self - vector) ** 2
      end

      def values
        to_a
      end

      # NArray is initialized on `self.new` instead of `initialize`
      def method_missing(method, *args, &block)
        args.map! do |arg|
          if arg.is_a?(BaseVector)
            arg.__vector__
          else
            arg
          end
        end

        @__vector__.__send__(method, *args, &block)
      end

    end
  end
end