# Q1.
# 次の動作をする A1 class を実装する
# - "//" を返す "//"メソッドが存在すること

class A1
  define_method "//" do
    "//"
  end
end

# Q2.
# 次の動作をする A2 class を実装する
# - 1. "SmartHR Dev Team"と返すdev_teamメソッドが存在すること
# - 2. initializeに渡した配列に含まれる値に対して、"hoge_" をprefixを付与したメソッドが存在すること
# - 2で定義するメソッドは下記とする
#   - 受け取った引数の回数分、メソッド名を繰り返した文字列を返すこと
#   - 引数がnilの場合は、dev_teamメソッドを呼ぶこと
# - また、2で定義するメソッドは以下を満たすものとする
#   - メソッドが定義されるのは同時に生成されるオブジェクトのみで、別のA2インスタンスには（同じ値を含む配列を生成時に渡さない限り）定義されない

class A2
  def initialize(array)
    @array = array
  end

  def dev_team
    "SmartHR Dev Team"
  end

  def method_missing(method, *args)
    if args[0].nil?
      dev_team
    else
      str = ""
      args[0].times { str += method.to_s }
      str
    end
  end
end

# Q3.
# 次の動作をする OriginalAccessor モジュール を実装する
# - OriginalAccessorモジュールはincludeされたときのみ、my_attr_accessorメソッドを定義すること
# - my_attr_accessorはgetter/setterに加えて、boolean値を代入した際のみ真偽値判定を行うaccessorと同名の?メソッドができること

module OriginalAccessor
  # インスタンスメソッドとして呼び出すにはclass_evalが必要
  # クラスメソッドとして呼び出すときには単純にメソッド定義すればいい
  def self.included(mod)
    mod.class_eval do
      def self.my_attr_accessor(name)
        define_method name do
          instance_variable_get "@#{name}"
        end

        define_method "#{name}=" do |value|
          instance_variable_set("@#{name}", value)

          if value.is_a?(FalseClass) || value.is_a?(TrueClass)
            # なんでdefine_methodじゃなくて、define_singleton_methodじゃないとあかん？
            # クロージャがまだ理解できていない
            # define_singleton_methodを使えばスコープ外の変数も参照できるということは分かった
            define_singleton_method "#{name}?" do
              value
            end
          end
        end
      end
    end
  end
end
