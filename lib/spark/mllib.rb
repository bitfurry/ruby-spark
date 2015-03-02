module Spark
  module Mllib
    # Linear algebra
    autoload :DenseVector,  'spark/mllib/vector'
    autoload :SparseVector, 'spark/mllib/vector'

    # Regression
    autoload :LabeledPoint,            'spark/mllib/regression'
    autoload :LinearModel,             'spark/mllib/regression'
    autoload :LinearRegressionModel,   'spark/mllib/regression'
    autoload :LinearRegressionWithSGD, 'spark/mllib/regression'
    autoload :LassoModel,              'spark/mllib/regression'
    autoload :LassoWithSGD,            'spark/mllib/regression'
    autoload :RidgeRegressionModel,    'spark/mllib/regression'
    autoload :RidgeRegressionWithSGD,  'spark/mllib/regression'

    def self.prepare
      return if @prepared

      if narray?
        require 'spark/mllib/narray/vector'
      elsif mdarray?
        require 'spark/mllib/mdarray/vector'
      else
        require 'spark/mllib/matrix/vector'
      end

      @prepared = true
      nil
    end

    def self.load
      return if @loaded

      prepare

      Object.const_set(:DenseVector, DenseVector)
      Object.const_set(:SparseVector, SparseVector)
      Object.const_set(:LabeledPoint, LabeledPoint)
      Object.const_set(:LinearModel, LinearModel)
      Object.const_set(:LinearRegressionModel, LinearRegressionModel)
      Object.const_set(:LinearRegressionWithSGD, LinearRegressionWithSGD)
      Object.const_set(:LassoModel, LassoModel)
      Object.const_set(:LassoWithSGD, LassoWithSGD)
      Object.const_set(:RidgeRegressionModel, RidgeRegressionModel)
      Object.const_set(:RidgeRegressionWithSGD, RidgeRegressionWithSGD)

      @loaded = true
      nil
    end

    def self.narray?
      Gem::Specification::find_all_by_name('narray').any?
    end

    def self.mdarray?
      Gem::Specification::find_all_by_name('mdarray').any?
    end
  end
end

Spark::Mllib.prepare